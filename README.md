# agent-skills-zip

내 에이전트 스킬과 자주 쓰는 `.md` 를 한 곳에 모은 레포.

설치는 [SETUP.md](SETUP.md).

## 스킬

| 스킬 | 하는 일 |
|---|---|
| [`docs-writing`](skills/docs-writing/SKILL.md) | 문서 위치 · 이름 · 작성 절차를 정한다. `docs/<시작일>-<기능>/` 폴더 하나에 `[<기능>] plan.md` · `flow.html` · `decision.md` 등을 모은다 |
| [`git-commit`](skills/git-commit/SKILL.md) | 커밋 메시지를 명사형 종결(개조식)로 쓰고, 변경이 여러 갈래면 나눠서 커밋한다 |
| [`plan-well`](skills/plan-well/SKILL.md) | 계획 문서를 쓴다. 계획 본문 + 흐름 HTML + 누적 결정 기록. 범위 · 검증 · 용어 필수 |
| [`visual-doc`](skills/visual-doc/SKILL.md) | 문서를 HTML 한 장으로 시각화한다 (20개 형식 카탈로그 기반, 출처: [html-effectiveness](https://thariqs.github.io/html-effectiveness/)) |

## 규칙

`rules/*.md` 는 Claude Code 가 **자동으로 읽는 지침**이다. 스킬과 달리 부르지 않아도 적용된다.

| 규칙 | 언제 읽히나 | 내용 |
|---|---|---|
| [`ssot`](rules/ssot.md) | 항상 | 진실 하나 = 소유자 하나 · 운영 값은 DB 설정 테이블 · 키 조립은 한 모듈 · 두 언어 계약은 JSON 정답표 |
| [`solid`](rules/solid.md) | 항상 | 파일 하나 = 책임 하나 · 200줄 분리 신호 · OCP · DIP |
| [`code-style`](rules/code-style.md) | 항상 | 이름으로 설명 · 주석 · 반복 금지 · 모듈화 · fail-loud · workaround · 폴백 · 에러 메시지 형식 · 페이지네이션은 api 에서 |
| [`secrets`](rules/secrets.md) | 항상 | 비밀값은 환경변수 · 비밀 저장소 · API 키는 헤더 밖에 남기지 않기 · 서명 키 기본값 없음 |
| [`testing`](rules/testing.md) | 항상 | 계약 대조 · 골든 픽스처 · provider 는 테스트 경계 밖 · 배포는 테스트 통과 후 |
| [`branch`](rules/branch.md) | 항상 | `main` = 프로덕션 · `feat/` `fix/` · 새 작업은 `main` 최신화 후 분기 · 상관없는 작업은 브랜치 분리 |
| [`layers`](rules/layers.md) | `*.ts` `*.js` `*.py` 를 열 때 | controller / service / repository · 조회에 `user_id` 필수 · 트랜잭션 |
| [`web-architecture`](rules/web-architecture.md) | `*.tsx` `*.jsx` · `use-*.ts` · `*.store.ts` 를 열 때 | `app/` `views/` `domains/` `shared/` 계층 · TanStack Query / zustand |

- frontmatter `paths` 가 있으면 그 패턴의 파일을 Read · Write · Edit 할 때만 들어온다. 없으면 세션 시작부터 항상 들어온다
- 프로젝트의 `.claude/rules/` · CLAUDE.md 와 부딪히면 어느 쪽을 따를지 정해져 있지 않다. 프로젝트에서 다르게 할 것은 프로젝트 쪽에 적고 겹치는 쪽을 맞춘다
- Codex · Cursor · Antigravity 는 형식이 달라 `scripts/export-rules.sh` 로 바꿔 넣는다 ([SETUP.md](SETUP.md#다른-에이전트에-규칙-넣기))

## 구조

```
skills/<name>/SKILL.md          스킬 본문. frontmatter 에 name · description 필수
skills/<name>/references/*.md   본문에서 필요할 때만 여는 참고 문서
rules/*.md                      Claude Code 가 자동으로 읽는 지침. frontmatter paths 로 범위 지정
scripts/export-rules.sh         rules 를 Codex · Cursor · Antigravity 형식으로 내보냄
docs/                           스킬은 아니지만 자주 쓰는 .md
```
