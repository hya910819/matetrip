# 메이트립 MATETRIP

로컬 맛집·핫플 체험단 플랫폼 **메이트립(MATETRIP)** — 운영: 그로스코리아 (GROWTH KOREA)

- 사이트: https://hya910819.github.io/matetrip/
- 빌드 원본: `index.html` (CSS·JS 인라인 단일 파일, 외부 의존 없음)

## 배포 방법

```bash
bash deploy.sh              # 재빌드 → main·gh-pages 푸시 → 접속 확인
```

GitHub Pages 게시 소스는 `gh-pages` 브랜치(`/` root)입니다. Pickle의 GitHub 앱 토큰에 Pages 설정 권한(`pages=write`, `administration=write`)이 없어 API로 `main` 소스로 바꿀 수 없기 때문에, `deploy.sh`가 `main`과 `gh-pages`를 같은 내용으로 함께 밀어 넣습니다. 나중에 저장소 Settings → Pages에서 Source를 `main / (root)`로 한 번 바꾸면 `gh-pages` 없이도 갱신됩니다.

## 구성

- **체험단 둘러보기** — 캠페인 목록·상세, 지점 선택, 신청서 작성, 피크타임 제외 시간 검증
- **마이페이지** — 신청 내역, 리뷰 제출, 자동 검수 결과
- **관리자** — 신청 관리(자동 매칭 점수 A/B/C 등급·일괄 선정), 리뷰 검수, 캠페인, 성과 리포트, 크리에이터 풀

데모 데이터로 동작하는 프론트엔드 시안이며, 실제 신청 접수는 구글 시트 웹훅 연동 시 저장됩니다.
