#!/usr/bin/env bash
# Renders the thesis diagrams: diagrams/*.puml -> pics/*.pdf (vector, fonts embedded).
#
#   ./diagrams/render.sh                 # all diagrams
#   ./diagrams/render.sh class-objects   # only the named ones
#
# Needs plantuml, graphviz (dot) and rsvg-convert. If they are missing and Nix is
# available, the script re-runs itself inside a `nix shell` that provides them.
# component.puml and backend.puml are the older PNG diagrams and are left alone.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$here/../pics"

if ! command -v plantuml >/dev/null || ! command -v dot >/dev/null || ! command -v rsvg-convert >/dev/null; then
  if command -v nix >/dev/null && [ -z "${RENDER_IN_NIX:-}" ]; then
    RENDER_IN_NIX=1 exec nix shell nixpkgs#plantuml nixpkgs#graphviz nixpkgs#librsvg \
      -c bash "${BASH_SOURCE[0]}" "$@"
  fi
  echo "plantuml, graphviz and rsvg-convert are required" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

if [ "$#" -gt 0 ]; then
  sources=()
  for name in "$@"; do sources+=("$here/${name%.puml}.puml"); done
else
  sources=()
  for f in "$here"/*.puml; do
    case "$(basename "$f")" in
      _*|component.puml|backend.puml) ;;
      *) sources+=("$f") ;;
    esac
  done
fi

mkdir -p "$out"
plantuml -tsvg -o "$tmp" "${sources[@]}"
for f in "${sources[@]}"; do
  name="$(basename "$f" .puml)"
  rsvg-convert -f pdf -o "$out/$name.pdf" "$tmp/$name.svg"
  echo "rendered pics/$name.pdf"
done
