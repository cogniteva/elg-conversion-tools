#!/bin/bash
# added by martinec
# This is based on https://github.com/caarlos0/shell-ci-build
set -eo pipefail

main() {
  if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    brew install bash
  else
    local filename="shellcheck_0.4.4-4_amd64.deb"
    wget "http://ftp.debian.org/debian/pool/main/s/shellcheck/$filename"
    sudo dpkg -i "$filename"
  fi
}

main
