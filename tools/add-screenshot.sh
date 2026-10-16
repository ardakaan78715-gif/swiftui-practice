#!/bin/bash
# Usage: tools/add-screenshot.sh <app-folder> <screenshot.png>
set -euo pipefail

fail() {
    printf 'add-screenshot: %s\n' "$1" >&2
    exit 1
}

if [ $# -ne 2 ]; then
    printf 'usage: tools/add-screenshot.sh <app-folder> <screenshot.png>\n' >&2
    exit 2
fi

folder=${1%/}
folder=${folder#apps/}
source_png=$2
image=docs/screenshot.png
png_signature=89504e470d0a1a0a
folder_pattern='^[0-9]{2}-[a-z][a-z0-9-]*$'

root=$(cd "$(dirname "$0")/.." && pwd)
app="$root/apps/$folder"
index="$root/README.md"

[[ $folder =~ $folder_pattern ]] && [ -f "$app/project.yml" ] || fail "apps/$folder is not an app folder"
[ -f "$source_png" ] || fail "$source_png does not exist"
[ "$(head -c 8 "$source_png" | od -An -tx1 | tr -d ' \n')" = "$png_signature" ] || fail "$source_png is not a PNG file"
grep -q "](apps/$folder)" "$index" || fail "add a row for apps/$folder to the index in README.md first"

display_name=$(sed -n '1s/^# //p' "$app/README.md")
[ -n "$display_name" ] || fail "apps/$folder/README.md should start with '# <Display Name>'"

mkdir -p "$app/docs"
cp "$source_png" "$app/$image"

if ! grep -q "$image" "$app/README.md"; then
    printf '\n## Screenshot\n\n![%s on an iPhone simulator](%s)\n' "$display_name" "$image" >> "$app/README.md"
fi

cell="<img src=\"apps/$folder/$image\" alt=\"$display_name\" width=\"160\">"
updated=$(mktemp "${TMPDIR:-/tmp}/add-screenshot.XXXXXX")
trap 'rm -f "$updated"' EXIT
awk -v link="](apps/$folder)" -v cell="$cell" '
    /^\|/ && index($0, link) {
        row = $0
        sub(/[[:space:]]*\|[[:space:]]*$/, "", row)
        match(row, /\|[^|]*$/)
        $0 = substr(row, 1, RSTART) " " cell " |"
    }
    { print }
' "$index" > "$updated"
cat "$updated" > "$index"

printf 'Added apps/%s/%s. Commit it with the README changes before the pull request merges.\n' "$folder" "$image"
