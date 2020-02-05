#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2206,SC2164
# =============================================================================
# Transform ELRA XML files into ELG XML files
# cogniteva, 2020
# =============================================================================
# sudo apt-get install libsaxonb-java
# =============================================================================
export CLASSPATH=$CLASSPATH:/usr/share/java/saxonb.jar

INPUT_XML="$1"
INPUT_XML_NAME=$(basename -- "$INPUT_XML")
INPUT_XML_EXT="${INPUT_XML_NAME##*.}"
INPUT_XML_NAME="${INPUT_XML_NAME%.*}"
INPUT_XML_TMP="$INPUT_XML_NAME-tmp.xml"

cat "$INPUT_XML" |\
    sed 's|"http://www.meta-share.org/META-SHARE_XMLSchema"|"http://w3id.org/meta-share/meta-share/"|g' |\
    xmllint --format - > "$INPUT_XML_TMP"

OUTPUT_XML_NAME_ROOT="$INPUT_XML_NAME-elg-root.xml"
OUTPUT_XML_NAME="$INPUT_XML_NAME-elg.xml"

java net.sf.saxon.Transform -o:"$OUTPUT_XML_NAME_ROOT" -s:"$INPUT_XML_TMP" -xsl:./rules/elra-to-elg-root.xsl
java net.sf.saxon.Transform -o:"$OUTPUT_XML_NAME" -s:"$OUTPUT_XML_NAME_ROOT" -xsl:./rules/elra-to-elg-body.xsl

xmllint --noblanks "$OUTPUT_XML_NAME" > "elg-xml/$OUTPUT_XML_NAME"

#rm -f "${OUTPUT_XML_NAME:?}"
rm -f "${OUTPUT_XML_NAME_ROOT:?}"
rm -f "${INPUT_XML_TMP:?}"
