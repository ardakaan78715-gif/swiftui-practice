#!/bin/bash
# Usage: tools/new-app.sh <NN> <kebab-name> "<Display Name>"
set -euo pipefail

fail() {
    printf 'new-app: %s\n' "$1" >&2
    exit 1
}

if [ $# -ne 3 ]; then
    printf 'usage: tools/new-app.sh <NN> <kebab-name> "<Display Name>"\n' >&2
    exit 2
fi

number=$1
slug=$2
display_name=$3

number_pattern='^[0-9]{2}$'
slug_pattern='^[a-z][a-z0-9]*(-[a-z0-9]+)*$'
display_pattern="^[A-Za-z0-9][A-Za-z0-9 '&-]*$"

[[ $number =~ $number_pattern ]] || fail "the number must be two digits, such as 07"
[[ $slug =~ $slug_pattern ]] || fail "the name must be kebab-case and start with a letter, such as sleep-chart"
[[ $display_name =~ $display_pattern ]] || fail "the display name may use letters, digits, spaces, hyphens, apostrophes and &"
command -v xcodegen >/dev/null || fail "xcodegen is not installed (brew install xcodegen)"

root=$(cd "$(dirname "$0")/.." && pwd)
folder="$number-$slug"
name=$(printf '%s' "$slug" | awk -F- '{ for (i = 1; i <= NF; i++) printf "%s%s", toupper(substr($i, 1, 1)), substr($i, 2) }')

[ ! -e "$root/apps/$folder" ] || fail "apps/$folder already exists"
for existing in "$root/apps/$number"-*; do
    if [ -e "$existing" ]; then
        fail "number $number is already taken by apps/${existing##*/}"
    fi
done

work=$(mktemp -d "${TMPDIR:-/tmp}/new-app.XXXXXX")
trap 'rm -rf "$work"' EXIT
app="$work/$folder"
cp -R "$root/templates/app" "$app"

find "$app" -depth -name '*__NAME__*' | while IFS= read -r path; do
    base=${path##*/}
    mv "$path" "${path%/*}/${base//__NAME__/$name}"
done

escaped_display_name=$(printf '%s' "$display_name" | sed 's/&/\\&/g')
find "$app" -type f | while IFS= read -r file; do
    sed -i '' \
        -e "s/__DISPLAY_NAME__/$escaped_display_name/g" \
        -e "s/__NAME__/$name/g" \
        -e "s/__SLUG__/$slug/g" \
        "$file"
done

xcodegen generate --quiet --spec "$app/project.yml"

mkdir -p "$root/apps"
mv "$app" "$root/apps/$folder"
printf 'Created apps/%s. Open apps/%s/%s.xcodeproj in Xcode.\n' "$folder" "$folder" "$name"
