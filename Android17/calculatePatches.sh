#!/usr/bin/env bash
# Run from the AOSP tree root (where .repo lives).
export PATCH_OUT="${PATCH_OUT:-$PWD/patches}"

if [ ! -d .repo ]; then
  echo "Run this from the tree root (no .repo here)" >&2
  exit 1
fi

rm -rf "$PATCH_OUT"
mkdir -p "$PATCH_OUT"

repo forall -j8 -c '
  d="$PATCH_OUT/$REPO_PROJECT"

  # 1. Local commits on top of the manifest revision
  if [ -n "$(git rev-list -1 "$REPO_LREV"..HEAD 2>/dev/null)" ]; then
    mkdir -p "$d"
    git format-patch -q -o "$d" "$REPO_LREV"..HEAD
  fi

  # 2. Uncommitted changes to tracked files
  if ! git diff --quiet HEAD 2>/dev/null; then
    mkdir -p "$d"
    git diff --binary HEAD > "$d/9999-uncommitted.patch"
  fi

  # 3. New untracked files (not ignored)
  if [ -n "$(git ls-files -o --exclude-standard | head -1)" ]; then
    mkdir -p "$d"
    git ls-files -o --exclude-standard -z \
      | xargs -0 -I{} git diff --no-index --binary /dev/null {} \
      >> "$d/9998-untracked.patch"
  fi
'

if find "$PATCH_OUT" -name '*.patch' | grep -q .; then
  (cd "$PATCH_OUT" && zip -qr ../android-patches.zip .)
  find "$PATCH_OUT" -name '*.patch' | sort
  echo "Wrote $(dirname "$PATCH_OUT")/android-patches.zip"
else
  echo "No changes found."
fi
