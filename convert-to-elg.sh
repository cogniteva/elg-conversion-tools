#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2206,SC2164
# =============================================================================
# Transform ELRA XML files into ELG XML files
# Copyright (c) 2020 Cogniteva
# =============================================================================
export CLASSPATH=$CLASSPATH:/usr/share/java/saxonb.jar
# =============================================================================
# This script name
SCRIPT_NAME=$(basename -- "$0")
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
# Set-up working directory
SCRIPT_BASEDIR="$(dirname  -- "$SCRIPT_FILE")"
# =============================================================================
clean_exit() {
  local exit_code=${1:-1}
  exit "$exit_code"
}
# =============================================================================
# print usage options
usage() {
  echo "Usage:"
  echo "  $SCRIPT_NAME XML_FILE [ELG_SHARE_XSD]"
} # usage()
# =============================================================================
# test if xmlint is avalaible
command -v "xmllint" > /dev/null || \
{
  echo "xmllint is not installed!"
  echo "use: sudo apt-get install libxml2-utils"
  clean_exit
}
# =============================================================================
# test if java is installed
command -v "java" > /dev/null || \
{
  echo "JRE is not installed!"
  clean_exit
}
# =============================================================================
# test if Saxon-B is avalaible
{
  java net.sf.saxon.Transform -? > /dev/null 2>&1
  # save return code
  exit_status=$?
}
# test return code
if [ $exit_status -ne 0 ]; then
  echo "Saxon-B XSLT Processor is not installed!"
  echo "use: sudo apt-get install libsaxonb-java"
  echo "and append saxonb.jar to your CLASSPATH:"
  echo "export CLASSPATH=\$CLASSPATH:/path/to/java/saxonb.jar"
  clean_exit
fi
# =============================================================================
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage
  clean_exit
fi
# =============================================================================
ELG_SHARE_XSD=""
if [ $# -eq 2 ]; then
  ELG_SHARE_XSD="$2"
  # test if ELG_SHARE_XSD exists
  if [ ! -e "$ELG_SHARE_XSD" ]; then
    echo "$ELG_SHARE_XSD file not found"
    clean_exit
  fi
fi
# =============================================================================
INPUT_XML="$1"
INPUT_XML_NAME=$(basename -- "$INPUT_XML")
INPUT_XML_EXT="${INPUT_XML_NAME##*.}"
INPUT_XML_NAME="${INPUT_XML_NAME%.*}"
INPUT_XML_TMP="$INPUT_XML_NAME-tmp.xml"
# =============================================================================
cat "$INPUT_XML" |\
    sed 's|"http://www.meta-share.org/META-SHARE_XMLSchema"|"http://w3id.org/meta-share/meta-share/"|g' |\
    xmllint --format - > "$INPUT_XML_TMP"

# =============================================================================
# setup output names
OUTPUT_XML_NAME_ROOT="$INPUT_XML_NAME-elg-root.xml"
OUTPUT_XML_NAME="$INPUT_XML_NAME-elg.xml"

# =============================================================================
# perform xsl transforms
java net.sf.saxon.Transform -o:"$OUTPUT_XML_NAME_ROOT" -s:"$INPUT_XML_TMP"   \
     -xsl:./rules/elra-to-elg-root.xsl
java net.sf.saxon.Transform -o:"$OUTPUT_XML_NAME" -s:"$OUTPUT_XML_NAME_ROOT" \
     -xsl:./rules/elra-to-elg-body.xsl

# =============================================================================
# minimize xml result
minimize_elg_xml=${MINIMIZE_ELG_XML:-1}
if [ "$minimize_elg_xml" == "1" ]; then
  echo "Minimizing $OUTPUT_XML_NAME..."
  xmllint --noblanks "$OUTPUT_XML_NAME" > "elg-xml/$OUTPUT_XML_NAME"
else
  cp "$OUTPUT_XML_NAME" "elg-xml/$OUTPUT_XML_NAME"
fi

# =============================================================================
# validate result
if [ ! -z "$ELG_SHARE_XSD" ]; then
  "$SCRIPT_BASEDIR"/xsd-bulk-validator.sh "$ELG_SHARE_XSD" ${OUTPUT_XML_NAME:?}
fi

# =============================================================================
# remove temporal files
rm -f "${OUTPUT_XML_NAME:?}"
rm -f "${OUTPUT_XML_NAME_ROOT:?}"
rm -f "${INPUT_XML_TMP:?}"
