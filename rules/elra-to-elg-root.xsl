<!-- rules to transform ELRA XML files into ELG XML files -->
<xsl:stylesheet
    version="2.0"
    xmlns="http://w3id.org/meta-share/meta-share/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:datacite="http://purl.org/spar/datacite/"
    xmlns:omtd="http://w3id.org/meta-share/omtd-share/"
    xmlns:dcat="http://www.w3.org/ns/dcat#"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:elra="http://www.meta-share.org/META-SHARE_XMLSchema"
    xmlns:elg="http://w3id.org/meta-share/meta-share/"
    > 
    <xsl:output encoding='UTF-8' indent='yes' method='xml'/>

    <!-- copy everything into the output -->
    <xsl:template match='@*|node()'>
        <xsl:copy>
            <xsl:apply-templates select='@*, node()'/>
        </xsl:copy>
    </xsl:template>

    <!-- change namespace -->
    <xsl:template match="elra:*">
        <xsl:element name="{local-name()}" xmlns="http://w3id.org/meta-share/meta-share/" >
          <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <!-- rename root to DescribedEntity and add extra namespaces -->
    <xsl:template match="/*">
        <xsl:element name="DescribedEntity" namespace="{namespace-uri()}">
            <xsl:namespace name="ms" select="'http://w3id.org/meta-share/meta-share/'"/>
            <xsl:namespace name="datacite" select="'http://purl.org/spar/datacite/'"/>
            <xsl:namespace name="omtd" select="'http://w3id.org/meta-share/omtd-share/'"/>
            <xsl:namespace name="dcat" select="'http://www.w3.org/ns/dcat#'"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

   <!-- replace schemaLocation -->
   <xsl:template match="@xsi:schemaLocation">
      <xsl:attribute name="xsi:schemaLocation">http://w3id.org/meta-share/meta-share/ http://gitlab.com/european-language-grid/platform/ELG-SHARE-schema/Schema/ELG-SHARE.xsd</xsl:attribute>
   </xsl:template>
</xsl:stylesheet>
