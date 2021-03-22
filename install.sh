#!/bin/bash

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

SCRIPT_DIR="$(script_dir)"

brew install jq
brew install gh

ln -s "$SCRIPT_DIR/brew-upgrader.sh" "/usr/local/bin/brew-upgrader"
ln -s "$SCRIPT_DIR/main.sh" "/usr/local/bin/brew-upgrader-main"
