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
    xmlns:ms="http://w3id.org/meta-share/meta-share/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:datacite="http://purl.org/spar/datacite/"
    xmlns:omtd="http://w3id.org/meta-share/omtd-share/"
    xmlns:dcat="http://www.w3.org/ns/dcat#"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    > 
    <xsl:output encoding='UTF-8' indent='yes' method='xml'/>

    <!-- format:cost  -->
    <xsl:decimal-format name="cost"   decimal-separator="," grouping-separator="."/>

    <!-- format:number  -->
    <xsl:decimal-format name="number" decimal-separator="," grouping-separator="."/>

    <!-- var:identificationInfo  -->
    <xsl:variable name="identificationInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:identificationInfo/*"/>
    </xsl:variable>

    <!-- var:distributionInfo  -->
    <xsl:variable name="distributionInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:distributionInfo"/>
    </xsl:variable>

    <!-- var:contactPerson  -->
    <xsl:variable name="contactPerson">
       <xsl:copy-of select="//ms:MetadataRecord/ms:contactPerson/*"/>
    </xsl:variable>

    <!-- var:metadataInfo  -->
    <xsl:variable name="metadataInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:metadataInfo/*"/>
    </xsl:variable>

    <!-- var:metadataCreator  -->
    <xsl:variable name="metadataCreator">
       <xsl:copy-of select="$metadataInfo/ms:metadataCreator/*"/>
    </xsl:variable>

    <!-- var:versionInfo  -->
    <xsl:variable name="versionInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:versionInfo/*"/>
    </xsl:variable>

    <!-- var:validationInfo  -->
    <xsl:variable name="validationInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:validationInfo/*"/>
    </xsl:variable>

    <!-- var:usageInfo  -->
    <xsl:variable name="usageInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:usageInfo/*"/>
    </xsl:variable>

    <!-- var:resourceDocumentationInfo  -->
    <xsl:variable name="resourceDocumentationInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceDocumentationInfo/*"/>
    </xsl:variable>

    <!-- var:resourceCreationInfo  -->
    <xsl:variable name="resourceCreationInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceCreationInfo/*"/>
    </xsl:variable>

    <!-- var:relationInfo  -->
    <xsl:variable name="relationInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:relationInfo/*"/>
    </xsl:variable>

    <!-- var:corpusInfo  -->
    <xsl:variable name="corpusInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceComponentType/ms:corpusInfo/*"/>
    </xsl:variable>

    <!-- var:lexicalConceptualResourceInfo  -->
    <xsl:variable name="lexicalConceptualResourceInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceComponentType/ms:lexicalConceptualResourceInfo/*"/>
    </xsl:variable>

    <!-- var:languageDescriptionInfo  -->
    <xsl:variable name="languageDescriptionInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceComponentType/ms:languageDescriptionInfo/*"/>
    </xsl:variable>

    <!-- var:resourceType  -->
    <xsl:variable name="resourceType">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceComponentType//ms:resourceType"/>
    </xsl:variable>

    <!-- var:mediaType  -->
    <xsl:variable name="mediaType">
       <xsl:copy-of select="$lexicalConceptualResourceInfo/ms:lexicalConceptualResourceMediaType"/>
    </xsl:variable>
    
    <!-- var:mediaTypeName  -->
    <xsl:variable name="mediaTypeName">
       <xsl:copy-of select="name($lexicalConceptualResourceInfo/ms:lexicalConceptualResourceMediaType/*[1])"/>
    </xsl:variable>

    <!-- var:lexicalConceptualResourceTextInfo  -->
    <xsl:variable name="lexicalConceptualResourceTextInfo">
       <xsl:copy-of select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo"/>
    </xsl:variable>

    <!-- function:upper-first  -->
    <!-- based on @see https://stackoverflow.com/a/29550250/2042871 -->
    <xsl:function name="ms:upper-first">
        <xsl:param name="text" />
        <xsl:for-each select="tokenize($text,' ')">
            <xsl:value-of select="upper-case(substring(.,1,1))" />
            <xsl:value-of select="substring(.,2)" />
            <xsl:if test="position() ne last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <!-- function:grep-number  -->
    <xsl:function name="ms:grep-number">
        <xsl:param name="text" />
        <xsl:analyze-string select="$text" regex="^[^0-9]*([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?).*$">
            <xsl:matching-substring>
                <xsl:value-of select="number(regex-group(1))"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="format-number(number($text), '#', 'number')"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>

    <!-- function:map-with  -->
    <!-- if source on mappings then function returns target else returns source -->
    <!-- <entry><source>foo</source><target>bar</target></entry>  -->
    <xsl:function name="ms:map-with">
        <xsl:param name="source" />
        <xsl:param name="mappings" />
        <xsl:if test="normalize-space($source) != ''">
            <!-- process mappings -->
            <!-- create a node-set from the mappings param -->
            <xsl:variable name="mappingsSet"><xsl:copy-of select="$mappings" /></xsl:variable>
            <!-- lock for an entry where source = $source -->
            <!-- and set mappedTarget as empty or target value  -->
            <xsl:variable name="mappedTarget">
                <xsl:value-of select="$mappingsSet/ms:entry/ms:source[text() = $source]/../ms:target" />
            </xsl:variable>
            <!-- if mappedTarget is empty returns $source  -->
            <xsl:choose>
                <xsl:when test="normalize-space($mappedTarget) != ''">
                    <xsl:value-of select="normalize-space($mappedTarget)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($source)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:function>

    <!-- function:get-meta-share-mimetype -->
    <xsl:function name="ms:get-meta-share-mimetype">
        <xsl:param name="text" />
        <!-- mimeType -->
        <!-- QUESTION() what about mimeType = 'other'? -->
        <!-- DO NOT CHANGE ORDER DECLARATION -->
        <xsl:choose>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'xcesilsp')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/XcesIlspVariant'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'xces')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Xces'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'tab-separated')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Tsv'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'tsv')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Tsv'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'csv')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Csv'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'sgml')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Sgml'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'xml')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Xml'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'msaccess')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/MsAccessDatabase'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'ms-excel')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/MsExcel'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'msword')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/MsWord'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'mpeg3')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/mpg'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'video')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/mpg'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'text')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Text'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'plain')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Text'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($text)), 'pdf')">
                <xsl:value-of select="'http://w3id.org/meta-share/omtd-share/Pdf'"/>
            </xsl:when>
            <!-- NOTE() Add here as much mappings as needed -->
            <xsl:otherwise>
                <!-- otherwise return an empty string -->
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- template:StringValuesConcat  -->
    <!-- based on @see https://stackoverflow.com/a/4038983 -->
    <xsl:template name='StringValuesConcat'>
        <xsl:param name='el' />
        <xsl:param name='separator' />
        <xsl:for-each select='$el'>
            <xsl:value-of select='.'/>
            <xsl:if test='position() != last()'>
               <xsl:value-of select='$separator'/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- template:ElraLicenseIdentifierGenerator  -->
    <xsl:template name='ElraLicenseIdentifierGenerator'>
        <xsl:param name='el' />
        <xsl:param name='version' />
        <xsl:param name='separator' />
        <!-- licence: { ELRA_VAR, ELRA_END_USER, ELRA_EVALUATION } -->
        <xsl:value-of select="translate(upper-case(./ms:licence),'_','-')" />
        <xsl:value-of select='$separator'/>
        <!-- userNature: { ACADEMIC, COMMERCIAL }  -->
        <xsl:value-of select="upper-case((../ms:userNature)[1])" />
        <xsl:value-of select='$separator'/>
        <!-- member: { MEMBER, NOMEMBER } -->
        <xsl:value-of select="if (../ms:membershipInfo/ms:member = 'true') then 'MEMBER' else 'NOMEMBER'"/>
        <xsl:value-of select='$separator'/>
        <!-- restrictionsOfUse : { COMMERCIALUSE, NONCOMMERCIALUSE, EVALUATIONUSE } -->
        <xsl:value-of select="upper-case((./ms:restrictionsOfUse)[1])" />
        <!-- version -->
        <xsl:value-of select='$separator'/>
        <xsl:value-of select='$version'/>
    </xsl:template>

    <!-- template:GenericDocument  -->
    <xsl:template name="GenericDocument">
        <xsl:param name="el" />
        <!-- tile -->
        <xsl:for-each select="$el/ms:title">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <!-- DocumentIdentifier -->
        <xsl:for-each select="$el/*">
            <xsl:choose>
                <xsl:when test="lower-case(local-name(.)) = 'doi'">
                    <DocumentIdentifier ms:DocumentIdentifierScheme="http://purl.org/spar/datacite/doi">
                        <xsl:value-of select="normalize-space(.)" />
                    </DocumentIdentifier>
                </xsl:when>
                <xsl:when test="lower-case(local-name(.)) = 'url'">
                    <DocumentIdentifier ms:DocumentIdentifierScheme="http://purl.org/spar/datacite/url">
                        <xsl:value-of select="normalize-space(.)" />
                    </DocumentIdentifier>
                </xsl:when>
                <xsl:when test="lower-case(local-name(.)) = 'isbn'">
                    <DocumentIdentifier ms:DocumentIdentifierScheme="http://purl.org/spar/datacite/isbn">
                        <xsl:value-of select="normalize-space(.)" />
                    </DocumentIdentifier>
                </xsl:when>
                <xsl:when test="lower-case(local-name(.)) = 'issn'">
                    <DocumentIdentifier ms:DocumentIdentifierScheme="http://purl.org/spar/datacite/issn">
                        <xsl:value-of select="normalize-space(.)" />
                    </DocumentIdentifier>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- template:GenericPerson  -->
    <xsl:template name="GenericPerson">
        <xsl:param name="el" />
        <!-- actorType -->
        <actorType>Person</actorType>
        <!-- surname -->
        <xsl:choose>
            <xsl:when test="normalize-space(($el/ms:surname)[1]) = ''">
                <surname xml:lang="und"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$el/ms:surname">
                    <xsl:copy-of select="." />
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <!-- givenName -->
        <xsl:choose>
            <xsl:when test="normalize-space(($el/ms:givenName)[1]) = ''">
                <givenName xml:lang="und"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$el/ms:givenName">
                    <xsl:copy-of select="." />
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <!-- email -->
        <xsl:copy-of select="$el/ms:communicationInfo/ms:email" />
    </xsl:template>

    <!-- template:OrganizationIdentifier -->
    <xsl:template name="OrganizationIdentifier">
        <xsl:param name="el" />
        <xsl:param name="asDefault" />
        <xsl:choose>
            <!-- ATTENTION DO NOT PUT A BUNCH OF ORGANIZATIONS HERE -->
            <!-- THIS IS JUST TO TRANSFORM CERTAIN WELL-KNOWN VALUES -->
            <!-- a more efficient approach would be to use a WRL model -->
            <xsl:when test="(contains(lower-case(normalize-space($el)), 'ilsp') or
                            (contains(lower-case(normalize-space($el)), 'institute for language and speech processing')))">
                <OrganizationIdentifier  ms:OrganizationIdentifierScheme="http://w3id.org/meta-share/meta-share/elg">
                    <xsl:value-of select="'ILSP'" />
                </OrganizationIdentifier>
            </xsl:when>
            <xsl:when test="(contains(lower-case(normalize-space($el)), 'elra') or
                            (contains(lower-case(normalize-space($el)), 'european language resources association')))">
                <OrganizationIdentifier  ms:OrganizationIdentifierScheme="http://w3id.org/meta-share/meta-share/elg">
                    <xsl:value-of select="'ELRA'" />
                </OrganizationIdentifier>
            </xsl:when>
            <xsl:when test="$asDefault = 'true'">
                <OrganizationIdentifier  ms:OrganizationIdentifierScheme="http://w3id.org/meta-share/meta-share/other">
                    <xsl:value-of select="normalize-space($el)" />
                </OrganizationIdentifier>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- template:GenericOrganization -->
    <xsl:template name="GenericOrganization">
        <xsl:param name="el" />
        <actorType>Organization</actorType>
        <!-- organizationName -->
        <xsl:for-each select="$el/ms:organizationName">
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="." />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'organizationName'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- organizationName -->
        <xsl:for-each select=" $el/ms:organizationShortName">
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="." />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'organizationName'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- OrganizationIdentifier -->
        <xsl:choose>
            <!-- DO NOT CHANGE DECLARATION ORDER -->
            <xsl:when test="($el/ms:organizationShortName)">
                <xsl:for-each select="$el/ms:organizationShortName">
                    <xsl:call-template name="OrganizationIdentifier">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="asDefault" select="'true'" />
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="($el/ms:organizationName)">
                <xsl:for-each select="$el/ms:organizationName">
                    <xsl:call-template name="OrganizationIdentifier">
                        <xsl:with-param name="el" select="." />
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
        <!-- website -->
        <xsl:for-each select="$el/ms:communicationInfo/ms:url">
            <website><xsl:value-of select="." /></website>
        </xsl:for-each>
    </xsl:template>

    <!-- template:Actor  -->
    <xsl:template name="Actor">
        <xsl:param name="el" />
        <xsl:param name="actorElement" />
        <!-- Person -->
        <xsl:for-each select="$el/ms:personInfo">
            <xsl:element name="{$actorElement}">
                <Person>
                    <xsl:call-template name="GenericPerson">
                        <xsl:with-param name="el" select="." />
                    </xsl:call-template>
                </Person>
            </xsl:element>
        </xsl:for-each>
        <!-- Organization -->
        <xsl:for-each select="$el/ms:organizationInfo">
            <xsl:element name="{$actorElement}">
                <Organization>
                    <xsl:call-template name="GenericOrganization">
                        <xsl:with-param name="el" select="." />
                    </xsl:call-template>
                </Organization>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <!-- template:ElementCopy -->
    <xsl:template name="ElementCopy">
        <xsl:param name="el" />
        <xsl:param name="elementName" />
        <xsl:if test="normalize-space($el) != ''">
            <xsl:element name="{$elementName}">
                <xsl:copy-of  select="$el/@*"/>
                <xsl:value-of select="normalize-space($el)"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- template:ElementMetaShare -->
    <xsl:template name="ElementMetaShare">
        <xsl:param name="el" />
        <xsl:param name="elementName" />
        <xsl:param name="mappings" />
        <xsl:if test="normalize-space($el) != ''">
            <xsl:element name="{$elementName}">
                <xsl:copy-of  select="$el/@*"/>
                <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',ms:map-with($el,$mappings))" />
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- template:ElementOmtdShare -->
    <xsl:template name="ElementOmtdShare">
        <xsl:param name="el" />
        <xsl:param name="elementName" />
        <xsl:if test="normalize-space($el) != ''">
            <xsl:element name="{$elementName}">
                <xsl:copy-of  select="$el/@*"/>
                <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/',normalize-space($el))" />
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- template:ElementMetaShareDefault -->
    <xsl:template name="ElementMetaShareDefault">
        <xsl:param name="el" />
        <xsl:param name="default" />
        <xsl:param name="elementName" />
        <xsl:choose>
            <xsl:when test="normalize-space($el) = ''">
                <xsl:element name="{$elementName}">
                    <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',$default)" />
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="$el" />
                    <xsl:with-param name="elementName" select="$elementName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:ElementCopyWithDefaultLang  -->
    <xsl:template name="ElementCopyWithDefaultLang">
        <xsl:param name="el" />
        <xsl:param name="elementLang" />
        <xsl:param name="elementName" />
        <xsl:if test="normalize-space($el) != ''">
            <xsl:choose>
                <xsl:when test="$el/@lang">
                    <xsl:element name="{$elementName}">
                        <xsl:copy-of  select="$el/@*"/>
                        <xsl:value-of select="normalize-space($el)"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{$elementName}">
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="$elementLang"/>
                        </xsl:attribute>
                        <xsl:copy-of  select="$el/@*"/>
                        <xsl:value-of select="normalize-space($el)"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- template:GenericProject -->
    <xsl:template name="GenericProject">
        <xsl:param name="el" />
        <xsl:copy-of select="$el/ms:projectName" />
        <xsl:for-each select="$el/ms:url">
            <website><xsl:value-of select="." /></website>
        </xsl:for-each>
    </xsl:template>

    <!-- template:LinkToOtherMedia -->
    <xsl:template name="LinkToOtherMedia">
        <xsl:param name="el" />
        <xsl:for-each select="$el">
            <linkToOtherMedia>
                <!-- otherMedia -->
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="./ms:otherMedia" />
                    <xsl:with-param name="elementName" select="'otherMedia'" />
                </xsl:call-template>
                <!-- mediaTypeDetails -->
                <xsl:call-template name="ElementCopyWithDefaultLang">
                    <xsl:with-param name="el" select="./ms:mediaTypeDetails" />
                    <xsl:with-param name="elementLang" select="'en'" />
                    <xsl:with-param name="elementName" select="'mediaTypeDetails'" />
                </xsl:call-template>
                <!-- synchronizedWithText -->
                <xsl:copy-of select="./ms:synchronizedWithText" />
                <!-- synchronizedWithAudio -->
                <xsl:copy-of select="./ms:synchronizedWithAudio" />
                <!-- synchronizedWithVideo -->
                <xsl:copy-of select="./ms:synchronizedWithVideo" />
                <!-- synchronizedWithImage -->
                <xsl:copy-of select="./ms:synchronizedWithImage" />
                <!-- synchronizedWithTextNumerical -->
                <xsl:copy-of select="./ms:synchronizedWithTextNumerical" />
            </linkToOtherMedia>
        </xsl:for-each>
    </xsl:template>

    <!-- template:CharacterEncoding -->
    <xsl:template name="CharacterEncoding">
        <xsl:param name="el" />
        <!-- characterEncoding -->
        <xsl:for-each select="$el">
            <xsl:choose>
                <xsl:when test="contains(lower-case(normalize-space(./ms:characterEncoding)), 'utf8')">
                    <characterEncoding>http://w3id.org/meta-share/meta-share/UTF-8</characterEncoding>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ElementMetaShare">
                        <xsl:with-param name="el" select="./ms:characterEncoding" />
                        <xsl:with-param name="elementName" select="'characterEncoding'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- template:DistributionTextNumericalFeature -->
    <xsl:template name="DistributionTextNumericalFeature">
        <xsl:param name="el" />
        <!-- size -->
        <xsl:for-each select="$el/ms:sizeInfo">
            <xsl:call-template name="Size">
                <xsl:with-param name="el" select="." />
                <xsl:with-param name="elementName" select="'size'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- dataFormat -->
        <xsl:choose>
            <!-- if there are textNumericalFormatInfo/mimeType information -->
            <xsl:when test="count($el/ms:textNumericalFormatInfo) > 0">
                <xsl:for-each select="$el/ms:textNumericalFormatInfo">
                    <!-- dataFormat -->
                    <xsl:choose>
                        <xsl:when test="ms:get-meta-share-mimetype(./ms:mimeType) != ''">
                            <dataFormat>
                                <xsl:value-of select="ms:get-meta-share-mimetype(./ms:mimeType)"/>
                            </dataFormat>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- this is supposed to thrown an error in order to deal with unknown mappings -->
                            <dataFormat>
                                <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/Unknown/',normalize-space(./ms:mimeType))"/>
                            </dataFormat>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- alternatively use a default value -->
            <xsl:otherwise>
                <dataFormat>http://w3id.org/meta-share/omtd-share/BinaryFormat</dataFormat>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:DistributionTextFeature -->
    <xsl:template name="DistributionTextFeature">
        <xsl:param name="el" />
        <!-- size -->
        <xsl:for-each select="$el/ms:sizeInfo">
            <xsl:call-template name="Size">
                <xsl:with-param name="el" select="." />
                <xsl:with-param name="elementName" select="'size'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- dataFormat -->
        <xsl:choose>
            <!-- if there are textFormatInfo/mimeType information -->
            <xsl:when test="count($el/ms:textFormatInfo) > 0">
                <xsl:for-each select="$el/ms:textFormatInfo">
                    <!-- dataFormat -->
                    <xsl:choose>
                        <xsl:when test="ms:get-meta-share-mimetype(./ms:mimeType) != ''">
                            <dataFormat>
                                <xsl:value-of select="ms:get-meta-share-mimetype(./ms:mimeType)"/>
                            </dataFormat>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- this is supposed to thrown an error in order to deal with unknown mappings -->
                            <dataFormat>
                                <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/Unknown/',normalize-space(./ms:mimeType))"/>
                            </dataFormat>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- alternatively use a default value -->
            <xsl:otherwise>
                <dataFormat>http://w3id.org/meta-share/omtd-share/Text</dataFormat>
            </xsl:otherwise>
        </xsl:choose>
        <!-- characterEncoding -->
        <xsl:call-template name="CharacterEncoding">
            <xsl:with-param name="el" select="$el/ms:characterEncodingInfo" />
        </xsl:call-template>
    </xsl:template>

    <!-- template:DistributionVideoFeature -->
    <xsl:template name="DistributionVideoFeature">
        <xsl:param name="el" />
        <!-- size -->
        <xsl:for-each select="$el/ms:sizeInfo">
            <xsl:call-template name="Size">
                <xsl:with-param name="el" select="." />
                <xsl:with-param name="elementName" select="'size'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- videoFormat -->
        <xsl:choose>
            <!-- if there are videoFormatInfo information -->
            <xsl:when test="count($el/ms:videoFormatInfo) > 0">
                <xsl:for-each select="$el/ms:videoFormatInfo">
                    <videoFormat>
                        <!-- map videoFormatInfo/mimeType to omtd-share vocabulary -->
                        <xsl:choose>
                            <xsl:when test="ms:get-meta-share-mimetype(./ms:mimeType) != ''">
                                <dataFormat>
                                    <xsl:value-of select="ms:get-meta-share-mimetype(./ms:mimeType)"/>
                                </dataFormat>
                            </xsl:when>
                            <!-- NOTE() Add here as much mappings as needed -->
                            <xsl:otherwise>
                                <!-- this is supposed to thrown an error in order to deal with unknown mappings -->
                                <dataFormat>
                                    <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/Unknown/',normalize-space(./ms:mimeType))"/>
                                </dataFormat>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- compressed: QUESTION() Why this is mandatory? -->
                        <compressed>
                            <xsl:value-of select="if (./ms:compressionInfo/ms:compression = 'true') then 'true' else 'false'"/>
                        </compressed>
                    </videoFormat>
                </xsl:for-each>
            </xsl:when>
            <!-- alternatively use a default element -->
            <xsl:otherwise>
                <videoFormat>
                    <dataFormat>http://w3id.org/meta-share/omtd-share/mpg</dataFormat>
                    <compressed>false</compressed>
                </videoFormat>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:DistributionImageFeature -->
    <xsl:template name="DistributionImageFeature">
        <xsl:param name="el" />
        <!-- size -->
        <xsl:for-each select="$el/ms:sizeInfo">
            <xsl:call-template name="Size">
                <xsl:with-param name="el" select="." />
                <xsl:with-param name="elementName" select="'size'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- imageFormat -->
        <xsl:choose>
            <!-- if there are imageFormatInfo information -->
            <xsl:when test="count($el/ms:imageFormatInfo) > 0">
                <xsl:for-each select="$el/ms:imageFormatInfo">
                    <imageFormat>
                        <!-- map imageFormatInfo/mimeType to omtd-share vocabulary -->
                        <xsl:choose>
                            <xsl:when test="ms:get-meta-share-mimetype(./ms:mimeType) != ''">
                                <dataFormat>
                                    <xsl:value-of select="ms:get-meta-share-mimetype(./ms:mimeType)"/>
                                </dataFormat>
                            </xsl:when>
                            <!-- NOTE() Add here as much mappings as needed -->
                            <xsl:otherwise>
                                <!-- this is supposed to thrown an error in order to deal with unknown mappings -->
                                <dataFormat>
                                    <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/Unknown/',normalize-space(./ms:mimeType))"/>
                                </dataFormat>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- compressed: QUESTION() Why this is mandatory? -->
                        <compressed>
                            <xsl:value-of select="if (./ms:compressionInfo/ms:compression = 'true') then 'true' else 'false'"/>
                        </compressed>
                    </imageFormat>
                </xsl:for-each>
            </xsl:when>
            <!-- alternatively use a default element -->
            <xsl:otherwise>
                <imageFormat>
                    <dataFormat>http://w3id.org/meta-share/omtd-share/BinaryFormat</dataFormat>
                    <compressed>false</compressed>
                </imageFormat>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:DistributionAudioFeature -->
    <!-- NOTE() On distributionAudioFeature, both size and audioFormat are mandatory,  -->
    <!-- NOTE() it happens that sometimes size is equal to 'no size available', thus -->
    <!-- NOTE() there will not be a distributionAudioFeature element at output  -->
    <xsl:template name="DistributionAudioFeature">
        <xsl:param name="el" />
        <!-- size -->
        <xsl:for-each select="$el/ms:audioSizeInfo">
            <xsl:call-template name="Size">
                <xsl:with-param name="el" select="./ms:sizeInfo" />
                <xsl:with-param name="elementName" select="'size'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- audioFormat -->
        <xsl:choose>
            <!-- if there are audioFormatInfo information -->
            <xsl:when test="count($el/ms:audioFormatInfo) > 0">
                <xsl:for-each select="$el/ms:audioFormatInfo">
                    <audioFormat>
                        <!-- dataFormat  -->
                        <xsl:choose>
                            <xsl:when test="contains(lower-case(normalize-space(./ms:mimeType)), 'other')">
                                <dataFormat>http://w3id.org/meta-share/omtd-share/AudioFormat</dataFormat>
                            </xsl:when>
                            <xsl:when test="ms:get-meta-share-mimetype(./ms:mimeType) != ''">
                                <dataFormat>
                                    <xsl:value-of select="ms:get-meta-share-mimetype(./ms:mimeType)"/>
                                </dataFormat>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- this is supposed to thrown an error in order to deal with unknown mappings -->
                                <dataFormat>
                                    <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/Unknown/',normalize-space(./ms:mimeType))"/>
                                </dataFormat>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- signalEncoding -->
                        <xsl:call-template name="SignalEncoding">
                            <xsl:with-param name="el" select="./ms:signalEncoding" />
                        </xsl:call-template>
                        <!-- samplingRate  -->
                        <xsl:copy-of select="./ms:samplingRate" />
                        <!-- quantization  -->
                        <xsl:copy-of select="./ms:quantization" />
                        <!-- byteOrder -->
                        <xsl:choose>
                            <xsl:when test="contains(lower-case(normalize-space(./ms:byteOrder)), 'little')">
                                <byteOrder>http://w3id.org/meta-share/meta-share/littleEndian</byteOrder>
                            </xsl:when>
                            <xsl:when test="contains(lower-case(normalize-space(./ms:byteOrder)), 'big')">
                                <byteOrder>http://w3id.org/meta-share/meta-share/bigEndian</byteOrder>
                            </xsl:when>
                        </xsl:choose>
                        <!-- signConvention -->
                        <xsl:call-template name="ElementMetaShare">
                            <xsl:with-param name="el" select="./ms:signConvention" />
                            <xsl:with-param name="elementName" select="'signConvention'" />
                        </xsl:call-template>
                        <!-- compressed: QUESTION() Why this is mandatory? -->
                        <compressed>
                            <xsl:value-of select="if (./ms:compressionInfo/ms:compression = 'true') then 'true' else 'false'"/>
                        </compressed>
                    </audioFormat>
                </xsl:for-each>
            </xsl:when>
            <!-- alternatively use a default element -->
            <xsl:otherwise>
                <audioFormat>
                    <dataFormat>http://w3id.org/meta-share/omtd-share/AudioFormat</dataFormat>
                    <compressed>false</compressed>
                </audioFormat>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:DatasetDistributionForm -->
    <xsl:template name="DatasetDistributionForm">
        <xsl:param name="el" />
        <xsl:choose>
            <!-- 0 or 1 distributionAccessMedium -->
            <xsl:when test="count($el/ms:distributionAccessMedium) lt 2">
                <xsl:choose>
                    <!-- 1 distributionAccessMedium -->
                    <xsl:when test="normalize-space($el/ms:distributionAccessMedium) != ''">
                        <DatasetDistributionForm>
                            <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',normalize-space($el/ms:distributionAccessMedium))" />
                        </DatasetDistributionForm>
                    </xsl:when>
                    <!-- 0 distributionAccessMedium -->
                    <xsl:otherwise>
                        <DatasetDistributionForm>
                            <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', if (normalize-space(($el/ms:downloadLocation)[1]) != '') then 'downloadable' else 'other')" />
                        </DatasetDistributionForm>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- > 1 distributionAccessMedium -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- there is at least 1 downloadLocation -->
                    <xsl:when test="normalize-space(($el/ms:downloadLocation)[1]) != ''">
                        <DatasetDistributionForm>
                            <xsl:value-of select="'http://w3id.org/meta-share/meta-share/downloadable'" />
                        </DatasetDistributionForm>
                    </xsl:when>
                    <!-- keep only the first distributionAccessMedium -->
                    <xsl:otherwise>
                        <DatasetDistributionForm>
                            <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',normalize-space(($el/ms:distributionAccessMedium)[1]))" />
                        </DatasetDistributionForm>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:DatasetDistribution -->
    <xsl:template name="DatasetDistribution">
        <!-- DatasetDistribution -->
        <xsl:for-each select="$distributionInfo/*">
            <DatasetDistribution>
                <!-- QUESTION() What happen with distributionInfo/availability? -->
                <!-- QUESTION() what about multiple DatasetDistributionForm ? -->
                <!-- DatasetDistributionForm -->
                <xsl:call-template name="DatasetDistributionForm">
                    <xsl:with-param name="el" select="." />
                </xsl:call-template>
                <!-- distributionLocation -->
                <!-- downloadLocation -->
                <!-- QUESTION() what about multiple downloadLocations? -->
                <xsl:copy-of select="(./ms:downloadLocation)[1]" />
                <!-- accessLocation -->
                <!-- isAccessedBy -->
                <!-- isDisplayedBy -->
                <!-- isQueriedBy -->
                <!-- samplesLocation -->
                <!-- distribution[*]Feature -->
                <xsl:for-each select="$corpusInfo/ms:corpusMediaType">
                    <!-- distributionTextFeature | corpusTextInfo -->
                    <xsl:for-each select="./ms:corpusTextInfo">
                        <!-- build feature -->
                        <xsl:variable name="feature">
                            <xsl:call-template name="DistributionTextFeature">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- test if mandatory elements were created -->
                        <xsl:if test="(($feature/ms:size) and ($feature/ms:dataFormat))">
                            <distributionTextFeature>
                                <xsl:copy-of select="$feature" />
                            </distributionTextFeature>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- distributionTextNumericalFeature | corpusTextNumericalInfo -->
                    <xsl:for-each select="./ms:corpusTextNumericalInfo">
                        <!-- build feature -->
                        <xsl:variable name="feature">
                            <xsl:call-template name="DistributionTextNumericalFeature">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- test if mandatory elements were created -->
                        <xsl:if test="(($feature/ms:size) and ($feature/ms:dataFormat))">
                            <distributionTextNumericalFeature>
                                <xsl:copy-of select="$feature" />
                            </distributionTextNumericalFeature>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- distributionAudioFeature | corpusAudioInfo -->
                    <xsl:for-each select="./ms:corpusAudioInfo">
                        <!-- build feature -->
                        <xsl:variable name="feature">
                            <xsl:call-template name="DistributionAudioFeature">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- test if mandatory elements were created -->
                        <xsl:if test="(($feature/ms:size) and ($feature/ms:audioFormat))">
                            <distributionAudioFeature>
                                <xsl:copy-of select="$feature" />
                            </distributionAudioFeature>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- distributionImageFeature | corpusImageInfo -->
                    <xsl:for-each select="./ms:corpusImageInfo">
                        <!-- build feature -->
                        <xsl:variable name="feature">
                            <xsl:call-template name="DistributionImageFeature">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- test if mandatory elements were created -->
                        <xsl:if test="(($feature/ms:size) and ($feature/ms:imageFormat))">
                            <distributionImageFeature>
                                <xsl:copy-of select="$feature" />
                            </distributionImageFeature>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- distributionVideoFeature | corpusVideoInfo -->
                    <xsl:for-each select="./ms:corpusVideoInfo">
                        <!-- build feature -->
                        <xsl:variable name="feature">
                            <xsl:call-template name="DistributionVideoFeature">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- test if mandatory elements were created -->
                        <xsl:if test="(($feature/ms:size) and ($feature/ms:videoFormat))">
                            <distributionVideoFeature>
                                <xsl:copy-of select="$feature" />
                            </distributionVideoFeature>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- distribution | corpusTextNgramInfo -->
                    <!-- QUESTION() To which distribution[*]Feature should corpusTextNgramInfo be transferred? -->
                </xsl:for-each>
                <!-- licenceTerms -->
                <xsl:for-each select="./ms:licenceInfo">
                    <!-- licenceTermsName -->
                    <xsl:variable name="licenseName">
                      <xsl:choose>
                        <xsl:when test="normalize-space(./ms:version) != ''"><xsl:value-of select="upper-case(concat(./ms:licence,'-', ./ms:version))" /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="upper-case(./ms:licence)" /></xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <!-- all kind of licenses excepting ELRA -->
                    <xsl:if test="substring($licenseName,1,4) != 'ELRA'">
                        <licenceTerms>
                            <!-- licenceTermsName -->
                            <xsl:choose>
                                <xsl:when test="((substring($licenseName,1,2) != 'MS')    and
                                                 (substring($licenseName,1,5) != 'OTHER') and
                                                 (substring($licenseName,1,5) != 'PROPR')
                                                 )">
                                    <licenceTermsName xml:lang="en">
                                        <xsl:value-of select="$licenseName" />
                                    </licenceTermsName>
                                </xsl:when>
                                <xsl:otherwise>
                                    <licenceTermsName xml:lang="en">
                                        <xsl:value-of select="normalize-space(./ms:licence)" />
                                    </licenceTermsName>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- licenceTermsURL -->
                            <xsl:variable name="restrictions">
                                <xsl:call-template name="StringValuesConcat">
                                    <xsl:with-param name="el" select="./ms:restrictionsOfUse" />
                                    <xsl:with-param name="separator" select="'-'" />
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="((substring($licenseName,1,5) = 'OTHER') or
                                                ((substring($licenseName,1,5) = 'PROPR')))">
                                    <licenceTermsURL><xsl:value-of select="'https://example.org/licenses/other.html'" /></licenceTermsURL>
                                    <LicenceIdentifier ms:LicenceIdentifierScheme="http://w3id.org/meta-share/meta-share/elg"><xsl:value-of select="'other'" /></LicenceIdentifier>
                                </xsl:when>
                                <xsl:when test="substring($licenseName,1,3) = 'CC-'">
                                    <licenceTermsURL><xsl:value-of select="concat('https://spdx.org/licenses/',$licenseName, '.html')" /></licenceTermsURL>
                                    <LicenceIdentifier ms:LicenceIdentifierScheme="http://w3id.org/meta-share/meta-share/SPDX"><xsl:value-of select="$licenseName" /></LicenceIdentifier>
                                </xsl:when>
                                <xsl:when test="substring($licenseName,1,3) = 'MS-'">
                                    <xsl:choose>
                                        <xsl:when test="contains($licenseName,'MS-NC-NORED')">
                                            <licenceTermsURL>
                                                <xsl:value-of select="'http://www.meta-share.org/assets/pdf/META-SHARE_NonCommercial_NoRedistribution_v2.0.pdf'" />
                                            </licenceTermsURL>
                                        </xsl:when>
                                        <xsl:when test="contains($licenseName,'MS-C-NORED')">
                                            <licenceTermsURL>
                                                <xsl:value-of select="'http://www.meta-share.org/assets/pdf/META-SHARE_NoRedistribution_v2.0.pdf'" />
                                            </licenceTermsURL>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <licenceTermsURL>
                                                <xsl:value-of select="concat('http://www.meta-share.org/assets/pdf/',$licenseName, '.pdf')" />
                                            </licenceTermsURL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <LicenceIdentifier ms:LicenceIdentifierScheme="http://w3id.org/meta-share/meta-share/elg"><xsl:value-of select="normalize-space(./ms:licence)" /></LicenceIdentifier>
                                </xsl:when>
                                <xsl:otherwise>
                                    <licenceTermsURL>http://example.org/licenses/<xsl:value-of select="translate(upper-case($licenseName),'_','-')" />#<xsl:value-of select="lower-case($restrictions)" /></licenceTermsURL>
                                </xsl:otherwise>
                            </xsl:choose>
                        </licenceTerms>
                    </xsl:if>
                    <!-- ELRA licenses -->
                    <xsl:if test="substring($licenseName,1,4) = 'ELRA'">
                        <!-- licenceTermsIdentifier -->
                        <xsl:variable name="licenceTermsIdentifier">
                            <xsl:call-template name="ElraLicenseIdentifierGenerator">
                                <xsl:with-param name="el" select="." />
                                <xsl:with-param name="version" select="'1.0'" />
                                <xsl:with-param name="separator" select="'-'" />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- licenceTerms -->
                        <licenceTerms>
                            <!-- licenceTermsName -->
                            <licenceTermsName xml:lang="en"><xsl:value-of select="$licenceTermsIdentifier" /></licenceTermsName>
                            <!-- licenceTermsUrl -->
                            <licenceTermsURL><xsl:value-of select="concat('http://www.elra.info/licenses/',$licenceTermsIdentifier, '.html')" /></licenceTermsURL>
                            <!-- LicenceIdentifier -->
                            <LicenceIdentifier ms:LicenceIdentifierScheme="http://w3id.org/meta-share/meta-share/other"><xsl:value-of select="$licenceTermsIdentifier" /></LicenceIdentifier>
                        </licenceTerms>
                    </xsl:if>
                </xsl:for-each>
                <!-- attributionText -->
                <xsl:for-each select="./ms:attributionText">
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'attributionText'" />
                    </xsl:call-template>
                </xsl:for-each>
                <!-- cost -->
                <xsl:if test="normalize-space(./ms:fee) != ''">
                    <cost>
                        <!-- ms:amount -->
                        <amount><xsl:value-of select="normalize-space(./ms:fee)" /></amount>
                        <!-- ms:currency -->
                        <currency>http://w3id.org/meta-share/meta-share/euro</currency>
                    </cost>
                </xsl:if>
                <!-- membershipInstitution -->
                <xsl:for-each select="./ms:membershipInfo">
                    <xsl:call-template name="ElementMetaShare">
                        <xsl:with-param name="el" select="./ms:membershipInstitution" />
                        <xsl:with-param name="elementName" select="'membershipInstitution'" />
                    </xsl:call-template>
                </xsl:for-each>
                <!-- ms:availabilityStartDate -->
                <xsl:copy-of select="./ms:availabilityStartDate" />
                <!-- ms:availabilityEndDate -->
                <xsl:copy-of select="./ms:availabilityEndDate" />
                <!-- ms:distributionRightsHolder -->
                <xsl:call-template name="Actor">
                    <xsl:with-param name="el" select="./ms:distributionRightsHolder" />
                    <xsl:with-param name="actorElement" select="'distributionRightsHolder'" />
                </xsl:call-template>
            </DatasetDistribution>
        </xsl:for-each>
    </xsl:template>

    <!-- template:SegmentationLevel -->
    <xsl:template name="SegmentationLevel">
        <xsl:param name="el" />
        <!-- segmentationLevel -->
        <xsl:for-each select="$el">
            <xsl:choose>
                <xsl:when test="contains(lower-case(normalize-space(.)), 'word')">
                    <segmentationLevel>http://w3id.org/meta-share/meta-share/word1</segmentationLevel>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ElementMetaShare">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementName" select="'segmentationLevel'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- template:TextIncludedInImage -->
    <xsl:template name="TextIncludedInImage">
        <xsl:param name="el" />
        <!-- textIncludedInImage -->
        <xsl:choose>
            <xsl:when test="contains(lower-case(normalize-space(.)), 'caption')">
                <textIncludedInImage>http://w3id.org/meta-share/meta-share/caption</textIncludedInImage>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space(.)), 'none')">
                <textIncludedInImage>http://w3id.org/meta-share/meta-share/none2</textIncludedInImage>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space(.)), 'subtitles')">
                <textIncludedInImage>http://w3id.org/meta-share/meta-share/subtitle2</textIncludedInImage>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'textIncludedInImage'" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:TextIncludedInVideo -->
    <xsl:template name="TextIncludedInVideo">
        <xsl:param name="el" />
        <!-- textIncludedInVideo -->
        <xsl:choose>
            <xsl:when test="contains(lower-case(normalize-space(.)), 'caption')">
                <textIncludedInVideo>http://w3id.org/meta-share/meta-share/caption1</textIncludedInVideo>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space(.)), 'none')">
                <textIncludedInVideo>http://w3id.org/meta-share/meta-share/none1</textIncludedInVideo>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space(.)), 'subtitles')">
                <textIncludedInVideo>http://w3id.org/meta-share/meta-share/subtitle1</textIncludedInVideo>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'textIncludedInVideo'" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:AnnotatedElement -->
    <xsl:template name="AnnotatedElements">
        <xsl:param name="el" />
        <!-- annotatedElements -->
        <xsl:for-each select="$el">
            <xsl:choose>
                <xsl:when test="contains(lower-case(normalize-space(.)), 'mispronun')">
                    <annotatedElement>http://w3id.org/meta-share/meta-share/mispronunciation</annotatedElement>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ElementMetaShare">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementName" select="'annotatedElement'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- template:EncodingLevel -->
    <xsl:template name="EncodingLevel">
        <xsl:param name="el" />
        <xsl:param name="default" />
        <!-- encodingLevel -->
        <xsl:choose>
            <xsl:when test="count($el/ms:encodingLevel) > 0">
                <xsl:for-each select="$el/ms:encodingLevel">
                    <xsl:choose>
                        <xsl:when test="contains(lower-case(normalize-space(.)), 'seman')">
                            <encodingLevel>http://w3id.org/meta-share/meta-share/semantics</encodingLevel>
                        </xsl:when>
                        <xsl:otherwise>
                            <encodingLevel>
                                <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', .)" />
                            </encodingLevel>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <encodingLevel><xsl:value-of select="$default" /></encodingLevel>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:SignalEncoding -->
    <xsl:template name="SignalEncoding">
        <xsl:param name="el" />
        <!-- signalEncoding -->
        <xsl:for-each select="$el">
            <xsl:choose>
                <xsl:when test="contains(lower-case(normalize-space(.)), 'μ')">
                    <signalEncoding>http://w3id.org/meta-share/meta-share/mu-law</signalEncoding>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ElementMetaShare">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementName" select="'signalEncoding'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- template:LcrSubclass -->
    <xsl:template name="LcrSubclass">
        <xsl:param name="el" />
        <!-- lcrSubclass -->
        <xsl:choose>
            <xsl:when test="contains(lower-case(normalize-space($el)), 'wordlist')">
                <lcrSubclass>http://w3id.org/meta-share/meta-share/wordlist</lcrSubclass>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="$el" />
                    <xsl:with-param name="elementName" select="'lcrSubclass'" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:LTClass -->
    <xsl:template name="LTClass">
        <xsl:param name="el" />
        <!-- LTClassRecommended -->
        <xsl:choose>
            <xsl:when test="contains(lower-case(normalize-space($el)), 'textualentailment')">
                <LTClassRecommended>http://w3id.org/meta-share/omtd-share/AnnotationOfTextualEntailment</LTClassRecommended>
            </xsl:when>
            <xsl:otherwise>
                <LTClassOther>
                    <xsl:value-of select="normalize-space($el)"/>
                </LTClassOther>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:Language -->
    <xsl:template name="Language">
        <xsl:param name="el" />
        <!-- languageTag -->
        <languageTag><xsl:value-of select="$el/ms:languageId" /></languageTag>
        <!-- languageId -->
        <xsl:choose>
            <xsl:when test="substring(lower-case(normalize-space($el/ms:languageId)),1,3) = 'es-'">
              <languageId>es</languageId>
            </xsl:when>
            <xsl:when test="substring(lower-case(normalize-space($el/ms:languageId)),1,3) = 'lsf'">
              <languageId>sgn</languageId>
            </xsl:when>
            <xsl:when test="substring(lower-case(normalize-space($el/ms:languageId)),1,3) = 'pt-'">
              <languageId>pt</languageId>
            </xsl:when>
            <xsl:when test="substring(lower-case(normalize-space($el/ms:languageId)),1,3) = 'sr-'">
              <languageId>sr</languageId>
            </xsl:when>
            <xsl:when test="substring(lower-case(normalize-space($el/ms:languageId)),1,3) = 'ur-'">
              <languageId>ur</languageId>
            </xsl:when>
            <xsl:when test="substring(lower-case(normalize-space($el/ms:languageId)),1,3) = 'zh-'">
              <languageId>zh</languageId>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$el/ms:languageId" />
            </xsl:otherwise>
        </xsl:choose>
        <!-- scriptId -->
        <xsl:choose>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'arabic')">
              <scriptId>Arab</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'bengali')">
              <scriptId>Beng</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'cyrillic')">
              <scriptId>Cyrl</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'devanagari')">
              <scriptId>Deva</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'ethiopic')">
              <scriptId>Ethi</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'greek')">
              <scriptId>Grek</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'gujarati')">
              <scriptId>Gujr</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'gurmukhi')">
              <scriptId>Guru</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'japanese')">
              <scriptId>Jpan</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'kannada')">
              <scriptId>Kana</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'latin')">
              <scriptId>Latn</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'malayalam')">
              <scriptId>Maya</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'orya')">
              <scriptId>Oriya</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'sinhala')">
              <scriptId>Sinh</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'tamil')">
              <scriptId>Taml</scriptId>
            </xsl:when>
            <xsl:when test="contains(lower-case(normalize-space($el/ms:languageScript)), 'telugu')">
              <scriptId>Telu</scriptId>
            </xsl:when>
        </xsl:choose>
        <!-- regionId  -->
        <xsl:if test="normalize-space($el/ms:region) != ''">
            <xsl:choose>
                <xsl:when test="contains(lower-case(normalize-space($el/ms:region)), 'latin america')">
                <!-- DO NOT MAP -->
                </xsl:when>
                <xsl:when test="contains(lower-case(normalize-space($el/ms:region)), 'brazil')">
                    <regionId>BR</regionId>
                </xsl:when>
                <xsl:when test="contains(lower-case(normalize-space($el/ms:region)), 'china')">
                    <regionId>CN</regionId>
                </xsl:when>
                <xsl:when test="contains(lower-case(normalize-space($el/ms:region)), 'macedonia')">
                    <regionId>MK</regionId>
                </xsl:when>
                <xsl:when test="contains(lower-case(normalize-space($el/ms:region)), 'pakistan')">
                    <regionId>PK</regionId>
                </xsl:when>
                <xsl:otherwise>
                    <regionId><xsl:value-of select="$el/ms:region" /></regionId>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- variantId  -->
        <!-- <variantId><xsl:value-of select="$el/ms:variant" /></variantId> -->
        <!-- languageName -->
        <!-- QUESTION() why languageName is not longer available -->
        <!-- <languageName><xsl:value-of select="$el/ms:languageName" /></languageName> -->
    </xsl:template>

    <!-- template:Size -->
    <xsl:template name="Size">
        <xsl:param name="el" />
        <xsl:param name="elementName" />
        <!-- QUESTION() is there an alternative to deal with size:'no size available'? -->
        <!-- grep-number() allows to match size expressions like 'to 18' or 'set: 3.75' -->
        <!-- <xsl:message><xsl:value-of select="ms:grep-number($el/ms:size)" /></xsl:message> -->
        <xsl:if test="ms:grep-number($el/ms:size) != 'NaN'">
            <xsl:element name="{$elementName}">
                <!-- amount -->
                <amount><xsl:value-of select="ms:grep-number($el/ms:size)" /></amount>
                <!-- sizeUnit -->
                <!-- DO NOT CHANGER ORDER DECLARATION -->
                <xsl:choose>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'entries')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/entry</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'expressions')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/expression</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'files')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/file</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'frames')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/frame1</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'hours')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/hour1</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'hpairs')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/T-HPair</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'images')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/image2</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'items')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/item</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'minutes')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/minute</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'sentences')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/sentence1</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'terms')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/term</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'texts')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/text1</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'tokens')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/token</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'units')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/unit</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'utterances')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/utterance1</sizeUnit>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(normalize-space($el/ms:sizeUnit)), 'words')">
                      <sizeUnit>http://w3id.org/meta-share/meta-share/word3</sizeUnit>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="ElementMetaShare">
                            <xsl:with-param name="el" select="$el/ms:sizeUnit" />
                            <xsl:with-param name="elementName" select="'sizeUnit'" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- template:hasSubset -->
    <xsl:template name="HasSubset">
        <xsl:param name="el" />
        <xsl:for-each select="$el/ms:sizeInfo">
            <xsl:if test="string(number(./ms:size)) != 'NaN'">
                <!-- ToBeDefined -->
                <hasSubset>
                    <!-- sizePerLanguage -->
                    <xsl:call-template name="Size">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementName" select="'sizePerLanguage'" />
                    </xsl:call-template>
                    <!-- sizePerTextFormat -->
                    <!-- ToBeDefined : QUESTION() why sizePerTextFormat is mandatory? -->
                    <!-- QUESTION() What happen with sizePerLanguageVariety? -->
                    <xsl:call-template name="Size">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementName" select="'sizePerTextFormat'" />
                    </xsl:call-template>
                </hasSubset>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- template:annotation -->
    <xsl:template name="annotation">
        <xsl:param name="el" />
        <xsl:for-each select="$el/ms:annotationInfo">
            <!-- var:annotationType -->
            <xsl:variable name="annotationType">
               <!-- DO NOT CHANGER ORDER DECLARATION -->
               <xsl:choose>
                    <xsl:when test="lower-case(./ms:annotationType) = 'other'">
                        <xsl:value-of select="'DomainSpecificAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'alignment')">
                        <xsl:value-of select="'DomainSpecificAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'bodymovements')">
                        <xsl:value-of select="'DomainSpecificAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'handarmgestures')">
                        <xsl:value-of select="'DomainSpecificAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'lemma')">
                        <xsl:value-of select="'Lemma'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'postag')">
                        <xsl:value-of select="'PartOfSpeech'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'morphosyntacticannotation')">
                        <xsl:value-of select="'MorphologicalAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'segmentation')">
                        <xsl:value-of select="'Sentence'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'semanticannotation')">
                        <xsl:value-of select="'SemanticAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'speechannotation')">
                        <xsl:value-of select="'SpeechAct'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'structuralannotation')">
                        <xsl:value-of select="'StructuralAnnotationType'" />
                    </xsl:when>
                    <xsl:when test="contains(lower-case(./ms:annotationType),'syntacticannotation')">
                        <xsl:value-of select="'SyntacticAnnotationType'" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="./ms:annotationType" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- NOTE() castable is avalaible only using Saxon-SA -->
            <!-- <xsl:if test="not($annotationType castable as ms:AnnotationType)"> -->
            <!-- </xsl:if> -->
            <!-- annotation -->
            <annotation>
                <!-- annotationType -->
                <annotationType>
                    <xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/', $annotationType)" />
                </annotationType>
                <!-- annotatedElements -->
                <xsl:call-template name="AnnotatedElements">
                    <xsl:with-param name="el" select="./ms:annotatedElements" />
                </xsl:call-template>
                <!-- segmentationLevel -->
                <xsl:call-template name="SegmentationLevel">
                    <xsl:with-param name="el" select="./ms:segmentationLevel" />
                </xsl:call-template>
                <!-- annotationStandoff -->
                <xsl:copy-of select="./ms:annotationStandoff"/>
                <!-- guidelines -->
                <!-- ToBeMapped with annotationManual -->
                <!-- tagset -->
                <xsl:if test="normalize-space(./ms:tagset) != ''">
                    <tagset>
                        <xsl:call-template name="ElementCopyWithDefaultLang">
                            <xsl:with-param name="el" select="./ms:tagset" />
                            <xsl:with-param name="elementLang" select="'en'" />
                            <xsl:with-param name="elementName" select="'resourceName'" />
                        </xsl:call-template>
                    </tagset>
                </xsl:if>
                <!-- theoreticModel -->
                <xsl:call-template name="ElementCopyWithDefaultLang">
                    <xsl:with-param name="el" select="./ms:theoreticModel" />
                    <xsl:with-param name="elementLang" select="'en'" />
                    <xsl:with-param name="elementName" select="'theoreticModel'" />
                </xsl:call-template>
                <!-- annotationMode -->
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="./ms:annotationMode" />
                    <xsl:with-param name="elementName" select="'annotationMode'" />
                </xsl:call-template>
                <!-- annotationModeDetails -->
                <xsl:call-template name="ElementCopyWithDefaultLang">
                    <xsl:with-param name="el" select="./ms:annotationModeDetails" />
                    <xsl:with-param name="elementLang" select="'en'" />
                    <xsl:with-param name="elementName" select="'annotationModeDetails'" />
                </xsl:call-template>
                <!-- isAnnotatedBy -->
                <xsl:for-each select="./ms:annotationTool">
                    <isAnnotatedBy>
                        <xsl:call-template name="ElementCopyWithDefaultLang">
                            <xsl:with-param name="el" select="./ms:targetResourceNameURI" />
                            <xsl:with-param name="elementLang" select="'en'" />
                            <xsl:with-param name="elementName" select="'resourceName'" />
                        </xsl:call-template>
                    </isAnnotatedBy>
                </xsl:for-each>
                <!-- annotator -->
                <xsl:call-template name="Actor">
                    <xsl:with-param name="el" select="./ms:annotator" />
                    <xsl:with-param name="actorElement" select="'annotator'" />
                </xsl:call-template>
                <!-- annotationStartDate -->
                <xsl:copy-of select="./ms:annotationStartDate"/>
                <!-- annotationEndDate -->
                <xsl:copy-of select="./ms:annotationEndDate"/>
                <!-- interannotatorAgreement -->
                <xsl:call-template name="ElementCopyWithDefaultLang">
                    <xsl:with-param name="el" select="./ms:interannotatorAgreement" />
                    <xsl:with-param name="elementLang" select="'en'" />
                    <xsl:with-param name="elementName" select="'interannotatorAgreement'" />
                </xsl:call-template>
                <!-- intraannotatorAgreement -->
                <xsl:call-template name="ElementCopyWithDefaultLang">
                    <xsl:with-param name="el" select="./ms:intraannotatorAgreement" />
                    <xsl:with-param name="elementLang" select="'en'" />
                    <xsl:with-param name="elementName" select="'intraannotatorAgreement'" />
                </xsl:call-template>
                <!-- annotationReport -->
                <!-- QUESTION() What about annotationFormat? -->
                <!-- QUESTION() What about conformanceToStandardsBestPractices? -->
            </annotation>
        </xsl:for-each>
    </xsl:template>

    <!-- template:CorpusPartStart -->
    <xsl:template name="CorpusPartStart">
        <xsl:param name="el" />
        <xsl:param name="corpusMediaType" />
        <!-- corpusMediaType  -->
        <corpusMediaType><xsl:value-of select="$corpusMediaType" /></corpusMediaType>
        <!-- mediaType: CorpusTextPart -->
        <xsl:if test="$corpusMediaType = 'CorpusTextPart'"> 
            <mediaType>http://w3id.org/meta-share/meta-share/text</mediaType>
        </xsl:if>
        <!-- mediaType: CorpusAudioPart -->
        <xsl:if test="$corpusMediaType = 'CorpusAudioPart'"> 
            <mediaType>http://w3id.org/meta-share/meta-share/audio</mediaType>
        </xsl:if>
        <!-- mediaType: CorpusVideoPart -->
        <xsl:if test="$corpusMediaType = 'CorpusVideoPart'"> 
            <mediaType>http://w3id.org/meta-share/meta-share/video</mediaType>
        </xsl:if>
        <!-- mediaType: CorpusImagePart -->
        <xsl:if test="$corpusMediaType = 'CorpusImagePart'"> 
            <mediaType>http://w3id.org/meta-share/meta-share/image</mediaType>
        </xsl:if>
        <!-- mediaType: CorpusTextNumericalPart -->
        <xsl:if test="$corpusMediaType = 'CorpusTextNumericalPart'">
            <mediaType>http://w3id.org/meta-share/meta-share/textNumerical</mediaType>
        </xsl:if>
        <!-- all elements excepting CorpusTextNumericalPart  -->
        <xsl:if test="$corpusMediaType != 'CorpusTextNumericalPart'"> 
            <!-- lingualityType  -->
            <xsl:call-template name="ElementMetaShareDefault">
                <xsl:with-param name="el" select="$el/ms:lingualityInfo/ms:lingualityType" />
                <xsl:with-param name="default" select="'monolingual'" />
                <xsl:with-param name="elementName" select="'lingualityType'" />
            </xsl:call-template>
            <!-- multilingualityType -->
            <xsl:if test="normalize-space($el/ms:lingualityInfo/ms:multilingualityType) != ''">
                <multilingualityType>
                    <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', $el/ms:lingualityInfo/ms:multilingualityType)" />
                </multilingualityType>
            </xsl:if>
            <!-- multilingualityTypeDetails -->
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="$el/ms:lingualityInfo/ms:multilingualityTypeDetails" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'multilingualityTypeDetails'" />
            </xsl:call-template>
            <!-- language -->
            <xsl:choose>
                <xsl:when test="count($el/ms:languageInfo) > 0">
                    <xsl:for-each select="$el/ms:languageInfo">
                        <language>
                            <xsl:call-template name="Language">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </language>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <language><languageTag>und</languageTag></language>
                </xsl:otherwise>
            </xsl:choose>
            <!-- languageVariety -->
            <xsl:for-each select="$el/ms:languageInfo/ms:languageVarietyInfo">
                <languageVariety>
                    <!-- languageVarietyType -->
                    <languageVarietyType>
                        <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', ./ms:languageVarietyType)" />
                    </languageVarietyType>
                    <!-- languageVarietyName -->
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="./ms:languageVarietyName" />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'languageVarietyName'" />
                    </xsl:call-template>
                </languageVariety>
            </xsl:for-each>
        </xsl:if>
        <!-- modalityType -->
        <xsl:for-each select="$el/ms:modalityInfo">
            <xsl:for-each select="./ms:modalityType">
                <xsl:call-template name="ElementMetaShareDefault">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="default" select="'other'" />
                    <xsl:with-param name="elementName" select="'modalityType'" />
                </xsl:call-template>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!-- template:CorpusPartMid -->
    <xsl:template name="CorpusPartMid">
        <xsl:param name="el" />
        <xsl:param name="corpusMediaType" />
        <!-- CorpusTextPart -->
        <xsl:if test="$corpusMediaType = 'CorpusTextPart'">
            <!-- "ms:textType" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:textClassificationInfo/ms:textType">
                <textType>
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'categoryLabel'" />
                    </xsl:call-template>
                </textType>
            </xsl:for-each>
            <!-- "ms:TextGenre" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:textClassificationInfo/ms:textGenre">
                <TextGenre>
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'categoryLabel'" />
                    </xsl:call-template>
                </TextGenre>
            </xsl:for-each>
        </xsl:if>
        <!-- CorpusImagePart -->
        <xsl:if test="$corpusMediaType = 'CorpusImagePart'">
            <!-- "ImageGenre" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:textClassificationInfo/ms:imageGenre">
                <ImageGenre>
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="." />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'categoryLabel'" />
                    </xsl:call-template>
                </ImageGenre>
            </xsl:for-each>
            <!-- "typeOfImageContent" maxOccurs="unbounded" -->
            <!-- QUESTION() what would be a default value ?  -->
            <xsl:if test="not(./ms:imageContentInfo)">
                <typeOfImageContent xml:lang="en">undefined</typeOfImageContent>
            </xsl:if>
            <xsl:for-each select="./ms:imageContentInfo/ms:typeOfImageContent">
                <typeOfImageContent xml:lang="und"><xsl:value-of select="." /></typeOfImageContent>
            </xsl:for-each>
            <!-- "textIncludedInImage" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:imageContentInfo/ms:textIncludedInImage">
                <xsl:call-template name="TextIncludedInImage">
                    <xsl:with-param name="el" select="." />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "staticElement" minOccurs="0" maxOccurs="unbounded" -->
            <!-- ToBeMapped with staticElementInfo -->
        </xsl:if>
        <!-- CorpusAudioPart -->
        <xsl:if test="$corpusMediaType = 'CorpusAudioPart'">
            <!-- "AudioGenre" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:audioClassificationInfo">
                <AudioGenre>
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="./ms:audioGenre" />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'categoryLabel'" />
                    </xsl:call-template>
                </AudioGenre>
            </xsl:for-each>
            <!-- "SpeechGenre" minOccurs="0" maxOccurs="unbounded" -->
            <!-- ToBeMapped with /audioClassificationInfoType/speechGenre[0:] -->
            <!-- "speechItem" minOccurs="0" maxOccurs="unbounded" -->
            <!-- ToBeMapped with /audioContentInfoType/speechItems[0:unbounded] -->
            <!-- "nonSpeechItem" minOccurs="0" maxOccurs="unbounded" -->
            <!-- ToBeMapped with /audioContentInfoType/nonSpeechItems[0:unbounded] -->
            <!-- "legend" minOccurs="0" -->
            <!-- ToBeMapped with /audioContentInfoType/textualDescription[0:] -->
            <!-- "noiseLevel" minOccurs="0" -->
            <!-- ToBeMapped with /audioContentInfoType/noiseLevel[0:] -->
        </xsl:if>
        <!-- CorpusVideoPart -->
        <xsl:if test="$corpusMediaType = 'CorpusVideoPart'">
            <!-- "VideoGenre" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:videoClassificationInfo">
                <VideoGenre>
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="./ms:videoGenre" />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'categoryLabel'" />
                    </xsl:call-template>
                </VideoGenre>
            </xsl:for-each>
            <!-- "typeOfVideoContent" maxOccurs="unbounded" -->
            <!-- QUESTION() what would be a default value ?  -->
            <xsl:if test="not(./ms:videoContentInfo)">
                <typeOfVideoContent xml:lang="en">undefined</typeOfVideoContent>
            </xsl:if>
            <xsl:for-each select="./ms:videoContentInfo/ms:typeOfVideoContent">
                <typeOfVideoContent xml:lang="und"><xsl:value-of select="." /></typeOfVideoContent>
            </xsl:for-each>
            <!-- "textIncludedInVideo" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:videoContentInfo/ms:textIncludedInVideo">
                <xsl:call-template name="TextIncludedInVideo">
                    <xsl:with-param name="el" select="." />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "dynamicElement" minOccurs="0" maxOccurs="unbounded" -->
            <!-- ToBeMapped with /videoContentInfoType/dynamicElementInfo[0:] -->
        </xsl:if>
        <!-- CorpusAudioPart | CorpusVideoPart -->
        <xsl:if test="(($corpusMediaType = 'CorpusAudioPart') or
                       ($corpusMediaType = 'CorpusVideoPart'))">
            <!-- "naturality" minOccurs="0" -->
            <xsl:call-template name="ElementMetaShare">
                <xsl:with-param name="el" select="./ms:settingInfo/ms:naturality" />
                <xsl:with-param name="elementName" select="'naturality'" />
            </xsl:call-template>
            <!-- "conversationalType" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:settingInfo/ms:conversationalType">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'conversationalType'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "scenarioType" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:for-each select="./ms:settingInfo/ms:scenarioType">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'scenarioType'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "audience" minOccurs="0" -->
            <xsl:variable name="audienceMaps">
               <entry><source>no</source><target>none3</target></entry>
            </xsl:variable>
            <xsl:call-template name="ElementMetaShare">
                <xsl:with-param name="el" select="./ms:settingInfo/ms:audience" />
                <xsl:with-param name="mappings" select="$audienceMaps" />
                <xsl:with-param name="elementName" select="'audience'" />
            </xsl:call-template>
            <!-- "interactivity" minOccurs="0" -->
            <xsl:variable name="interactivityMaps">
               <entry><source>interactive</source><target>interactive1</target></entry>
            </xsl:variable>
            <xsl:call-template name="ElementMetaShare">
                <xsl:with-param name="el" select="./ms:settingInfo/ms:interactivity" />
                <xsl:with-param name="mappings" select="$interactivityMaps" />
                <xsl:with-param name="elementName" select="'interactivity'" />
            </xsl:call-template>
            <!-- "interaction" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="./ms:settingInfo/ms:interaction" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'interaction'" />
            </xsl:call-template>
        </xsl:if>
        <!-- CorpusTextNumericalPart -->
        <xsl:if test="$corpusMediaType = 'CorpusTextNumericalPart'">
            <!-- "typeOfTextNumericalContent" maxOccurs="unbounded" -->
            <!-- QUESTION() what would be a default value ?  -->
            <xsl:if test="not(./ms:textNumericalContentInfo)">
                <typeOfTextNumericalContent xml:lang="en">undefined</typeOfTextNumericalContent>
            </xsl:if>
            <xsl:for-each select="./ms:textNumericalContentInfo/ms:typeOfTextNumericalContent">
                <typeOfTextNumericalContent xml:lang="und"><xsl:value-of select="." /></typeOfTextNumericalContent>
            </xsl:for-each>
        </xsl:if>
        <!-- CorpusAudioPart | CorpusVideoPart | CorpusTextNumericalPart -->
        <xsl:if test="(($corpusMediaType = 'CorpusAudioPart') or
                       ($corpusMediaType = 'CorpusVideoPart') or
                       ($corpusMediaType = 'CorpusTextNumericalPart'))">
            <!-- "recordingDeviceType" minOccurs="0" -->
            <xsl:variable name="recordingDeviceTypeMaps">
               <entry><source>hardDisk</source><target>hardDisk1</target></entry>
            </xsl:variable>
            <xsl:for-each select="(./ms:recordingInfo/ms:recordingDeviceType)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="mappings" select="$recordingDeviceTypeMaps" />
                    <xsl:with-param name="elementName" select="'recordingDeviceType'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "recordingDeviceTypeDetails" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="./ms:recordingInfo/ms:recordingDeviceTypeDetails" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'recordingDeviceTypeDetails'" />
            </xsl:call-template>
            <!-- "recordingPlatformSoftware" minOccurs="0" -->
            <xsl:for-each select="(./ms:recordingInfo/ms:recordingPlatformSoftware)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'recordingPlatformSoftware'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "recordingEnvironment" minOccurs="0" -->
            <xsl:for-each select="(./ms:recordingInfo/ms:recordingEnvironment)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'recordingEnvironment'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "sourceChannel" minOccurs="0" -->
            <xsl:for-each select="(./ms:recordingInfo/ms:sourceChannel)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'sourceChannel'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- ******************************************************************************************** -->
            <!-- "sourceChannelType" minOccurs="0" maxOccurs="unbounded"                                      -->
            <!-- type:      meta[xs:string]                          elg[xs:anyURI]                           -->
            <!-- occurs:    meta[0:unbounded]                        elg[0:1]                                 -->
            <!-- maxlength: meta[30]                                 elg[restrict]                            -->
            <!-- restrict:  meta[3G]                                 elg[ThreeG]                              -->
            <!-- ******************************************************************************************** -->
            <xsl:variable name="sourceChannelTypeMaps">
                <entry><source>3G</source><target>ThreeG</target></entry>
            </xsl:variable>
            <xsl:for-each select="(./ms:recordingInfo/ms:sourceChannelType)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="mappings" select="$sourceChannelTypeMaps" />
                    <xsl:with-param name="elementName" select="'sourceChannelType'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- ******************************************************************************************** -->
            <!-- "sourceChannelName" minOccurs="0" maxOccurs="unbounded"                                      -->
            <!-- type:      meta[xs:string]                          elg[ms:langString]                       -->
            <!-- maxlength: meta[30]                                 elg[100]                                 -->
            <!-- ******************************************************************************************** -->
            <xsl:for-each select="./ms:recordingInfo/ms:sourceChannelName">
                <xsl:call-template name="ElementCopyWithDefaultLang">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementLang" select="'en'" />
                    <xsl:with-param name="elementName" select="'sourceChannelName'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "sourceChannelDetails" minOccurs="0" maxOccurs="unbounded" -->
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="./ms:recordingInfo/ms:sourceChannelDetails" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'sourceChannelDetails'" />
            </xsl:call-template>
            <!-- "recorder" minOccurs="0" maxOccurs="unbounded" -->
        </xsl:if>
        <!-- CorpusAudioPart | CorpusVideoPart | CorpusTextNumericalPart | CorpusImagePart -->
        <xsl:if test="(($corpusMediaType = 'CorpusAudioPart') or
                       ($corpusMediaType = 'CorpusVideoPart') or
                       ($corpusMediaType = 'CorpusTextNumericalPart') or
                       ($corpusMediaType = 'CorpusImagePart'))">
            <!-- ******************************************************************************************** -->
            <!-- "capturingDeviceType" minOccurs="0" maxOccurs="unbounded"                                    -->
            <!-- type:      meta[xs:string]                          elg[xs:anyURI]                           -->
            <!-- occurs:    meta[0:unbounded]                        elg[0:1]                                 -->
            <!-- maxlength: meta[30]                                 elg[restrict]                            -->
            <!-- restrict:  meta[laryngograph]                       elg[laryngograph1]                       -->
            <!-- restrict:  meta[microphone]                         elg[microphone1]                         -->
            <!-- ******************************************************************************************** -->
            <xsl:variable name="capturingDeviceTypeMaps">
                <entry><source>laryngograph</source><target>laryngograph1</target></entry>
                <entry><source>microphone</source><target>microphone1</target></entry>
            </xsl:variable>
            <xsl:for-each select="(./ms:captureInfo/ms:capturingDeviceType)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="mappings" select="$capturingDeviceTypeMaps" />
                    <xsl:with-param name="elementName" select="'capturingDeviceType'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- ******************************************************************************************** -->
            <!-- "capturingDeviceTypeDetails" minOccurs="0" maxOccurs="1"                                     -->
            <!-- type:      meta[xs:string]                          elg[ms:langString]                       -->
            <!-- occurs:    meta[0:1]                                elg[0:unbounded]                         -->
            <!-- maxlength: meta[400]                                elg[500]                                 -->
            <!-- ******************************************************************************************** -->
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="./ms:captureInfo/ms:capturingDeviceTypeDetails" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'capturingDeviceTypeDetails'" />
            </xsl:call-template>
            <!-- ******************************************************************************************** -->
            <!-- "capturingDetails" minOccurs="0" maxOccurs="1"                                               -->
            <!-- type:      meta[xs:string]                          elg[ms:langString]                       -->
            <!-- occurs:    meta[0:1]                                elg[0:unbounded]                         -->
            <!-- maxlength: meta[400]                                elg[500]                                 -->
            <!-- ******************************************************************************************** -->
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="./ms:captureInfo/ms:capturingDetails" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'capturingDetails'" />
            </xsl:call-template>
            <!-- "capturingEnvironment" minOccurs="0" -->
            <!-- ToBeMapped -->
            <!-- "sensorTechnology" minOccurs="0" -->
            <!-- ToBeMapped -->
            <!-- "sceneIllumination" minOccurs="0" -->
            <xsl:call-template name="ElementMetaShare">
                <xsl:with-param name="el" select="./ms:captureInfo/ms:sceneIllumination" />
                <xsl:with-param name="elementName" select="'sceneIllumination'" />
            </xsl:call-template>
        </xsl:if>
        <!-- CorpusAudioPart | CorpusVideoPart | CorpusTextNumericalPart -->
        <xsl:if test="(($corpusMediaType = 'CorpusAudioPart') or
                       ($corpusMediaType = 'CorpusVideoPart') or
                       ($corpusMediaType = 'CorpusTextNumericalPart'))">
            <!-- ******************************************************************************************** -->
            <!-- "numberOfParticipants" minOccurs="0" maxOccurs="1"                                           -->
            <!-- name:      meta[numberOfPersons]                    elg[numberOfParticipants]                -->
            <!-- ******************************************************************************************** -->
            <xsl:call-template name="ElementCopy">
                <xsl:with-param name="el" select="./ms:captureInfo/ms:personSourceSetInfo/ms:numberOfPersons" />
                <xsl:with-param name="elementName" select="'numberOfParticipants'" />
            </xsl:call-template>
            <!-- ******************************************************************************************** -->
            <!-- "ageGroupOfParticipants" minOccurs="0" maxOccurs="1"                                         -->
            <!-- name:      meta[ageOfPersons]                       elg[ageGroupOfParticipants]              -->
            <!-- type:      meta[xs:string]                          elg[xs:anyURI]                           -->
            <!-- occurs:    meta[0:unbounded]                        elg[0:1]                                 -->
            <!-- maxlength: meta[30]                                 elg[restrict]                            -->
            <!-- ******************************************************************************************** -->
            <xsl:for-each select="(./ms:captureInfo/ms:personSourceSetInfo/ms:ageOfPersons)[1]">
                <xsl:call-template name="ElementMetaShare">
                    <xsl:with-param name="el" select="." />
                    <xsl:with-param name="elementName" select="'ageGroupOfParticipants'" />
                </xsl:call-template>
            </xsl:for-each>
            <!-- "ageRangeStartOfParticipants" minOccurs="0" -->
            <!-- "ageRangeEndOfParticipants" minOccurs="0" -->
            <!-- ******************************************************************************************** -->
            <!-- "sexOfParticipants" minOccurs="0" maxOccurs="1"                                             -->
            <!-- name:      meta[sexOfPersons]                       elg[sexOfParticipants]                   -->
            <!-- type:      meta[xs:string]                          elg[xs:anyURI]                           -->
            <!-- maxlength: meta[30]                                 elg[restrict]                            -->
            <!-- restrict:  meta[unknown]                            elg[unknown1]                            -->
            <!-- restrict:  meta[mixed]                              elg[]                                    -->
            <!-- ******************************************************************************************** -->
            <xsl:variable name="sexOfParticipantsMaps">
                <entry><source>mixed</source><target>unknown1</target></entry>
                <entry><source>unknown</source><target>unknown1</target></entry>
            </xsl:variable>
            <xsl:call-template name="ElementMetaShare">
                <xsl:with-param name="el" select="./ms:captureInfo/ms:personSourceSetInfo/ms:sexOfPersons" />
                <xsl:with-param name="mappings" select="$sexOfParticipantsMaps" />
                <xsl:with-param name="elementName" select="'sexOfParticipants'" />
            </xsl:call-template>
            <!-- ******************************************************************************************** -->
            <!-- "originOfParticipants" minOccurs="0" maxOccurs="1"                                           -->
            <!-- name:      meta[originOfPersons]                    elg[originOfParticipants]                -->
            <!-- type:      meta[xs:string]                          elg[xs:anyURI]                           -->
            <!-- maxlength: meta[30]                                 elg[restrict]                            -->
            <!-- restrict:  meta[mixed]                              elg[]                                    -->
            <!-- ******************************************************************************************** -->
            <!-- QUESTION What to do with mixed? -->
            <xsl:variable name="originOfParticipantsMaps">
                <entry><source>mixed</source><target>unknown</target></entry>
            </xsl:variable>
            <xsl:call-template name="ElementMetaShare">
                <xsl:with-param name="el" select="./ms:captureInfo/ms:personSourceSetInfo/ms:originOfPersons" />
                <xsl:with-param name="mappings" select="$originOfParticipantsMaps" />
                <xsl:with-param name="elementName" select="'originOfParticipants'" />
            </xsl:call-template>
            <!-- "dialectAccentOfParticipants" minOccurs="0" maxOccurs="unbounded" -->
            <!-- "geographicDistributionOfParticipants" minOccurs="0" maxOccurs="unbounded" -->
            <!-- "hearingImpairmentOfParticipants" minOccurs="0" -->
            <!-- "speakingImpairmentOfParticipants" minOccurs="0" -->
            <!-- "numberOfTrainedSpeakers" minOccurs="0" -->
            <xsl:copy-of select="$el/ms:captureInfo/ms:personSourceSetInfo/ms:numberOfTrainedSpeakers"/>
            <!-- "speechInfluence" minOccurs="0" -->
            <!-- "participant" minOccurs="0" maxOccurs="unbounded" -->
        </xsl:if>
    </xsl:template>

    <!-- template:CorpusPartEnd -->
    <!-- common elements at the end of each CorpusPart -->
    <xsl:template name="CorpusPartEnd">
        <xsl:param name="el" />
        <xsl:param name="corpusMediaType" />
        <!-- "creationMode" minOccurs="0" -->
        <xsl:call-template name="ElementMetaShare">
            <xsl:with-param name="el" select="$el/ms:creationInfo/ms:creationMode" />
            <xsl:with-param name="elementName" select="'creationMode'" />
        </xsl:call-template>
        <!-- "isCreatedBy" minOccurs="0" maxOccurs="unbounded" -->
        <!-- "hasOriginalSource" minOccurs="0" maxOccurs="unbounded" -->
        <!-- "originalSourceDescription" minOccurs="0" maxOccurs="unbounded" -->
        <xsl:for-each select="$el/ms:creationInfo/ms:originalSource">
            <xsl:call-template name="ElementCopyWithDefaultLang">
                <xsl:with-param name="el" select="./ms:targetResourceNameURI" />
                <xsl:with-param name="elementLang" select="'en'" />
                <xsl:with-param name="elementName" select="'originalSourceDescription'" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- "syntheticData" minOccurs="0" -->
        <!-- "creationDetails" minOccurs="0" maxOccurs="unbounded" -->
        <xsl:call-template name="ElementCopyWithDefaultLang">
            <xsl:with-param name="el" select="$el/ms:creationInfo/ms:creationModeDetails" />
            <xsl:with-param name="elementLang" select="'en'" />
            <xsl:with-param name="elementName" select="'creationDetails'" />
        </xsl:call-template>
        <!-- "linkToOtherMedia" minOccurs="0" maxOccurs="unbounded" -->
        <xsl:call-template name="LinkToOtherMedia">
            <xsl:with-param name="el" select="$el/ms:linkToOtherMediaInfo" />
        </xsl:call-template>
    </xsl:template>

    <!-- template:CorpusMediaPart -->
    <xsl:template name="CorpusMediaPart">
        <xsl:param name="el" />
        <xsl:param name="corpusMediaType" />
        <!-- CorpusMediaPart -->
        <CorpusMediaPart>
            <!-- corpusMediaType -->
            <xsl:element name="{$corpusMediaType}">
                <!-- common corpus start elements  -->
                <xsl:call-template name="CorpusPartStart">
                    <xsl:with-param name="el" select="$el" />
                    <xsl:with-param name="corpusMediaType" select="$corpusMediaType" />
                </xsl:call-template>
                <!-- common corpus middle elements  -->
                <xsl:call-template name="CorpusPartMid">
                    <xsl:with-param name="el" select="$el" />
                    <xsl:with-param name="corpusMediaType" select="$corpusMediaType" />
                </xsl:call-template>
                <!-- common corpus end elements  -->
                <xsl:call-template name="CorpusPartEnd">
                    <xsl:with-param name="el" select="$el" />
                    <xsl:with-param name="corpusMediaType" select="$corpusMediaType" />
                </xsl:call-template>
            </xsl:element>
        </CorpusMediaPart>
    </xsl:template>

    <!-- MetadataRecord  -->
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <!-- MetadataRecordIdentifier -->
            <MetadataRecordIdentifier ms:MetadataRecordIdentifierScheme="http://w3id.org/meta-share/meta-share/elg">value automatically assigned - leave as is</MetadataRecordIdentifier>
            <!-- metadataCreationDate -->
            <metadataCreationDate><xsl:value-of select="$metadataInfo/ms:metadataCreationDate"/></metadataCreationDate>
            <!-- metadataLastDateUpdated -->
            <metadataLastDateUpdated><xsl:value-of  select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/></metadataLastDateUpdated>
            <!-- metadataCurator -->
            <!-- QUESTION() What about tools that automatically perform some data curation tasks ? -->
            <xsl:for-each select="//ms:MetadataRecord/ms:contactPerson">
                <metadataCurator>
                    <xsl:call-template name="GenericPerson">
                        <xsl:with-param name="el" select="." />
                    </xsl:call-template>
                </metadataCurator>
            </xsl:for-each>
            <!-- compliesWith -->
            <compliesWith>http://w3id.org/meta-share/meta-share/ELG-SHARE</compliesWith>
            <!-- metadataCreator -->
            <!-- QUESTION() Max Occurs bounded to 1? -->
            <xsl:for-each select="($metadataInfo/ms:metadataCreator)[1]">
                <metadataCreator>
                    <xsl:call-template name="GenericPerson">
                        <xsl:with-param name="el" select="." />
                    </xsl:call-template>
                </metadataCreator>
            </xsl:for-each>
            <!--  sourceOfMetadataRecord  -->
            <xsl:if test="normalize-space($metadataInfo/ms:source) != ''">
                <sourceOfMetadataRecord><xsl:value-of select="$metadataInfo/ms:source"/></sourceOfMetadataRecord>
            </xsl:if>
            <!-- sourceMetadataRecord  -->
            <!-- ToBeDefined -->
            <!--  revision  -->
            <xsl:if test="normalize-space($metadataInfo/ms:revision) != ''">
                <revision xml:lang="en"><xsl:value-of select="$metadataInfo/ms:revision"/></revision>
            </xsl:if>
            <!-- DescribedEntity -->
            <DescribedEntity>
                <!-- LanguageResource  -->
                <LanguageResource>
                    <!-- entityType  -->
                    <entityType>LanguageResource</entityType>
                    <!-- physicalResource  -->
                    <!-- ToBeDefined -->
                    <!-- resourceName  -->
                    <xsl:for-each select="$identificationInfo/ms:resourceName">
                        <resourceName xml:lang="{./@xml:lang}" ><xsl:value-of select="." /></resourceName>
                    </xsl:for-each>
                    <!-- resourceShortName  -->
                    <xsl:for-each select="$identificationInfo/ms:resourceShortName">
                        <resourceShortName xml:lang="{./@xml:lang}" ><xsl:value-of select="." /></resourceShortName>
                    </xsl:for-each>
                    <!-- description  -->
                    <xsl:copy-of select="$identificationInfo/ms:description"/>
                    <!--  LRIdentifier islrn: -->
                    <xsl:if test="normalize-space($identificationInfo/ms:ISLRN) != ''">
                        <LRIdentifier ms:LRIdentifierScheme="http://w3id.org/meta-share/meta-share/islrn"><xsl:value-of select="$identificationInfo/ms:ISLRN" /></LRIdentifier>
                    </xsl:if>
                    <!--  LRIdentifier other: -->
                    <xsl:for-each select="$identificationInfo/ms:identifier">
                        <LRIdentifier ms:LRIdentifierScheme="http://w3id.org/meta-share/meta-share/other"><xsl:value-of select="." /></LRIdentifier>
                    </xsl:for-each>
                    <!-- logo  -->
                    <!-- ToBeDefined -->
                    <!-- version  -->
                    <xsl:choose>
                        <xsl:when test="normalize-space($versionInfo/ms:version) != ''">
                          <xsl:copy-of select="$versionInfo/ms:version"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <version>v1.0.0 (automatically assigned)</version>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- versionDate  -->
                    <xsl:if test="normalize-space($versionInfo/ms:lastDateUpdated) != ''">
                        <versionDate><xsl:value-of select="$versionInfo/ms:lastDateUpdated"/></versionDate>
                    </xsl:if>
                    <!-- updateFrequency -->
                    <xsl:call-template name="ElementCopyWithDefaultLang">
                        <xsl:with-param name="el" select="$versionInfo/ms:updateFrequency" />
                        <xsl:with-param name="elementLang" select="'en'" />
                        <xsl:with-param name="elementName" select="'updateFrequency'" />
                    </xsl:call-template>
                    <!-- revision -->
                    <xsl:if test="normalize-space($versionInfo/ms:revision) != ''">
                        <xsl:choose>
                            <xsl:when test="$versionInfo/ms:revision/@lang">
                                <xsl:copy-of select="$versionInfo/ms:revision"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <revision xml:lang="en"><xsl:value-of select="$versionInfo/ms:revision"/></revision>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <!-- additionalInfo | landingPage -->
                    <xsl:for-each select="$identificationInfo/ms:url">
                        <!-- additionalInfo/landingPage -->
                        <additionalInfo><landingPage><xsl:value-of select="." /></landingPage></additionalInfo>
                    </xsl:for-each>
                    <!-- additionalInfo | email -->
                    <xsl:for-each select="$contactPerson/ms:communicationInfo/ms:email">
                        <!-- additionalInfo/landingPage -->
                        <additionalInfo><email><xsl:value-of select="." /></email></additionalInfo>
                    </xsl:for-each>
                    <!-- contact -->
                    <xsl:for-each select="//ms:MetadataRecord/ms:contactPerson">
                        <contact>
                            <Person>
                                <xsl:call-template name="GenericPerson">
                                    <xsl:with-param name="el" select="." />
                                </xsl:call-template>
                            </Person>
                        </contact>
                    </xsl:for-each>
                    <!-- mailingListName -->
                    <!-- NoMapAvalaible -->
                    <!-- discussionURL -->
                    <!-- NoMapAvalaible -->
                    <!-- citation -->
                    <xsl:for-each select="$resourceDocumentationInfo/ms:citation/ms:documentUnstructured">
                        <citationText xml:lang="und"><xsl:value-of select="." /></citationText>
                    </xsl:for-each>
                    <!-- iprHolder -->
                    <!-- NotToBeMapped -->
                    <!-- keyword -->
                    <keyword xml:lang="en"><xsl:value-of select="lower-case($resourceType)" /></keyword>
                    <!-- domain -->
                    <xsl:for-each select="//ms:domainInfo">
                        <domain>
                            <xsl:call-template name="ElementCopyWithDefaultLang">
                                <xsl:with-param name="el" select="./ms:domain" />
                                <xsl:with-param name="elementLang" select="'en'" />
                                <xsl:with-param name="elementName" select="'categoryLabel'" />
                            </xsl:call-template>
                        </domain>
                    </xsl:for-each>
                    <!-- subject -->
                    <!-- ToBeDefined : audioClassificationInfo.subject_topic -->
                    <!-- resourceProvider -->
                    <!-- NoMapAvalaible -->
                    <!-- publicationDate -->
                    <!-- NoMapAvalaible -->
                    <!-- ms:resourceCreator -->
                    <xsl:call-template name="Actor">
                        <xsl:with-param name="el" select="$resourceCreationInfo/ms:resourceCreator" />
                        <xsl:with-param name="actorElement" select="'resourceCreator'" />
                    </xsl:call-template>
                    <!-- creationStartDate -->
                    <xsl:copy-of select="$resourceCreationInfo/ms:creationStartDate"/>
                    <!-- creationEndDate -->
                    <xsl:copy-of select="$resourceCreationInfo/ms:creationEndDate"/>
                    <!-- fundingProject -->
                    <xsl:for-each select="$resourceCreationInfo/ms:fundingProject">
                        <fundingProject>
                            <xsl:call-template name="GenericProject">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </fundingProject>
                    </xsl:for-each>
                    <!-- intendedApplication -->
                    <xsl:for-each select="$usageInfo/ms:foreseenUseInfo">
                        <xsl:for-each select="./ms:useNLPSpecific">
                            <intendedApplication>
                                <xsl:call-template name="LTClass">
                                    <xsl:with-param name="el" select="." />
                                </xsl:call-template>
                            </intendedApplication>
                        </xsl:for-each>
                    </xsl:for-each>
                    <!-- actualUse  -->
                    <xsl:for-each select="$usageInfo/ms:actualUseInfo">
                        <actualUse>
                            <!-- usedInApplication -->
                            <xsl:for-each select="./ms:useNLPSpecific">
                                <usedInApplication>
                                        <xsl:call-template name="LTClass">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                </usedInApplication>
                            </xsl:for-each>
                            <!-- usageProject -->
                            <xsl:for-each select="./ms:usageProject">
                                <usageProject>
                                    <xsl:call-template name="GenericProject">
                                        <xsl:with-param name="el" select="." />
                                    </xsl:call-template>
                                </usageProject>
                            </xsl:for-each>
                            <!-- usageReport -->
                            <xsl:for-each select="./ms:usageReport/ms:documentInfo">
                                <usageReport>
                                    <xsl:call-template name="GenericDocument">
                                        <xsl:with-param name="el" select="." />
                                    </xsl:call-template>
                                </usageReport>
                            </xsl:for-each>
                            <!-- actualUseDetails -->
                            <xsl:call-template name="ElementCopyWithDefaultLang">
                                <xsl:with-param name="el" select="./ms:actualUseDetails" />
                                <xsl:with-param name="elementLang" select="'en'" />
                                <xsl:with-param name="elementName" select="'actualUseDetails'" />
                            </xsl:call-template>
                            <actualUseDetails xml:lang="en"><xsl:value-of select="./ms:actualUse"/></actualUseDetails>
                        </actualUse>
                    </xsl:for-each>
                    <!-- validated -->
                    <xsl:if test="normalize-space(./ms:validationInfo) != ''">
                        <validated>
                             <!-- QUESTION() can this be equal to and($validationInfo/ms:validated) ? -->
                             <!-- snippet from @see https://stackoverflow.com/a/14867414/2042871 -->
                            <xsl:value-of select="not($validationInfo/ms:validated[. = 'false'])" />
                        </validated>
                    <!-- validation -->
                        <xsl:for-each select="$validationInfo">
                            <validation>
                                <!-- validationType -->
                                <xsl:if test="normalize-space(./ms:validationType) != ''">
                                    <validationType>
                                        <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', ./ms:validationType)" />
                                    </validationType>
                                </xsl:if>
                                <!-- validationMode -->
                                <xsl:if test="normalize-space(./ms:validationMode) != ''">
                                    <validationMode>
                                        <xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', ./ms:validationMode)" />
                                    </validationMode>
                                </xsl:if>
                                <!-- validationDetails | validated -->
                                <validationDetails xml:lang="en">
                                    <xsl:value-of select="if (./ms:validated = 'true') then 'validated' else 'not validated'"/>
                                </validationDetails>
                                <!-- validationDetails | validationModeDetails -->
                                <xsl:call-template name="ElementCopyWithDefaultLang">
                                    <xsl:with-param name="el" select="./ms:validationModeDetails" />
                                    <xsl:with-param name="elementLang" select="'en'" />
                                    <xsl:with-param name="elementName" select="'validationDetails'" />
                                </xsl:call-template>
                                <!-- validationDetails | validationExtentDetails -->
                                <xsl:call-template name="ElementCopyWithDefaultLang">
                                    <xsl:with-param name="el" select="./ms:validationExtentDetails" />
                                    <xsl:with-param name="elementLang" select="'en'" />
                                    <xsl:with-param name="elementName" select="'validationDetails'" />
                                </xsl:call-template>
                                <!-- validationExtent -->
                                <xsl:if test="normalize-space(./ms:validationExtent) != ''">
                                    <validationExtent><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', ./ms:validationExtent)" /></validationExtent>
                                </xsl:if>
                                <!-- validator | Person -->
                                <xsl:for-each select="./ms:validator/ms:personInfo">
                                    <validator>
                                        <Person>
                                            <xsl:call-template name="GenericPerson">
                                                <xsl:with-param name="el" select="." />
                                            </xsl:call-template>
                                        </Person>
                                    </validator>
                                </xsl:for-each>
                                <!-- validator | Organization -->
                                <xsl:for-each select="./ms:validator/ms:organizationInfo">
                                    <validator>
                                        <Organization>
                                            <xsl:call-template name="GenericOrganization">
                                                <xsl:with-param name="el" select="." />
                                            </xsl:call-template>
                                        </Organization>
                                    </validator>
                                </xsl:for-each>
                            </validation>
                        </xsl:for-each>
                    </xsl:if>
                    <!-- isDocumentedBy -->
                    <xsl:for-each select="$resourceDocumentationInfo/ms:documentation/ms:documentInfo">
                        <isDocumentedBy>
                            <xsl:call-template name="GenericDocument">
                                <xsl:with-param name="el" select="." />
                            </xsl:call-template>
                        </isDocumentedBy>
                    </xsl:for-each>
                    <!-- isDescribedBy -->
                    <!-- NoMapAvalaible -->
                    <!-- isCitedBy -->
                    <!-- NoMapAvalaible -->
                    <!-- isReviewedBy -->
                    <!-- NoMapAvalaible -->
                    <!-- isPartOf -->
                    <!-- NoMapAvalaible -->
                    <!-- isPartWith -->
                    <!-- NoMapAvalaible -->
                    <!-- isSimilarTo -->
                    <!-- NoMapAvalaible -->
                    <!-- isExactMatchWith -->
                    <!-- NoMapAvalaible -->
                    <!-- hasMetadata -->
                    <!-- NoMapAvalaible -->
                    <!-- isArchivedBy -->
                    <!-- NoMapAvalaible -->
                    <!-- isContinuationOf -->
                    <!-- NoMapAvalaible -->
                    <!-- replaces -->
                    <!-- NoMapAvalaible -->
                    <!-- isVersionOf -->
                    <!-- NoMapAvalaible -->
                    <!-- relation -->
                    <xsl:for-each select="$relationInfo">
                        <xsl:if test="normalize-space(./ms:relatedResource/ms:targetResourceNameURI) != ''">
                            <relation>
                                <!-- relationType -->
                                <xsl:for-each select="./ms:relationType">
                                    <xsl:call-template name="ElementCopyWithDefaultLang">
                                        <xsl:with-param name="el" select="." />
                                        <xsl:with-param name="elementLang" select="'en'" />
                                        <xsl:with-param name="elementName" select="'relationType'" />
                                    </xsl:call-template>
                                </xsl:for-each>
                                <!-- relatedLR -->
                                <relatedLR>
                                    <!-- resourceName -->
                                    <xsl:call-template name="ElementCopyWithDefaultLang">
                                        <xsl:with-param name="el" select="./ms:relatedResource/ms:targetResourceNameURI" />
                                        <xsl:with-param name="elementLang" select="'en'" />
                                        <xsl:with-param name="elementName" select="'resourceName'" />
                                    </xsl:call-template>
                                </relatedLR>
                            </relation>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- LRSubclass -->
                    <LRSubclass>
                        <!-- Corpus  -->
                        <xsl:if test="$resourceType = 'corpus' ">
                            <Corpus>
                                <!-- lrType  -->
                                <lrType>Corpus</lrType>
                                <!-- corpusSubclass : QUESTION() how to deduce this information ? -->
                                <corpusSubclass>
                                    <xsl:choose>
                                        <xsl:when test=
                      "((count($corpusInfo/ms:corpusMediaType/ms:corpusTextInfo/ms:annotationInfo)  != 0) or
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusAudioInfo/ms:annotationInfo) != 0) or
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusVideoInfo/ms:annotationInfo) != 0) or
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusImageInfo/ms:annotationInfo) != 0) or
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusTextNumericalInfo/ms:annotationInfo) != 0))">
                                            <xsl:value-of select="'http://w3id.org/meta-share/meta-share/annotatedCorpus'" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'http://w3id.org/meta-share/meta-share/rawCorpus'" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </corpusSubclass>
                                <!-- corpusMediaType -->
                                <xsl:for-each select="$corpusInfo/ms:corpusMediaType">
                                    <!-- CorpusMediaPart | CorpusTextPart -->
                                    <xsl:for-each select="./ms:corpusTextInfo">
                                        <xsl:call-template name="CorpusMediaPart">
                                            <xsl:with-param name="el" select="." />
                                            <xsl:with-param name="corpusMediaType" select="'CorpusTextPart'" />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusAudioPart -->
                                    <xsl:for-each select="./ms:corpusAudioInfo">
                                        <xsl:call-template name="CorpusMediaPart">
                                            <xsl:with-param name="el" select="." />
                                            <xsl:with-param name="corpusMediaType" select="'CorpusAudioPart'" />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusVideoPart -->
                                    <xsl:for-each select="./ms:corpusVideoInfo">
                                        <xsl:call-template name="CorpusMediaPart">
                                            <xsl:with-param name="el" select="." />
                                            <xsl:with-param name="corpusMediaType" select="'CorpusVideoPart'" />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusImagePart -->
                                    <xsl:for-each select="./ms:corpusImageInfo">
                                        <xsl:call-template name="CorpusMediaPart">
                                            <xsl:with-param name="el" select="." />
                                            <xsl:with-param name="corpusMediaType" select="'CorpusImagePart'" />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusTextNumericalPart -->
                                    <xsl:for-each select="./ms:corpusTextNumericalInfo">
                                        <xsl:call-template name="CorpusMediaPart">
                                            <xsl:with-param name="el" select="." />
                                            <xsl:with-param name="corpusMediaType" select="'CorpusTextNumericalPart'" />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | corpusTextNgramInfo -->
                                    <!-- QUESTION() Where to map corpusTextNgramInfo? -->
                                </xsl:for-each>
                                <!-- DatasetDistribution -->
                                <xsl:call-template name="DatasetDistribution"/>
                                <!-- personalDataIncluded -->
                                <!-- ToBeDefined : QUESTION() could be false by default? -->
                                <personalDataIncluded>false</personalDataIncluded>
                                <!-- personalDataDetails -->
                                <!-- ToBeDefined -->
                                <!-- sensitiveDataIncluded -->
                                <!-- ToBeDefined : QUESTION() could be false by default? -->
                                <sensitiveDataIncluded>false</sensitiveDataIncluded>
                                <!-- ToBeDefined -->
                                <!-- sensitiveDataDetails -->
                                <!-- anonymized -->
                                <!-- anonymizationDetails -->
                                <!-- isAnalysedBy -->
                                <!-- isEditedBy -->
                                <!-- isElicitedBy -->
                                <!-- isAnnotatedVersionOf -->
                                <!-- isAlignedVersionOf -->
                                <!-- isConvertedVersionOf -->
                                <!-- timeCoverage -->
                                <xsl:for-each select="$corpusInfo/ms:corpusMediaType//ms:timeCoverageInfo">
                                    <xsl:call-template name="ElementCopyWithDefaultLang">
                                        <xsl:with-param name="el" select="./ms:timeCoverage" />
                                        <xsl:with-param name="elementLang" select="'en'" />
                                        <xsl:with-param name="elementName" select="'timeCoverage'" />
                                    </xsl:call-template>
                                </xsl:for-each>
                                <!-- geographicCoverage -->
                                <!-- register -->
                                <!-- userQuery -->
                                <!-- annotation -->
                                <xsl:for-each select="$corpusInfo/ms:corpusMediaType">
                                    <!-- annotation | corpusTextInfo -->
                                    <xsl:for-each select="./ms:corpusTextInfo">
                                        <xsl:call-template name="annotation">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- annotation | corpusAudioInfo -->
                                    <xsl:for-each select="./ms:corpusAudioInfo">
                                        <xsl:call-template name="annotation">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- annotation | corpusVideoInfo -->
                                    <xsl:for-each select="./ms:corpusVideoInfo">
                                        <xsl:call-template name="annotation">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- annotation | corpusImageInfo -->
                                    <xsl:for-each select="./ms:corpusImageInfo">
                                        <xsl:call-template name="annotation">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- annotation | corpusTextNumericalInfo -->
                                    <xsl:for-each select="./ms:corpusTextNumericalInfo">
                                        <xsl:call-template name="annotation">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- annotation | corpusTextNgramInfo -->
                                    <!-- ToBeDefined -->
                                </xsl:for-each>
                                <!-- append at least one mandatory annotation -->
                                <xsl:if test=
                        "((count($corpusInfo/ms:corpusMediaType/ms:corpusTextInfo/ms:annotationInfo) = 0) and
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusAudioInfo/ms:annotationInfo)  = 0) and
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusVideoInfo/ms:annotationInfo)  = 0) and
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusImageInfo/ms:annotationInfo)  = 0) and
                        (count($corpusInfo/ms:corpusMediaType/ms:corpusTextNumericalInfo/ms:annotationInfo) = 0))">
                                    <annotation>
                                        <!-- QUESTION() What could the best default value for a non-annotated LR?-->
                                        <annotationType>http://w3id.org/meta-share/omtd-share/DomainSpecificAnnotationType</annotationType>
                                    </annotation>
                                </xsl:if>
                                <!-- hasSubset -->
                                <!-- <xsl:for-each select="$corpusInfo/ms:corpusMediaType"> -->
                                    <!-- hasSubset | corpusTextInfo -->
                                    <!-- hasSubset | corpusAudioInfo -->
                                    <!-- hasSubset | corpusVideoInfo -->
                                    <!-- hasSubset | corpusImageInfo -->
                                    <!-- hasSubset | corpusTextNumericalInfo -->
                                <!-- </xsl:for-each> -->
                            </Corpus>
                        </xsl:if>
                        <!-- lexicalConceptualResource  -->
                        <xsl:if test="$resourceType = 'lexicalConceptualResource' ">
                            <LexicalConceptualResource>
                                <!-- lrType  -->
                                <lrType>LexicalConceptualResource</lrType>
                                <!-- lcrSubclass  -->
                                <xsl:call-template name="LcrSubclass">
                                    <xsl:with-param name="el" select="$lexicalConceptualResourceInfo/ms:lexicalConceptualResourceType" />
                                </xsl:call-template>
                                <!-- ms:encodingLevel -->
                                <xsl:call-template name="EncodingLevel">
                                    <xsl:with-param name="el" select="$lexicalConceptualResourceInfo/ms:lexicalConceptualResourceEncodingInfo" />
                                    <xsl:with-param name="default" select="'http://w3id.org/meta-share/meta-share/morphology'" />
                                </xsl:call-template>
                                <!-- LexicalConceptualResourceMediaPart  -->
                                <LexicalConceptualResourceMediaPart>
                                <!-- LexicalConceptualResourceTextPart  -->
                                <xsl:if test="$mediaTypeName = 'lexicalConceptualResourceTextInfo' ">
                                    <LexicalConceptualResourceTextPart>
                                        <!-- lcrMediaType  -->
                                        <lcrMediaType>LexicalConceptualResourceTextPart</lcrMediaType>
                                        <!-- mediaType  -->
                                        <mediaType>http://w3id.org/meta-share/meta-share/<xsl:value-of select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:mediaType" /></mediaType>
                                        <!-- lingualityType  -->
                                        <xsl:call-template name="ElementMetaShareDefault">
                                            <xsl:with-param name="el" select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:lingualityInfo/ms:lingualityType" />
                                            <xsl:with-param name="default" select="'monolingual'" />
                                            <xsl:with-param name="elementName" select="'lingualityType'" />
                                        </xsl:call-template>
                                        <!-- language -->
                                        <xsl:for-each select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:languageInfo">
                                            <language>
                                                <xsl:call-template name="Language">
                                                    <xsl:with-param name="el" select="." />
                                                </xsl:call-template>
                                            </language>
                                        </xsl:for-each>
                                        <!-- metalanguage -->
                                        <metalanguage><languageTag>und</languageTag></metalanguage>
                                    </LexicalConceptualResourceTextPart>
                                </xsl:if>
                                </LexicalConceptualResourceMediaPart>
                                <!-- ms:DatasetDistribution -->
                                <xsl:call-template name="DatasetDistribution"/>
                                <!-- ms:personalDataIncluded -->
                                <personalDataIncluded>false</personalDataIncluded>
                                <!-- ms:sensitiveDataIncluded -->
                                <sensitiveDataIncluded>false</sensitiveDataIncluded>
                                <!-- hasSubset -->
                                <!--  $mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo -->
                                <!-- <xsl:for-each select="$corpusInfo/ms:corpusMediaType"> -->
                                    <!-- hasSubset | lexicalConceptualResourceTextInfo -->
                                    <!-- hasSubset | lexicalConceptualResourceAudioInfo -->
                                    <!-- hasSubset | lexicalConceptualResourceVideoInfo -->
                                    <!-- hasSubset | lexicalConceptualResourceImageInfo -->
                                <!-- </xsl:for-each> -->
                            </LexicalConceptualResource>
                        </xsl:if>
                    </LRSubclass>
                </LanguageResource>
            </DescribedEntity>
        </xsl:copy>
        <!-- append a newline -->
        <xsl:variable name="newline" select="'&#10;'"/>
        <xsl:value-of select="$newline" disable-output-escaping="no"/>
    </xsl:template>
</xsl:stylesheet>
