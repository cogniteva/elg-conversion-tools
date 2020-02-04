<!-- rules to transform ELRA XML files into ELG XML files -->
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

    <!-- var:LanguageResourceEntityType  -->
    <xsl:variable name="LanguageResourceEntityType">LanguageResource</xsl:variable>

    <!-- var:LicenseTermsEntityType  -->
    <xsl:variable name="LicenseTermsEntityType">LicenceTerms</xsl:variable>

    <!-- var:LexicalConceptualResource  -->
    <xsl:variable name="LexicalConceptualResource">LexicalConceptualResource</xsl:variable>

    <!-- var:identificationInfo  -->
    <xsl:variable name="identificationInfo">
       <xsl:copy-of select="//ms:DescribedEntity/ms:identificationInfo/*"/>
    </xsl:variable>

    <!-- var:distributionInfo  -->
    <xsl:variable name="distributionInfo">
       <xsl:copy-of select="//ms:DescribedEntity/ms:distributionInfo/*"/>
    </xsl:variable>

    <!-- var:lexicalConceptualResourceInfo  -->
    <xsl:variable name="lexicalConceptualResourceInfo">
       <xsl:copy-of select="//ms:DescribedEntity/ms:resourceComponentType/ms:lexicalConceptualResourceInfo/*"/>
    </xsl:variable>

    <!-- var:resourceType  -->
    <xsl:variable name="resourceType">
       <xsl:copy-of select="$lexicalConceptualResourceInfo/ms:resourceType"/>
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
    
    <!-- LanguageResource  -->
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <!-- LanguageResource  -->
            <LanguageResource>
                <!-- entityType  -->
                <entityType><xsl:value-of select="$LanguageResourceEntityType" /></entityType>
                <!-- resourceName  -->
                <xsl:copy-of select="$identificationInfo/ms:resourceName"/>
                <!-- description  -->
                <xsl:copy-of select="$identificationInfo/ms:description"/>
                <!--  LRIdentifier islrn: -->
                <LRIdentifier>islrn:<xsl:value-of select="$identificationInfo/ms:ISLRN" /></LRIdentifier>
                <!--  LRIdentifier elra: -->
                <LRIdentifier>elra:<xsl:value-of select="$identificationInfo/ms:identifier" /></LRIdentifier>
                <!--  LRIdentifier elra: -->
                <LRIdentifier>metashare:<xsl:value-of select="$identificationInfo/ms:metaShareId" /></LRIdentifier>
                <!-- additionalInfo/landingPage -->
                <xsl:for-each select="$identificationInfo/ms:url">
                    <additionalInfo><landingPage><xsl:value-of select="." /></landingPage></additionalInfo>
                </xsl:for-each>

                <!-- LRSubclass  -->
                <LRSubclass>
                    <!-- lexicalConceptualResource  -->
                    <xsl:if test="$resourceType = 'lexicalConceptualResource' ">
                        <lexicalConceptualResource>
                            <!-- lrType  -->
                            <lrType><xsl:value-of select="$LexicalConceptualResource" /></lrType>
                            <!-- lcrSubclass  -->
                            <lcrSubclass><xsl:value-of select="$lexicalConceptualResourceInfo/ms:lexicalConceptualResourceType" /></lcrSubclass>
                            <!-- ms:encodingLevel -->
                            <encodingLevel>ToBeDefined</encodingLevel>
                            <!-- LexicalConceptualResourceMediaPart  -->
                            <LexicalConceptualResourceMediaPart>
                            <!-- LexicalConceptualResourceTextPart  -->
                            <xsl:if test="$mediaTypeName = 'lexicalConceptualResourceTextInfo' ">
                                <LexicalConceptualResourceTextPart>
                                    <!-- lcrMediaType  -->
                                    <lcrMediaType>LexicalConceptualResourceTextPart</lcrMediaType>
                                    <!-- mediaType  -->
                                    <xsl:copy-of select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:mediaType" />
                                    <!-- lingualityType  -->
                                    <xsl:copy-of select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:lingualityInfo/ms:lingualityType" />
                                    <!-- language -->
                                    <xsl:for-each select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:languageInfo">
                                        <language>
                                            <!-- languageTag -->
                                            <languageTag><xsl:value-of select="./ms:languageId" /></languageTag>
                                        </language>
                                        <metalanguage>
                                            <!-- languageTag -->
                                            <languageTag>ToBeDefined</languageTag>
                                        </metalanguage>
                                    </xsl:for-each>
                                </LexicalConceptualResourceTextPart>
                            </xsl:if>
                            </LexicalConceptualResourceMediaPart>
                            <!-- hasSubset -->
                            <hasSubset>
                                <!-- sizePerLanguage -->
                                <xsl:for-each select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:sizeInfo">
                                    <sizePerLanguage>
                                        <amount><xsl:value-of select="./ms:size" /></amount>
                                        <sizeUnit><xsl:value-of select="./ms:sizeUnit" /></sizeUnit>
                                    </sizePerLanguage>
                                </xsl:for-each>
                            </hasSubset>
                        </lexicalConceptualResource>
                    </xsl:if>
                </LRSubclass>
            </LanguageResource>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
