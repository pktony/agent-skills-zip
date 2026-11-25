#!/usr/bin/env bash
# rules/*.md 를 Claude Code 밖의 에이전트 형식으로 내보냄
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RULES="$ROOT/rules"
START='<!-- agent-skills:rules start -->'
END='<!-- agent-skills:rules end -->'

usage() {
  cat <<'EOF'
사용법: scripts/export-rules.sh <대상> [프로젝트 경로]
  codex                ${CODEX_HOME:-~/.codex}/AGENTS.md 에 규칙 블록 기록
  antigravity          ~/.gemini/GEMINI.md 에 규칙 블록 기록
  cursor <프로젝트>    <프로젝트>/.cursor/rules/agent-skills-*.mdc 생성
  print                합친 본문을 표준 출력으로 (Cursor User Rules 붙여넣기용)
EOF
  exit 1
}

# frontmatter 를 뺀 본문
body() { awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {fm=0; next} !fm' "$1"; }

# frontmatter paths 목록. 중괄호는 펼쳐서 한 줄에 패턴 하나
paths_of() {
  local pattern
  awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {exit} fm && /^  - / {sub(/^  - "?/, ""); sub(/"$/, ""); print}' "$1" |
    while IFS= read -r pattern; do
      set -f
      eval "printf '%s\n' $pattern"
      set +f
    done
}

title_of() { body "$1" | awk '/^# / {sub(/^# /, ""); print; exit}'; }

# 한 파일에 합친 본문. 경로 조건은 글로 남김 (단일 파일 도구는 조건부 로드가 없음)
merged() {
  local f scope
  for f in "$RULES"/*.md; do
    scope="$(paths_of "$f" | paste -sd ' ' -)"
    body "$f"
    [ -n "$scope" ] && printf '\n적용 대상: %s\n' "$scope"
    echo
  done
}

# 표식 사이만 바꾸고 그 밖의 내용은 그대로 둠
write_block() {
  local target="$1" kept
  mkdir -p "$(dirname "$target")"
  touch "$target"
  kept="$(awk -v s="$START" -v e="$END" '
    $0 == s {skip=1; next}
    $0 == e {skip=0; next}
    skip {next}
    /^$/ {blank++; next}
    {while (blank > 0) {print ""; blank--} print}' "$target")"
  {
    [ -n "$kept" ] && printf '%s\n\n' "$kept"
    echo "$START"
    merged
    echo "$END"
  } > "$target"
  echo "기록: $target"
}

to_cursor() {
  local dir="$1/.cursor/rules" f name globs
  [ -d "$1" ] || { echo "프로젝트 경로 없음 ($1)" >&2; exit 1; }
  mkdir -p "$dir"
  for f in "$RULES"/*.md; do
    name="$(basename "$f" .md)"
    globs="$(paths_of "$f" | paste -sd ',' -)"
    {
      echo '---'
      echo "description: \"$(title_of "$f")\""
      if [ -n "$globs" ]; then
        echo "globs: $globs"
        echo 'alwaysApply: false'
      else
        echo 'alwaysApply: true'
      fi
      echo '---'
      echo
      body "$f"
    } > "$dir/agent-skills-$name.mdc"
  done
  echo "기록: $dir/agent-skills-*.mdc"
}

case "${1:-}" in
  codex) write_block "${CODEX_HOME:-$HOME/.codex}/AGENTS.md" ;;
  antigravity) write_block "$HOME/.gemini/GEMINI.md" ;;
  cursor) [ -n "${2:-}" ] || usage; to_cursor "$2" ;;
  print) merged ;;
  *) usage ;;
esac
