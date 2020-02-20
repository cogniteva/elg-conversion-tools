<!-- rules to transform ELRA XML files into ELG XML files -->
<!-- Copyright (c) 2020 Cogniteva -->
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
            <xsl:for-each select="$contactPerson">
                <metadataCurator>
                    <actorType>Person</actorType>
                    <xsl:copy-of select="./ms:surname" />
                    <xsl:copy-of select="./ms:givenName" />
                    <xsl:copy-of select="./ms:communicationInfo/ms:email" />
                </metadataCurator>
            </xsl:for-each>
            <!-- compliesWith -->
            <compliesWith>http://w3id.org/meta-share/meta-share/ELG-SHARE</compliesWith>
            <!-- metadataCreator -->
            <xsl:if test="$metadataCreator != ''">
                <metadataCreator>
                    <actorType>Person</actorType>
                    <xsl:copy-of select="$metadataCreator/ms:surname" />
                    <xsl:copy-of select="$metadataCreator/ms:givenName" />
                    <xsl:copy-of select="$metadataCreator/ms:communicationInfo/ms:email" />
                </metadataCreator>
            </xsl:if>
            <!--  sourceOfMetadataRecord  -->
            <xsl:if test="$metadataInfo/ms:source != ''">
                <sourceOfMetadataRecord><xsl:value-of select="$metadataInfo/ms:source"/></sourceOfMetadataRecord>
            </xsl:if>
            <!-- sourceMetadataRecord  -->
            <!-- ToBeDefined -->
            <!--  revision  -->
            <xsl:if test="$metadataInfo/ms:revision != ''">
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
                    <xsl:copy-of select="$identificationInfo/ms:resourceShortName"/>
                    <!-- description  -->
                    <xsl:copy-of select="$identificationInfo/ms:description"/>
                    <!--  LRIdentifier islrn: -->
                    <LRIdentifier ms:LRIdentifierScheme="http://w3id.org/meta-share/meta-share/islrn"><xsl:value-of select="$identificationInfo/ms:ISLRN" /></LRIdentifier>
                    <!--  LRIdentifier elra: -->
                    <LRIdentifier ms:LRIdentifierScheme="http://w3id.org/meta-share/meta-share/other"><xsl:value-of select="$identificationInfo/ms:identifier" /></LRIdentifier>
                    <!-- logo  -->
                    <!-- ToBeDefined -->
                    <!-- version  -->
                    <xsl:copy-of select="$versionInfo/ms:version"/>
                    <!-- versionDate  -->
                    <versionDate><xsl:value-of select="$versionInfo/ms:lastDateUpdated"/></versionDate>
                    <!-- updateFrequency -->
                    <xsl:copy-of select="$versionInfo/ms:updateFrequency"/>
                    <!-- revision -->
                    <xsl:copy-of select="$versionInfo/ms:revision"/>
                    <!-- additionalInfo -->
                    <xsl:for-each select="$identificationInfo/ms:url">
                        <!-- additionalInfo/landingPage -->
                        <additionalInfo><landingPage><xsl:value-of select="." /></landingPage></additionalInfo>
                    </xsl:for-each>
                    <!-- contact -->
                    <!-- ToBeDefined -->
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
                    <!-- ToBeDefined | corpusAudioInfo.domainInfo.domain | .lexicalConceptualResourceAudioInfo.domainInfo.domain -->
                    <!-- subject -->
                    <!-- ToBeDefined | audioClassificationInfo.subject_topic -->
                    <!-- resourceProvider -->
                    <!-- NoMapAvalaible -->
                    <!-- publicationDate -->
                    <!-- NoMapAvalaible -->
                    <!-- resourceCreator | Person -->
                    <xsl:for-each select="$resourceCreationInfo/ms:resourceCreator/ms:personInfo">
                        <resourceCreator>
                            <Person>
                                <actorType>Person</actorType>
                                <xsl:copy-of select="./ms:surname" />
                                <xsl:copy-of select="./ms:givenName" />
                                <xsl:copy-of select="./ms:communicationInfo/ms:email" />
                            </Person>
                        </resourceCreator>
                    </xsl:for-each>
                    <!-- resourceCreator | Organization -->
                    <xsl:for-each select="$resourceCreationInfo/ms:resourceCreator/ms:organizationInfo">
                        <resourceCreator>
                            <Organization>
                                <actorType>Organization</actorType>
                                <xsl:copy-of select="./ms:organizationName" />
                                <xsl:for-each select="./ms:communicationInfo/ms:url">
                                    <website><xsl:value-of select="." /></website>
                                </xsl:for-each>
                            </Organization>
                        </resourceCreator>
                    </xsl:for-each>
                    <!-- creationStartDate  -->
                    <xsl:copy-of select="$resourceCreationInfo/ms:creationStartDate"/>
                    <!-- creationEndDate  -->
                    <xsl:copy-of select="$resourceCreationInfo/ms:creationEndDate"/>
                    <!-- LRSubclass  -->
                    <LRSubclass>
                        <!-- lexicalConceptualResource  -->
                        <xsl:if test="$resourceType = 'lexicalConceptualResource' ">
                            <LexicalConceptualResource>
                                <!-- lrType  -->
                                <lrType>LexicalConceptualResource</lrType>
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
                                        </xsl:for-each>
                                        <!-- metalanguage -->
                                        <metalanguage><languageTag>und</languageTag></metalanguage>
                                    </LexicalConceptualResourceTextPart>
                                </xsl:if>
                                </LexicalConceptualResourceMediaPart>
                                <!-- ms:DatasetDistribution -->
                                <xsl:for-each select="$distributionInfo/*">
                                    <DatasetDistribution>
                                        <!-- ms:DatasetDistributionForm -->
                                        <DatasetDistributionForm>http://w3id.org/meta-share/meta-share/<xsl:value-of select="./ms:distributionAccessMedium" /></DatasetDistributionForm>
                                        <!-- licenceTerms -->
                                        <xsl:for-each select="./ms:licenceInfo">
                                            <licenceTerms>
                                                <!-- licenceTermsName -->
                                                <licenceTermsName xml:lang="en-US"><xsl:value-of select="./ms:licence" /></licenceTermsName>
                                                <!-- licenceTermsURL -->
                                                <licenceTermsURL>http://elda.org/ToBeDefined/<xsl:value-of select="translate(lower-case(./ms:licence),'_','-')" />#<xsl:value-of select="lower-case(./ms:restrictionsOfUse)" /></licenceTermsURL>
                                                <!-- conditionOfUse:academicUser -->
