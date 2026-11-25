# 설치

## 1. 클론

```sh
git clone https://github.com/pktony/agent-skills-zip.git ~/src/agent-skills
```

## 2. 심링크

경로는 에이전트마다 다르다. 쓰는 것만 걸면 된다.

```sh
REPO=~/src/agent-skills

# Claude Code (전역): 스킬 + 규칙
mkdir -p ~/.claude/skills ~/.claude/rules
ln -sfn "$REPO"/skills/* ~/.claude/skills/
ln -sfn "$REPO"/rules/*.md ~/.claude/rules/

# Codex CLI (전역)
mkdir -p ~/.agents/skills
ln -sfn "$REPO"/skills/* ~/.agents/skills/
```

특정 프로젝트에서만 쓰려면 전역 대신 프로젝트 안에 건다.
Claude Code 는 `.claude/skills/` · `.claude/rules/`, Codex 는 `.agents/skills/`.

Windows 에서 심링크가 막히면(개발자 모드 꺼짐) 복사로 대신하고, 업데이트 때 다시 복사한다.

## 에이전트한테 시킬 때

위 명령을 직접 치는 대신 그대로 붙여넣어도 된다:

> `https://github.com/pktony/agent-skills-zip` 를 `~/src/agent-skills` 로 클론하고,
> `skills/` 안의 각 디렉터리를 내 에이전트의 스킬 디렉터리로 심링크해줘.
> Claude Code 는 `~/.claude/skills/`, Codex 는 `~/.agents/skills/` 다.
> Claude Code 면 `rules/*.md` 도 `~/.claude/rules/` 에 심링크해줘.
> 복사하지 말고 심링크로 걸어야 `git pull` 이 바로 반영된다.
> 걸기 전에 해당 디렉터리가 실제로 그 경로가 맞는지 확인해줘.

## 확인

- Claude Code: `/plan-well`, `/visual-doc` 이 잡히는지
- Claude Code 규칙: **새 세션**에서 "시작부터 컨텍스트에 들어와 있는 문서 경로를 나열해줘" 라고 물어 `~/.claude/rules/` 의 항상 읽히는 6개가 보이는지
- Codex: 스킬 목록에 `plan-well`, `visual-doc` 이 뜨는지

## 다른 에이전트에 규칙 넣기

스킬(`SKILL.md`)은 같은 형식을 읽어 위처럼 심링크하면 된다. 규칙은 도구마다 형식이 달라서
`scripts/export-rules.sh` 로 바꿔 넣는다 (Windows 는 Git Bash 에서 실행).

| | Codex | Cursor | Antigravity |
|---|---|---|---|
| 스킬 | `~/.agents/skills/` | `~/.claude/skills/` 를 그대로 읽음 | `~/.gemini/antigravity/skills/` |
| 전역 규칙 | `~/.codex/AGENTS.md` **한 파일** | 설정 화면 User Rules (파일 아님) | `~/.gemini/GEMINI.md` **한 파일** |
| 프로젝트 규칙 | 폴더마다 `AGENTS.md` | `.cursor/rules/*.mdc` | `.agent/rules/` |
| 경로 조건 | 없음 (폴더 위치로만) | `globs` | 설정 화면에서 지정 |

```sh
"$REPO"/scripts/export-rules.sh codex                 # ~/.codex/AGENTS.md
"$REPO"/scripts/export-rules.sh antigravity           # ~/.gemini/GEMINI.md
"$REPO"/scripts/export-rules.sh cursor <프로젝트 경로>  # <프로젝트>/.cursor/rules/agent-skills-*.mdc
"$REPO"/scripts/export-rules.sh print                 # 합친 본문 출력 → Cursor 설정 User Rules 에 붙여넣기

# Antigravity 스킬
mkdir -p ~/.gemini/antigravity/skills
ln -sfn "$REPO"/skills/* ~/.gemini/antigravity/skills/
```

- `codex` · `antigravity` 는 파일 안의 `<!-- agent-skills:rules start -->` ~ `end` 표식 사이만 바꾼다. 그 밖에 적어 둔 개인 지침은 그대로 남고, 여러 번 돌려도 블록이 하나다
- 한 파일에 합치는 도구(Codex · Antigravity)는 경로 조건이 없어서 `layers` · `web-architecture` 도 항상 읽힌다. 블록 안에 `적용 대상:` 줄로 원래 범위를 적어 둔다
- `cursor` 는 `paths` 를 `globs` 로, `paths` 가 없으면 `alwaysApply: true` 로 바꾼다. 프로젝트의 기존 규칙과 섞이지 않게 파일 이름 앞에 `agent-skills-` 를 붙인다
- 내보낸 결과는 사본이라 심링크와 달리 `git pull` 로 바뀌지 않는다. 규칙이 바뀌면 같은 명령을 다시 돌린다
- `/plan-well` 처럼 Claude Code 전용 도구 · 훅에 기대는 부분은 다른 도구에서 그대로 동작하지 않을 수 있다
- 경로는 2026-11 기준 각 도구 문서를 따랐다. 도구 버전에 따라 바뀌니 안 읽히면 그 도구 문서부터 확인한다

## 업데이트

```sh
git -C ~/src/agent-skills pull
```

심링크라 따로 다시 설치할 게 없다. 단, **스킬 · 규칙을 새로 추가하면 심링크는 다시 걸어야 한다**
(위 `ln` 명령을 그대로 다시 실행). 다른 에이전트에 내보낸 규칙은 `export-rules.sh` 를 다시 돌린다.
