#!/usr/bin/env bash
# Usage: applyChanges.sh /path/to/patches     (run from the AOSP tree root)
PATCHES="$(realpath "${1:?usage: $0 PATCH_DIR}")"
[ -d .repo ] || { echo "Run from the tree root (no .repo here)" >&2; exit 1; }

repo list | while IFS= read -r line; do
  path="${line%% : *}"
  name="${line#* : }"
  dir="$PATCHES/$name"
  [ -d "$dir" ] || continue
  echo "== $name"
  (
    cd "$path" || exit 1

    # 1. Commits (keeps authorship and messages)
    if compgen -G "$dir/0*.patch" >/dev/null; then
      git am --3way "$dir"/0*.patch </dev/null || { echo "!! git am failed in $path" >&2; exit 1; }
    fi

    # 2. Uncommitted changes to tracked files
    if [ -f "$dir/9999-uncommitted.patch" ]; then
      git apply --3way "$dir/9999-uncommitted.patch" || { echo "!! uncommitted patch failed in $path" >&2; exit 1; }
    fi

    # 3. New untracked files
    if [ -f "$dir/9998-untracked.patch" ]; then
      git apply "$dir/9998-untracked.patch" || { echo "!! untracked patch failed in $path" >&2; exit 1; }
    fi
  )
done
