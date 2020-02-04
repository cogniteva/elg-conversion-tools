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
       <xsl:copy-of select="//ms:MetadataRecord/ms:identificationInfo/*"/>
    </xsl:variable>

    <!-- var:distributionInfo  -->
    <xsl:variable name="distributionInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:distributionInfo/*"/>
    </xsl:variable>

    <!-- var:contactPerson  -->
    <xsl:variable name="contactPerson">
       <xsl:copy-of select="//ms:MetadataRecord/ms:contactPerson/*"/>
    </xsl:variable>

    <!-- var:versionInfo  -->
    <xsl:variable name="versionInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:versionInfo/*"/>
    </xsl:variable>

    <!-- var:lexicalConceptualResourceInfo  -->
    <xsl:variable name="lexicalConceptualResourceInfo">
       <xsl:copy-of select="//ms:MetadataRecord/ms:resourceComponentType/ms:lexicalConceptualResourceInfo/*"/>
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
    
    <!-- MetadataRecord  -->
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <!-- MetadataRecordIdentifier -->
            <MetadataRecordIdentifier  ms:MetadataRecordIdentifierScheme="http://purl.org/spar/datacite/handle">ToBeDefined</MetadataRecordIdentifier>
            <!-- metadataCreationDate -->
            <metadataCreationDate>2020-02-04</metadataCreationDate>
            <!-- metadataLastDateUpdated -->
            <metadataLastDateUpdated>2020-02-04</metadataLastDateUpdated>
            <!-- metadataCurator -->
            <xsl:for-each select="$contactPerson">
                <metadataCurator>
                    <actorType>Person</actorType>
                    <xsl:copy-of select="./ms:surname" />
                    <xsl:copy-of select="./ms:givenName" />
                    <email><xsl:value-of select="./ms:communicationInfo/ms:email" /></email>
                </metadataCurator>
            </xsl:for-each>
            <!-- compliesWith -->
            <compliesWith>http://w3id.org/meta-share/meta-share/ELG-SHARE</compliesWith>
            <!-- DescribedEntity -->
            <DescribedEntity>
                <!-- LanguageResource  -->
                <LanguageResource>
                    <!-- entityType  -->
                    <entityType><xsl:value-of select="$LanguageResourceEntityType" /></entityType>
                    <!-- resourceName  -->
                    <xsl:copy-of select="$identificationInfo/ms:resourceName"/>
                    <!-- description  -->
                    <xsl:copy-of select="$identificationInfo/ms:description"/>
                    <!--  LRIdentifier islrn: -->
                    <LRIdentifier ms:LRIdentifierScheme="http://purl.org/spar/datacite/handle">islrn:<xsl:value-of select="$identificationInfo/ms:ISLRN" /></LRIdentifier>
                    <!--  LRIdentifier elra: -->
                    <LRIdentifier ms:LRIdentifierScheme="http://purl.org/spar/datacite/handle">elra:<xsl:value-of select="$identificationInfo/ms:identifier" /></LRIdentifier>
                    <!--  LRIdentifier metashare: -->
                    <LRIdentifier ms:LRIdentifierScheme="http://purl.org/spar/datacite/handle">metashare:<xsl:value-of select="$identificationInfo/ms:metaShareId" /></LRIdentifier>
                    <!-- version  -->
                    <version><xsl:value-of select="$versionInfo/ms:version"/></version>
                    <!-- additionalInfo/landingPage -->
                    <xsl:for-each select="$identificationInfo/ms:url">
                        <additionalInfo><landingPage><xsl:value-of select="." /></landingPage></additionalInfo>
                    </xsl:for-each>
                    <!-- keyword -->
                    <keyword xml:lang="en-US">ToBeDefined-00</keyword>
                    <keyword xml:lang="en-US">ToBeDefined-01</keyword>
                    <keyword xml:lang="en-US">ToBeDefined-nn</keyword>
                    <!-- LRSubclass  -->
                    <LRSubclass>
                        <!-- lexicalConceptualResource  -->
                        <xsl:if test="$resourceType = 'lexicalConceptualResource' ">
                            <LexicalConceptualResource>
                                <!-- lrType  -->
                                <lrType><xsl:value-of select="$LexicalConceptualResource" /></lrType>
                                <!-- lcrSubclass  -->
                                <lcrSubclass>http://w3id.org/meta-share/meta-share/<xsl:value-of select="$lexicalConceptualResourceInfo/ms:lexicalConceptualResourceType" /></lcrSubclass>
                                <!-- ms:encodingLevel -->
                                <!-- ToBeDefined -->
                                <encodingLevel>http://w3id.org/meta-share/meta-share/morphology</encodingLevel>
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
                                        <lingualityType>http://w3id.org/meta-share/meta-share/<xsl:value-of select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:lingualityInfo/ms:lingualityType" /></lingualityType>
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
                                <!-- ms:DatasetDistribution -->
                                <DatasetDistribution>
                                </DatasetDistribution>
                                <!-- ms:personalDataIncluded -->
                                <personalDataIncluded>false</personalDataIncluded>
                                <!-- ms:sensitiveDataIncluded -->
                                <sensitiveDataIncluded>false</sensitiveDataIncluded>
                                <!-- hasSubset -->
                                <hasSubset>
                                    <!-- sizePerLanguage -->
                                    <xsl:for-each select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:sizeInfo">
                                        <sizePerLanguage>
                                            <amount><xsl:value-of select="./ms:size" /></amount>
                                            <sizeUnit>http://w3id.org/meta-share/meta-share/<xsl:value-of select="./ms:sizeUnit" /></sizeUnit>
                                        </sizePerLanguage>
                                    </xsl:for-each>
                                </hasSubset>
                            </LexicalConceptualResource>
                        </xsl:if>
                    </LRSubclass>
                </LanguageResource>
            </DescribedEntity>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
