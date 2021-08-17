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

"$SCRIPT_DIR/brew-upgrader.sh" '/usr/local/Homebrew/Library/Taps/anatawa12/homebrew-cask' \
      Casks/metasequoia.rb metasequoia
"$SCRIPT_DIR/brew-upgrader.sh" '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-versions' \
      Casks/temurin8.rb temurin8
"$SCRIPT_DIR/brew-upgrader.sh" '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-versions' \
      Casks/temurin11.rb temurin11
"$SCRIPT_DIR/brew-upgrader.sh" '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-versions' \
      Casks/mi-beta.rb mi-beta
"$SCRIPT_DIR/brew-upgrader.sh" '/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask' \
      Casks/mi.rb mi

read -r -p "Wait for enter: "
