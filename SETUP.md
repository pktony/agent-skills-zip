# 설치

## 1. 클론

```sh
git clone https://github.com/pktony/agent-skills.git ~/src/agent-skills
```

## 2. 심링크

경로는 에이전트마다 다르다. 쓰는 것만 걸면 된다.

```sh
REPO=~/src/agent-skills

# Claude Code (전역)
mkdir -p ~/.claude/skills
ln -sfn "$REPO"/skills/* ~/.claude/skills/

# Codex CLI (전역)
mkdir -p ~/.agents/skills
ln -sfn "$REPO"/skills/* ~/.agents/skills/
```

특정 프로젝트에서만 쓰려면 전역 대신 프로젝트 안에 건다 —
Claude Code 는 `.claude/skills/`, Codex 는 `.agents/skills/`.

## 에이전트한테 시킬 때

위 명령을 직접 치는 대신 그대로 붙여넣어도 된다:

> `https://github.com/pktony/agent-skills` 를 `~/src/agent-skills` 로 클론하고,
> `skills/` 안의 각 디렉터리를 내 에이전트의 스킬 디렉터리로 심링크해줘.
> Claude Code 는 `~/.claude/skills/`, Codex 는 `~/.agents/skills/` 다.
> 복사하지 말고 심링크로 걸어야 `git pull` 이 바로 반영된다.
> 걸기 전에 해당 디렉터리가 실제로 그 경로가 맞는지 확인해줘.

## 확인

- Claude Code: `/plan-well`, `/visual-doc` 이 잡히는지
- Codex: 스킬 목록에 `plan-well`, `visual-doc` 이 뜨는지

## 업데이트

```sh
git -C ~/src/agent-skills pull
```

심링크라 따로 다시 설치할 게 없다. 단, **스킬을 새로 추가하면 심링크는 다시 걸어야 한다**
(위 `ln` 명령을 그대로 다시 실행).