<!--
                                                <xsl:if test="../ms:userNature = 'academic' ">
                                                    <conditionOfUse>http://w3id.org/meta-share/meta-share/academicUser</conditionOfUse>
                                                </xsl:if>
-->
                                                <!-- conditionOfUse:commercial -->
<!--
                                                <xsl:if test="../ms:userNature = 'commercial' ">
                                                    <conditionOfUse>http://w3id.org/meta-share/meta-share/commercialUser</conditionOfUse>
                                                </xsl:if>
-->
                                            </licenceTerms>
                                        </xsl:for-each>
                                        <!-- cost -->
                                        <cost>
                                            <!-- ms:amount -->
                                            <amount><xsl:value-of select="./ms:fee" /></amount>
                                            <!-- ms:currency -->
                                            <currency>http://w3id.org/meta-share/meta-share/euro</currency>
                                        </cost>
                                        <!-- membershipInstitution -->
                                        <membershipInstitution>http://w3id.org/meta-share/meta-share/<xsl:value-of select="./ms:membershipInfo/ms:membershipInstitution" /></membershipInstitution>
                                        <!-- ms:availabilityStartDate -->
                                        <xsl:copy-of select="./ms:availabilityStartDate" />
                                        <!-- distributionRightsHolder/Organization -->
                                        <xsl:if test="name(./ms:distributionRightsHolder/*[1]) = 'organizationInfo' ">
                                            <!-- distributionRightsHolder -->
                                            <distributionRightsHolder>
                                                <!-- Organization -->
                                                <Organization>
                                                    <actorType>Organization</actorType>
                                                    <xsl:copy-of select="./ms:distributionRightsHolder/ms:organizationInfo/ms:organizationName" />
                                                    <!-- ToBeDefined:CanBeDifferent -->
                                                    <website>https://elda.org</website>
                                                </Organization>
                                            </distributionRightsHolder>
                                        </xsl:if>
                                    </DatasetDistribution>
                                </xsl:for-each>
                                <!-- ms:personalDataIncluded -->
                                <personalDataIncluded>false</personalDataIncluded>
                                <!-- ms:sensitiveDataIncluded -->
                                <sensitiveDataIncluded>false</sensitiveDataIncluded>
                                <!-- hasSubset -->
                                <xsl:for-each select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo/ms:sizeInfo">
                                    <xsl:if test="./ms:size != 'no size available' ">
                                        <!-- ToBeDefined -->
                                        <hasSubset>
                                            <!-- sizePerLanguage -->
                                            <sizePerLanguage>
                                                <amount><xsl:value-of select="./ms:size" /></amount>
                                                <xsl:if test="./ms:sizeUnit = 'terms' ">
                                                    <sizeUnit>http://w3id.org/meta-share/meta-share/term</sizeUnit>
                                                </xsl:if>
                                            </sizePerLanguage>
                                            <!-- sizePerTextFormat -->
                                            <!-- ToBeDefined -->
                                            <sizePerTextFormat>
                                                <amount><xsl:value-of select="./ms:size" /></amount>
                                                <xsl:if test="./ms:sizeUnit = 'terms' ">
                                                    <sizeUnit>http://w3id.org/meta-share/meta-share/term</sizeUnit>
                                                </xsl:if>
                                            </sizePerTextFormat>
                                        </hasSubset>
                                    </xsl:if>
                                </xsl:for-each>
                            </LexicalConceptualResource>
                        </xsl:if>
                    </LRSubclass>
                </LanguageResource>
            </DescribedEntity>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
