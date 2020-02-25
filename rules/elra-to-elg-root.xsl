<?xml version="1.0" encoding="utf-8"?>
<!--
    Creative Commons Attribution-NonCommercial-NoDerivatives 4.0
    International Public License

    Copyright (c) 2020 Cogniteva

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to copy
    and redistribute the material in any medium or format, subject to the following
    conditions:

    You must give appropriate credit, provide a link to the LICENSE, and indicate
    if changes were made. You may do so in any reasonable manner, but not in any
    way that suggests the licensor endorses you or your use.

    You may not use the material for commercial purposes.

    If you remix, transform, or build upon the material, you may not distribute
    the modified material.

    You may not apply legal terms or technological measures that legally restrict
    others from doing anything the license permits.

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    YOU DO NOT HAVE TO COMPLY WITH THE LICENSE FOR ELEMENTS OF THE MATERIAL IN
    THE PUBLIC DOMAIN OR WHERE YOUR USE IS PERMITTED BY AN APPLICABLE EXCEPTION
    OR LIMITATION.

    NO WARRANTIES ARE GIVEN. THE LICENSE MAY NOT GIVE YOU ALL OF THE PERMISSIONS
    NECESSARY FOR YOUR INTENDED USE. FOR EXAMPLE, OTHER RIGHTS SUCH AS PUBLICITY,
    PRIVACY, OR MORAL RIGHTS MAY LIMIT HOW YOU USE THE MATERIAL.

    To view a full copy of the license, see the LICENSE file or visit
    http://creativecommons.org/licenses/by-nc-nd/4.0/.
-->
<!-- *********************************************************************** -->
<!-- File:        metashare31-to-elg.xsl                                     -->
<!-- Description: This stylesheet works with the META-SHARE 3.1 schema,      -->
<!--              performing the analysis and transform to ELG-SHARE 1.0.2   -->
<!--                                                                         -->
<!-- Changes:                                                                -->
<!--   2020-02-XX - First release.                                           -->
<!-- *********************************************************************** -->
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

    <!-- rename root to MetadataRecord and add extra namespaces -->
    <xsl:template match="/*">
        <xsl:element name="MetadataRecord" namespace="{namespace-uri()}">
            <xsl:namespace name="ms" select="'http://w3id.org/meta-share/meta-share/'"/>
            <xsl:namespace name="datacite" select="'http://purl.org/spar/datacite/'"/>
            <xsl:namespace name="omtd" select="'http://w3id.org/meta-share/omtd-share/'"/>
            <xsl:namespace name="dcat" select="'http://www.w3.org/ns/dcat#'"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

   <!-- replace schemaLocation -->
   <xsl:template match="@xsi:schemaLocation">
        <xsl:attribute name="xsi:schemaLocation">
            <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',
            ' ', 'http://gitlab.com/european-language-grid/platform/ELG-SHARE-schema/Schema/ELG-SHARE.xsd')" />
        </xsl:attribute>
   </xsl:template>

    <!-- lang to xml:lang -->
    <xsl:template match="@lang">
        <xsl:attribute name="xml:lang">
            <xsl:value-of select="."/>
        </xsl:attribute> 
    </xsl:template> 
</xsl:stylesheet>
