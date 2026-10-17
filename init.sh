#!/usr/bin/env bash
# One-time setup after cloning the template. Usage: ./init.sh [--force]
set -euo pipefail
cd "$(dirname "$0")"

if [[ "${1:-}" != "--force" ]] && ! grep -q 'title="Game"' Project.xml; then
  echo "Project.xml already customised; use --force to run anyway." >&2
  exit 1
fi

# repo name / github user from origin remote, else fall back
remote=$(git remote get-url origin 2>/dev/null || true)
repo=$(basename "${remote:-$PWD}" .git)
user=$(sed -E 's#.*[:/]([^/]+)/[^/]+$#\1#' <<<"$remote")
[[ -z "$remote" || "$user" == "$remote" ]] && user=charcoalstyles
user=$(tr '[:upper:]' '[:lower:]' <<<"$user")
url="https://$user.github.io/$repo/"

# CamelCase / snake / kebab -> "Title Words"
default=$(sed -E 's/([a-z0-9])([A-Z])/\1 \2/g; s/[-_]+/ /g' <<<"$repo")
read -rp "Game title [$default]: " title
title=${title:-$default}
read -rp "Description (optional): " desc
desc=${desc:-Game Description}

slug=$(tr '[:upper:]' '[:lower:]' <<<"$title" | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
[[ -n "$slug" ]] || slug=game

# escape for sed replacement (delimiter |) and for XML attribute
esc() { sed -e 's/[\\&|]/\\&/g' <<<"$1"; }
xml() { sed -e 's/&/\&amp;/g; s/"/\&quot;/g; s/</\&lt;/g' <<<"$1"; }
T=$(esc "$title"); TH=$(esc "${title//\"/\\\"}"); D=$(esc "$desc"); U=$(esc "$url")
TX=$(esc "$(xml "$title")")

sed -i "s|title=\"Game\" file=\"game\"|title=\"$TX\" file=\"$slug\"|" Project.xml
sed -i "s|gameName:String = \"Game\"|gameName:String = \"$TH\"|" source/states/MainMenuState.hx
sed -i "s|^# Game Title|# $T|; s|^Game Description|$D|; s|https://charcoalstyles.github.io/{repository-name}/|$U|" README.md

echo "Done: '$title' ($slug), play URL $url"
echo "Next: push to GitHub, then Settings > Pages > deploy from branch 'gh-pages' (created by the first Action run)."

if [[ "${1:-}" != "--force" ]]; then rm -- "$0" && echo "(removed init.sh)"; fi
