#!/usr/bin/env bash
# 메이트립 GitHub Pages 배포 스크립트
#   사용: bash work/matetrip-pages/deploy.sh [owner] [repo]
#
# 배포 구조 (2026-11-26 기준 확인 사실)
#  - 저장소: hya910819/matetrip (public)
#  - 실제 게시 주소: https://hya910819.github.io/matetrip/  (Pages source = gh-pages / root)
#  - Pickle의 GitHub 앱 토큰에는 pages=write·administration=write·workflows 권한이 없어서
#    Pages 설정을 API로 바꾸거나 Actions 워크플로를 올릴 수 없다. 그래서 gh-pages 브랜치를
#    그대로 게시 소스로 쓰고, 배포할 때 main과 gh-pages를 함께 밀어 넣는다.
set -euo pipefail

OWNER="${1:-hya910819}"
REPO="${2:-matetrip}"
REMOTE="https://github.com/${OWNER}/${REPO}.git"
DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DIR"

echo "== 1) 원격 확인: ${OWNER}/${REPO}"
if ! gh api "/repos/${OWNER}/${REPO}" --jq '.full_name' >/dev/null 2>&1; then
  echo "리포지토리가 없습니다. https://github.com/new 에서 '${REPO}' (Public) 생성 후 다시 실행하세요."; exit 1
fi

if git remote get-url origin >/dev/null 2>&1; then git remote set-url origin "$REMOTE"; else git remote add origin "$REMOTE"; fi

echo "== 2) index.html 재빌드 반영"
python3 "$DIR/../gross-experience-v2/build.py"
cp "$DIR/../gross-experience-v2/dist/matetrip.html" "$DIR/index.html"

echo "== 3) 커밋"
git add -A
if ! git diff --cached --quiet; then
  git -c user.name="이창희" -c user.email="${OWNER}@users.noreply.github.com" \
      commit -q -m "메이트립(MATETRIP) 사이트 업데이트"
  echo "변경분 커밋 완료"
else
  echo "변경분 없음"
fi

echo "== 4) main · gh-pages 푸시"
git push origin main
git branch -f gh-pages main
git push origin gh-pages --force

echo "== 5) Pages 상태"
sleep 15
gh api "/repos/${OWNER}/${REPO}/pages" --jq '{url: .html_url, status: .status, source: .source.branch}' 2>/dev/null || true
curl -s -o /dev/null -w "live HTTP %{http_code}\n" "https://${OWNER}.github.io/${REPO}/"
echo "게시 주소: https://${OWNER}.github.io/${REPO}/"
