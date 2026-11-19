---
name: docs-writing
description: 프로젝트 문서의 위치 · 이름 · 작성 절차를 정한다. 계획(plan) · 결정 기록(decision) · 목업 · 안 비교 · 진단 리포트 · 규격 등 md/html 문서를 새로 만들거나 옮기거나 고칠 때 /plan-well · /visual-doc 호출 전에 먼저 읽는다. Trigger: /docs-writing
---

# 문서 작성

문서는 전부 저장소 루트 `docs/<시작일>-<기능>/` 안에 둔다. 루트나 `docs/` 바로 아래에 파일을 두지 않는다.

프로젝트 스킬(`.claude/skills/` · `.agents/skills/`)에 docs-writing 이 따로 있으면 그쪽이 우선. 이 파일은 기본 규칙.

## 구조

```
our-project/
  docs/
    2026-09-10-new-feature/            # 기능 · 주제 하나 = 폴더 하나. 날짜는 작업 시작일
      [new-feature] plan.md            # 계획 본문
      [new-feature] flow.html          # 계획 시각 문서 (흐름 · 범위 · 검증 · 용어)
      [new-feature] decision.md        # 결정 기록. 누적 (/plan-well §결정 기록)
      [new-feature] mockup.html        # 화면 목업 · 시안
      [new-feature] compare.html       # 여러 안 비교
      [new-feature] report.html        # 진단 · 측정 · 조사 결과
      [new-feature] spec.md            # 납품 · 연동 규격
      README.md                        # 계획이 아닌 참고 문서의 본문 (예: dev-database)
      img/                             # 이미지
```

- 폴더 이름: `<시작일>-<기능>` — 예 `2026-09-10-new-feature`
  - 시작일: 폴더를 처음 만든 날(KST). 이후 작업이 이어져도 바꾸지 않음
  - 기능: 영문 kebab-case. 작업 브랜치가 있으면 `feat/<이름>` 의 `<이름>` 과 맞춤
- 파일 이름: `[<기능>] <종류>.<확장자>` — 대괄호 + 공백 하나 + 종류
  - `[new-feature] plan.md` (O) · `plan.md` · `new-feature-plan.md` · `[new-feature]plan.md` (X)
  - 예외: `README.md` · `img/` 는 접두 없음
- 같은 종류가 둘 이상일 때만 종류 뒤에 `-<대상>` — `[new-feature] mockup-suggest.html` · `[new-feature] mockup-panel-height.html`
- `-v2` · `-final` · `option2` 같은 버전 접미사 금지. 안을 바꾸면 제자리 재작성, 여러 안은 `compare` 한 파일에 나란히
- 기능이 아닌 주제(발표 · 개발 환경 · 비교 분석)도 같은 방식으로 폴더 하나

## 절차

1. **폴더 정하기** — `ls docs/` 로 기존 폴더 확인(날짜 뒤 기능 이름으로 찾음). 같은 기능이면 날짜가 지났어도 거기에 넣음. 없을 때만 오늘 날짜로 새 폴더
2. **본문 쓰기**
   - 계획 → `/plan-well`. 산출: `[<기능>] plan.md` · `[<기능>] flow.html` · `[<기능>] decision.md`
   - 비교 · 리포트 HTML → `/visual-doc`
   - 목업 → 화면 요소만. 설명 카드 · 해설 줄 넣지 않음
3. **링크** — 파일 이름에 공백 · 대괄호가 있으므로 표기를 지킴
   - markdown: 꺾쇠로 감쌈 — `[결정](<./[new-feature] decision.md>)`
   - 다른 기능: `[계획](<../2026-09-10-new-feature/[new-feature] plan.md>)`
   - HTML `href`: 공백은 `%20` — `href="./[new-feature]%20plan.md"`
   - 절대 경로 금지
4. **셸에서 다룰 때** — 경로를 항상 따옴표로 감쌈. `"docs/2026-09-10-new-feature/[new-feature] plan.md"` (대괄호가 glob 으로 해석되는 것 방지)
5. **이미지** — 같은 폴더 `img/` 에. 다른 기능 폴더의 이미지를 끌어오지 않음
6. **메모 · 커밋에 경로 적을 때** — 폴더 포함 경로로. `docs/2026-09-10-new-feature/[new-feature] plan.md`

## 작성 규칙

- 제목 · 소제목은 분류 이름만. 문장형 카피 금지
- 본문이 진실, 그림은 그 형태. 그림에만 있는 정보 만들지 않음
- 계획 본문은 이력 남기지 않고 현재 상태로 재작성. 이력은 `decision.md` 에만 (`/plan-well` 규칙)

## 서브모듈 · 하위 저장소 docs

서브모듈 안 `docs/` 에는 **그 저장소 코드와 같이 바뀌는 설계 · 계약 문서**만 둔다(예: 프로토콜 · API 규격).
기획 · 계획 · 결정 기록 · 목업 · 진단은 루트 `docs/<시작일>-<기능>/` 에 둔다.
