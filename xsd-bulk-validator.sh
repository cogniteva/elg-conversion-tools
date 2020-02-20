#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2206,SC2164
# =============================================================================
# Validate XML files in a directory using xmllint
# Copyright (c) 2020 Cogniteva
# =============================================================================
# Script name
SCRIPT_NAME=${0##*/}
# =============================================================================
# Working directory snippet from @source http://stackoverflow.com/a/17744637/2042871
SCRIPT_FILE=$(cd -P -- "$(dirname -- "$0")" && pwd -P) &&\
SCRIPT_FILE="$SCRIPT_FILE/$SCRIPT_NAME"

# Resolve symlinks snippet from @source http://stackoverflow.com/a/697552/2042871
while [ -h "$SCRIPT_FILE" ]; do
    SCRIPT_DIR=$(dirname -- "$SCRIPT_FILE")
    SCRIPT_SYM=$(readlink   "$SCRIPT_FILE")
    SCRIPT_FILE="$(cd "$SCRIPT_DIR"  &&\
                                  cd "$(dirname  -- "$SCRIPT_SYM")" &&\
                                 pwd)/$(basename -- "$SCRIPT_SYM")"
done  # [ -h "$SCRIPT_FILE" ]
# =============================================================================
# shellcheck disable=SC2034
{
# Default constants
CONSOLE_COLOR_LIGHTGREEN="\033[01;32m"
CONSOLE_COLOR_RED="\033[22;31m"
# VT100 common
CONSOLE_CLEAR_CURRENT_LN=" \r\033[2K"
CONSOLE_RESET="\033[0m"
}
# =============================================================================
LOG_FORMAT_COLOR="%b(%.2s)%b %b[%-4s]%b  %-20s\n"
# =============================================================================
clean_exit() {
  local exit_code=${1:-1}
  exit "$exit_code"
}
# =============================================================================
# print usage options
usage() {
  echo "Usage:"
  echo "  $SCRIPT_NAME XSD_ROOT_FILE XML_FILES|XML_FILE"
} # usage()
# =============================================================================
# color printf
log() {
  # shellcheck disable=SC2059
  printf "$LOG_FORMAT_COLOR" "$1" "$2" "$CONSOLE_RESET" "$1" "$3" "$CONSOLE_RESET" "$4"
}
# =============================================================================
log_error() { log "$CONSOLE_COLOR_RED"         "EE" "$1" "$2" ; }
log_info()  { log "$CONSOLE_COLOR_LIGHTGREEN"  "II" "$1" "$2" ; }
# =============================================================================
# test if xmlint is avalaible
command -v "xmllint" > /dev/null || \
{
  echo "xmllint is not installed!"
  echo "use: sudo apt-get install libxml2-utils"
  clean_exit
}
# =============================================================================
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  usage
  clean_exit
fi
# =============================================================================
XSD_ROOT_FILE="$1"
# test if XSD_ROOT_FILE exists
if [ ! -e "$XSD_ROOT_FILE" ]; then
  echo "$XSD_ROOT_FILE file not found"
  clean_exit
fi
# =============================================================================
XML_FILES="$2"
#  test if XML_FILES exists
if [ ! -e "$XML_FILES" ]; then
  echo "$XML_FILES not found"
  clean_exit
fi
# =============================================================================
# Test valid file extension
if [ ! -d "$XML_FILES" ] && [ "${XML_FILES: -4}" != ".xml" ]; then
  echo "Only files with .xml extension are supported: $XML_FILES"
  clean_exit
fi
# =============================================================================
XML_FILES_IS_DIRECTORY=0
if [ -d "$XML_FILES" ]; then
  XML_FILES_IS_DIRECTORY=1
fi
# =============================================================================
issues_count=0
documents_count=0
# print starting message
echo "# Command Logging $(date +'%F %T %z')"
if [ $XML_FILES_IS_DIRECTORY -eq 0 ]; then
  echo "# Using ${XSD_ROOT_FILE##*/} to check $XML_FILES"
else
  echo "# Using ${XSD_ROOT_FILE##*/} to check xml files in $XML_FILES"
fi
# find all files with .xml extension
while read -r xmldoc ; do         \
  documents_count=$(( documents_count + 1 ))
  docname=${xmldoc##*/}

  {
    # execute command
    xmllint --schema "$XSD_ROOT_FILE" "$xmldoc"  --noout > "/tmp/$docname.log" 2>&1
    # save return code
    exit_status=$?
  }

  # test return code
  if [ $exit_status -ne 0 ]; then
    log_error "ERROR" "$docname"
    # print the report
    sed "s|$xmldoc|$docname|g" < "/tmp/$docname.log"
    issues_count=$(( issues_count + 1 ))
  else
    log_info "VALID" "$docname"
  fi

  # remove temporal log info
  rm -f "/tmp/${docname:?}.log"
done < <(find -L "$XML_FILES"                    \
              -not -path "*/\.*"                 \
              -not -name ".*"                    \
              -name      "*.xml"                 \
              -type f -print)

# test the number of issues
if [ $issues_count -ne 0 ]; then
  echo  "# $issues_count/$documents_count files have issues"
  echo  "# Finished with errors"
  clean_exit 1
else
  echo  "# No errors found"
  echo  "# Successfully finished"
  clean_exit 0
fi
