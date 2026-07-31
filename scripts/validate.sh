#!/usr/bin/env bash
# Static checks for the site. No build step exists — src/ is published verbatim —
# so this is the only thing standing between a typo'd path and a 404 in prod.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/src"
fail=0

note() { printf '  %s\n' "$1"; }
bad()  { printf '  ✗ %s\n' "$1"; fail=1; }

echo "→ required files"
for f in index.html repositories.html assets/css/main.css assets/js/theme.js \
         assets/img/profile.jpg assets/resume/saharsh_barve_resume.pdf; do
  [ -f "$SRC/$f" ] && note "✓ $f" || bad "missing $f"
done

echo "→ local references resolve"
# Pull every src=/href= that is not absolute, protocol-relative, a mailto, an
# anchor or a data: URI, and confirm the file is actually there.
while IFS= read -r ref; do
  target="${ref%%#*}"
  target="${target%%\?*}"
  [ -z "$target" ] && continue
  [ "$target" = "./" ] && continue
  if [ ! -e "$SRC/$target" ]; then
    bad "broken reference: $target"
  fi
done < <(grep -rhoE '(src|href)="[^"]+"' "$SRC" --include='*.html' \
         | sed -E 's/^(src|href)="//; s/"$//' \
         | grep -vE '^(https?:|//|mailto:|#|data:)' \
         | sort -u)

echo "→ pages share one nav"
for page in index.html repositories.html; do
  for link in 'href="./"' 'href="repositories.html"' 'assets/resume/saharsh_barve_resume.pdf'; do
    grep -q "$link" "$SRC/$page" || bad "$page is missing nav entry: $link"
  done
done

echo "→ favicon is identical on every page"
for page in index.html repositories.html; do
  grep -q '<link rel="icon" type="image/png" href="assets/img/favicon.png">' "$SRC/$page" \
    || bad "$page does not declare the shared favicon (tab icon would change on navigation)"
done

echo "→ theme boot script present (prevents a light flash before dark paints)"
for page in index.html repositories.html; do
  grep -q "localStorage.getItem('theme')" "$SRC/$page" \
    || bad "$page is missing the inline theme bootstrap"
done

if [ "$fail" -ne 0 ]; then
  echo "validation FAILED"
  exit 1
fi
echo "validation passed"
