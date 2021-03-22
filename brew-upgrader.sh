#!/bin/bash

err() {
  echo "$@" 1>&2
}

error_input() {
  #err "brew-upgrader <path/to/git/repo> <path/to/rb> <name-of-file> <kind-of-detector> <yourmail>"
  err "brew-upgrader <path/to/git/repo> <path/to/rb> <name-of-file>"
  exit 255
}

script_dir() {
  local SOURCE="$0"
  while [ -h "$SOURCE" ]; do
    local TARGET;
    TARGET="$(readlink "$SOURCE")"
    if [[ $TARGET == /* ]]; then
      SOURCE="$TARGET"
    else
      DIR="$( dirname "$SOURCE" )"
      SOURCE="$DIR/$TARGET"
    fi
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  echo "$DIR"
}

REPO="$1"
FILE_PATH="$2"
NAME="$3"
#DETECT_TYPE="$4"
#yourmail="$5"
SCRIPT_DIR="$(script_dir)"

if [ -z "$REPO" ]; then error_input; fi
if [ -z "$FILE_PATH" ]; then error_input; fi
if [ -z "$NAME" ]; then error_input; fi
#if [ -z "$DETECT_TYPE" ]; then error_input; fi
#if [ -z "$yourmail" ]; then error_input; fi

cd "$REPO" || exit 255

if ! git config --local core.bare >/dev/null 2>&1; then err "invalid git repository"; fi

# shellcheck source=./version-detectors/metasequoia.sh
. "$SCRIPT_DIR/version-detectors/$NAME.sh"

FILE_FULL="$REPO/$FILE_PATH"

current_version() {
    grep '  version' \
      < "$FILE_FULL" \
      | sed "s/.*version *['\"]\(.*\)['\"].*/\1/"
}

replace_version() {
    sed "s/.*version *['\"]\(.*\)['\"].*/  version \"$1\"/" \
      < "$FILE_FULL" \
      > "$temp"
    cat "$temp" > "$FILE_FULL"
}

replace_sha256() {
    sed "s/.*sha256 *['\"]\(.*\)['\"].*/  sha256 \"$1\"/" \
      < "$FILE_FULL" \
      > "$temp"
    cat "$temp" > "$FILE_FULL"
}
echo "checking $NAME"

NEWER_VERSION="$(get_version)"

if [ -z "$NEWER_VERSION" ]; then
    err "invalid get_version"
    exit 255
elif [ "$NEWER_VERSION" == "$(current_version)" ]; then
    err "no update needed: $NEWER_VERSION"
    exit 0
fi

temp="$(mktemp)"
SHA256="$(fetch_file "$NEWER_VERSION" | sha256sum | cut -c 1-64)"
replace_version "$NEWER_VERSION"
replace_sha256 "$SHA256"
rm "$temp"

git switch -c "upgrade-$NAME"
git add "$FILE_PATH"
git commit -m "upgrade $NAME to $NEWER_VERSION"
git push -f -u myown "upgrade-$NAME"
gh pr create --web
git checkout "master"
git branch -D "upgrade-$NAME"

osascript -e "display notification \"upgrade $NAME to $NEWER_VERSION\""
