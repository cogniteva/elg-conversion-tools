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

    <!-- function:upperFirst  -->
    <!-- based on @see https://stackoverflow.com/a/29550250/2042871 -->
    <xsl:function name="ms:upperFirst">
        <xsl:param name="text" />
        <xsl:for-each select="tokenize($text,' ')">
            <xsl:value-of select="upper-case(substring(.,1,1))" />
            <xsl:value-of select="substring(.,2)" />
            <xsl:if test="position() ne last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
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

    <!-- template:GenericPerson  -->
    <xsl:template name="GenericPerson">
        <xsl:param name="el" />
        <actorType>Person</actorType>
        <xsl:copy-of select="$el/ms:surname" />
        <xsl:copy-of select="$el/ms:givenName" />
        <xsl:copy-of select="$el/ms:communicationInfo/ms:email" />
    </xsl:template>

    <!-- template:GenericOrganization -->
    <xsl:template name="GenericOrganization">
        <xsl:param name="el" />
        <actorType>Organization</actorType>
        <xsl:copy-of select="$el/ms:organizationName" />
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

    <!-- template:GenericProject -->
    <xsl:template name="GenericProject">
        <xsl:param name="el" />
        <xsl:copy-of select="$el/ms:projectName" />
        <xsl:for-each select="$el/ms:url">
            <website><xsl:value-of select="." /></website>
        </xsl:for-each>
    </xsl:template>

    <!-- template:DatasetDistribution -->
    <xsl:template name="DatasetDistribution">
        <!-- DatasetDistribution -->
        <xsl:for-each select="$distributionInfo/*">
            <DatasetDistribution>
                <!-- DatasetDistributionForm -->
                <xsl:choose>
                    <xsl:when test="normalize-space(./ms:distributionAccessMedium) != ''">
                        <xsl:for-each select="./ms:distributionAccessMedium">
                            <DatasetDistributionForm><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',.)" /></DatasetDistributionForm>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <DatasetDistributionForm>http://w3id.org/meta-share/meta-share/other</DatasetDistributionForm>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- downloadLocation -->
                <!-- QUESTION() what about multiple downloadLocations? -->
                <xsl:copy-of select="(./ms:downloadLocation)[1]" />
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
                            <licenceTermsName xml:lang="en"><xsl:value-of select="$licenseName" /></licenceTermsName>
                            <!-- licenceTermsURL -->
                            <xsl:variable name="restrictions">
                                <xsl:call-template name="StringValuesConcat">
                                    <xsl:with-param name="el" select="./ms:restrictionsOfUse" />
                                    <xsl:with-param name="separator" select="'-'" />
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="substring($licenseName,1,3) = 'CC-'">
                                    <licenceTermsURL><xsl:value-of select="concat('https://spdx.org/licenses/',$licenseName, '.html')" /></licenceTermsURL>
                                    <ms:LicenceIdentifier ms:LicenceIdentifierScheme="http://w3id.org/meta-share/meta-share/SPDX"><xsl:value-of select="$licenseName" /></ms:LicenceIdentifier>
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
                            <ms:LicenceIdentifier ms:LicenceIdentifierScheme="http://w3id.org/meta-share/meta-share/other"><xsl:value-of select="$licenceTermsIdentifier" /></ms:LicenceIdentifier>
                        </licenceTerms>
                    </xsl:if>
                </xsl:for-each>
                <!-- cost -->
                <cost>
                    <!-- ms:amount -->
                    <amount><xsl:value-of select="./ms:fee" /></amount>
                    <!-- ms:currency -->
                    <currency>http://w3id.org/meta-share/meta-share/euro</currency>
                </cost>
                <!-- membershipInstitution -->
                <membershipInstitution><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/',./ms:membershipInfo/ms:membershipInstitution)" /></membershipInstitution>
                <!-- ms:availabilityStartDate -->
                <xsl:copy-of select="./ms:availabilityStartDate" />
                <!-- ms:distributionRightsHolder -->
                <xsl:call-template name="Actor">
                    <xsl:with-param name="el" select="./ms:distributionRightsHolder" />
                    <xsl:with-param name="actorElement" select="'distributionRightsHolder'" />
                </xsl:call-template>
            </DatasetDistribution>
        </xsl:for-each>
    </xsl:template>

    <!-- template:Language -->
    <xsl:template name="Language">
        <xsl:param name="el" />
        <!-- languageTag -->
        <languageTag><xsl:value-of select="$el/ms:languageId" /></languageTag>
        <!-- languageId -->
        <!-- <languageId><xsl:value-of select="$el/ms:languageId" /></languageId> -->
        <!-- scriptId -->
        <!-- <scriptId><xsl:value-of select="$el/ms:languageScript" /></scriptId> -->
        <!-- regionId  -->
        <!-- <regionId><xsl:value-of select="$el/ms:region" /></regionId> -->
        <!-- variantId  -->
        <!-- <variantId><xsl:value-of select="$el/ms:variant" /></variantId> -->
        <!-- languageName -->
        <!-- QUESTION() why languageName is not longer available -->
        <!-- <languageName><xsl:value-of select="$el/ms:languageName" /></languageName> -->
    </xsl:template>


    <!-- template:Size -->
    <xsl:template name="Size">
        <xsl:param name="el" />
        <amount><xsl:value-of select="$el/ms:size" /></amount>
        <xsl:choose>
            <xsl:when test="$el/ms:sizeUnit = 'terms'">
              <sizeUnit>http://w3id.org/meta-share/meta-share/term</sizeUnit>
            </xsl:when>
            <xsl:when test="$el/ms:sizeUnit = 'hours'">
              <sizeUnit>http://w3id.org/meta-share/meta-share/hour1</sizeUnit>
            </xsl:when>
            <xsl:when test="$el/ms:sizeUnit = 'sentences'">
              <sizeUnit>http://w3id.org/meta-share/meta-share/sentence1</sizeUnit>
            </xsl:when>
            <xsl:when test="$el/ms:sizeUnit = 'entries'">
              <sizeUnit>http://w3id.org/meta-share/meta-share/entry</sizeUnit>
            </xsl:when>
            <xsl:when test="$el/ms:sizeUnit = 'tokens'">
              <sizeUnit>http://w3id.org/meta-share/meta-share/token</sizeUnit>
            </xsl:when>
            <xsl:when test="$el/ms:sizeUnit = 'words'">
              <sizeUnit>http://w3id.org/meta-share/meta-share/word3</sizeUnit>
            </xsl:when>
            <xsl:otherwise>
              <sizeUnit><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', $el/ms:sizeUnit)" /></sizeUnit>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template:Subset -->
    <xsl:template name="hasSubset">
        <xsl:param name="el" />
        <xsl:for-each select="$el/ms:sizeInfo">
            <xsl:if test="string(number(./ms:size)) != 'NaN'">
                <!-- ToBeDefined -->
                <hasSubset>
                    <!-- sizePerLanguage -->
                    <sizePerLanguage>
                        <xsl:call-template name="Size">
                            <xsl:with-param name="el" select="." />
                        </xsl:call-template>
                    </sizePerLanguage>
                    <!-- sizePerTextFormat -->
                    <!-- ToBeDefined : QUESTION() why sizePerTextFormat is mandatory? -->
                    <sizePerTextFormat>
                        <xsl:call-template name="Size">
                            <xsl:with-param name="el" select="." />
                        </xsl:call-template>
                    </sizePerTextFormat>
                </hasSubset>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- template:CorpusPart -->
    <xsl:template name="CorpusPart">
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
        <!-- lingualityType  -->
        <lingualityType><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', $el/ms:lingualityInfo/ms:lingualityType)" /></lingualityType>
        <!-- multilingualityType -->
        <!--  ToDo() -->
        <!-- multilingualityTypeDetails -->
        <!--  ToDo() -->
        <!-- language -->
        <xsl:for-each select="$el/ms:languageInfo">
            <language>
                <xsl:call-template name="Language">
                    <xsl:with-param name="el" select="." />
                </xsl:call-template>
            </language>
        </xsl:for-each>
        <!-- ms:languageVariety -->
        <!-- modalityType -->
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
            <xsl:for-each select="$contactPerson">
                <metadataCurator>
                    <xsl:call-template name="GenericPerson">
                        <xsl:with-param name="el" select="." />
                    </xsl:call-template>
                </metadataCurator>
            </xsl:for-each>
            <!-- compliesWith -->
            <compliesWith>http://w3id.org/meta-share/meta-share/ELG-SHARE</compliesWith>
            <!-- metadataCreator -->
            <xsl:if test="normalize-space($metadataCreator) != ''">
                <metadataCreator>
                    <xsl:call-template name="GenericPerson">
                        <xsl:with-param name="el" select="$metadataCreator" />
                    </xsl:call-template>
                </metadataCreator>
            </xsl:if>
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
                    <!-- ToBeDefined : corpusAudioInfo.domainInfo.domain | .lexicalConceptualResourceAudioInfo.domainInfo.domain -->
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
                    <!-- ToBeDefined -->
                    <!-- actualUse  -->
                    <xsl:for-each select="$usageInfo/ms:actualUseInfo">
                        <actualUse>
                            <!-- usedInApplication -->
                            <xsl:for-each select="./ms:useNLPSpecific">
                                <usedInApplication>
                                    <!-- FIXTHIS() OMTD classes are not strictly mapped with useNLPSpecific -->
                                    <!--
                                    <xsl:variable name="ltclass"><xsl:value-of select="ms:upperFirst(.)" /></xsl:variable>
                                    <LTClassRecommended><xsl:value-of select="concat('http://w3id.org/meta-share/omtd-share/',$ltclass)" /></LTClassRecommended>
                                    -->
                                    <!-- HOTFIX() use LTClassOther -->
                                    <LTClassOther><xsl:value-of select="." /></LTClassOther>
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
                                    <xsl:copy-of select="./ms:title" />
                                </usageReport>
                            </xsl:for-each>
                             <!-- actualUseDetails -->
                            <xsl:copy-of select="./ms:actualUseDetails"/>
                            <actualUseDetails xml:lang="en"><xsl:value-of select="./ms:actualUse"/></actualUseDetails>
                        </actualUse>
                    </xsl:for-each>
                    <!-- validated -->
                    <!-- ToBeDefined : QUESTION() can this be equal to AND($validationInfo/ms:validated/*) ? -->
                    <!-- validation -->
                    <xsl:for-each select="$validationInfo">
                        <validation>
                            <!-- validationType -->
                            <xsl:if test="normalize-space(./ms:validationType) != ''">
                                <validationType><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', ./ms:validationType)" /></validationType>
                            </xsl:if>
                            <!-- validationMode -->
                            <xsl:if test="normalize-space(./ms:validationMode) != ''">
                                <validationMode><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', ./ms:validationMode)" /></validationMode>
                            </xsl:if>
                            <!-- validationDetails -->
                            <validationDetails xml:lang="en"><xsl:value-of select="if (./ms:validated = 'true') then 'validated' else 'not validated'"/></validationDetails>
                            <xsl:if test="normalize-space(./ms:validationModeDetails) != ''">
                                <validationDetails xml:lang="und"><xsl:value-of select="./ms:validationModeDetails"/></validationDetails>
                            </xsl:if>
                            <xsl:if test="normalize-space(./ms:validationExtentDetails) != ''">
                                <validationDetails xml:lang="und"><xsl:value-of select="./ms:validationExtentDetails"/></validationDetails>
                            </xsl:if>
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
                    <!-- isDocumentedBy -->
                    <!-- NoMapAvalaible -->
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
                    <!-- NoMapAvalaible -->
                    <!-- LRSubclass -->
                    <LRSubclass>
                        <!-- Corpus  -->
                        <xsl:if test="$resourceType = 'corpus' ">
                            <Corpus>
                                <!-- lrType  -->
                                <lrType>Corpus</lrType>
                                <!-- corpusSubclass : QUESTION() how to deduce this information ? -->
                                <corpusSubclass><xsl:value-of select="concat('http://w3id.org/meta-share/meta-share/', 'rawCorpus')" /></corpusSubclass>
                                <!-- corpusMediaType -->
                                <xsl:for-each select="$corpusInfo/ms:corpusMediaType">
                                    <!-- CorpusMediaPart | CorpusTextPart -->
                                    <xsl:for-each select="./ms:corpusTextInfo">
                                        <!-- CorpusMediaPart -->
                                        <CorpusMediaPart>
                                            <!-- CorpusTextPart -->
                                            <CorpusTextPart>
                                                <!-- common corpus elements  -->
                                                <xsl:call-template name="CorpusPart">
                                                    <xsl:with-param name="el" select="." />
                                                    <xsl:with-param name="corpusMediaType" select="'CorpusTextPart'" />
                                                </xsl:call-template>
                                            </CorpusTextPart>
                                        </CorpusMediaPart>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusAudioPart -->
                                    <xsl:for-each select="./ms:corpusAudioInfo">
                                        <!-- CorpusMediaPart -->
                                        <CorpusMediaPart>
                                            <!-- CorpusAudioPart -->
                                            <CorpusAudioPart>
                                                <!-- common corpus elements  -->
                                                <xsl:call-template name="CorpusPart">
                                                    <xsl:with-param name="el" select="." />
                                                    <xsl:with-param name="corpusMediaType" select="'CorpusAudioPart'" />
                                                </xsl:call-template>
                                                <!-- AudioGenre -->
                                                <!-- SpeechGenre -->
                                                <!-- speechItem -->
                                                <!-- nonSpeechItem -->
                                                <!-- legend -->
                                                <!-- noiseLevel -->
                                                <!-- naturality -->
                                                <!-- conversationalType -->
                                                <!-- scenarioType -->
                                                <!-- audience -->
                                                <!-- interactivity -->
                                                <!-- interaction -->
                                                <!-- recordingDeviceType -->
                                                <!-- recordingDeviceTypeDetails -->
                                                <!-- recordingPlatformSoftware -->
                                                <!-- recordingEnvironment -->
                                                <!-- sourceChannel -->
                                                <!-- sourceChannelType -->
                                                <!-- sourceChannelName -->
                                                <!-- sourceChannelDetails -->
                                                <!-- recorder -->
                                                <!-- capturingDeviceType -->
                                                <!-- capturingDeviceTypeDetails -->
                                                <!-- capturingDetails -->
                                                <!-- capturingEnvironment -->
                                                <!-- sensorTechnology -->
                                                <!-- sceneIllumination -->
                                                <!-- numberOfParticipants -->
                                                <!-- ageGroupOfParticipants -->
                                                <!-- ageRangeStartOfParticipants -->
                                                <!-- ageRangeEndOfParticipants -->
                                                <!-- sexOfParticipants -->
                                                <!-- originOfParticipants -->
                                                <!-- dialectAccentOfParticipants -->
                                                <!-- hearingImpairmentOfParticipants -->
                                                <!-- speakingImpairmentOfParticipants -->
                                                <!-- numberOfTrainedSpeakers -->
                                                <!-- speechInfluence -->
                                                <!-- participant -->
                                                <!-- creationMode -->
                                                <!-- isCreatedBy -->
                                                <!-- hasOriginalSource -->
                                                <!-- originalSourceDescription -->
                                                <!-- syntheticData -->
                                                <!-- creationDetails -->
                                                <!-- linkToOtherMedia -->
                                            </CorpusAudioPart>
                                        </CorpusMediaPart>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusVideoPart -->
                                    <xsl:for-each select="./ms:corpusVideoInfo">
                                        <!-- CorpusMediaPart -->
                                        <CorpusMediaPart>
                                            <!-- CorpusVideoPart -->
                                            <CorpusVideoPart>
                                                <!-- common corpus elements  -->
                                                <xsl:call-template name="CorpusPart">
                                                    <xsl:with-param name="el" select="." />
                                                    <xsl:with-param name="corpusMediaType" select="'CorpusVideoPart'" />
                                                </xsl:call-template>
                                                <!-- typeOfVideoContent : QUESTION() what would be a default value ?  -->
                                                <xsl:if test="not(./ms:videoContentInfo)">
                                                    <typeOfVideoContent xml:lang="en">undefined</typeOfVideoContent>
                                                </xsl:if>
                                                <xsl:for-each select="./ms:videoContentInfo/ms:typeOfVideoContent">
                                                    <typeOfVideoContent xml:lang="und"><xsl:value-of select="." /></typeOfVideoContent>
                                                </xsl:for-each>
                                            </CorpusVideoPart>
                                        </CorpusMediaPart>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusImagePart -->
                                    <xsl:for-each select="./ms:corpusImageInfo">
                                        <!-- CorpusMediaPart -->
                                        <CorpusMediaPart>
                                            <!-- CorpusImagePart -->
                                            <CorpusImagePart>
                                                <!-- common corpus elements  -->
                                                <xsl:call-template name="CorpusPart">
                                                    <xsl:with-param name="el" select="." />
                                                    <xsl:with-param name="corpusMediaType" select="'CorpusImagePart'" />
                                                </xsl:call-template>
                                            </CorpusImagePart>
                                        </CorpusMediaPart>
                                    </xsl:for-each>
                                    <!-- CorpusMediaPart | CorpusTextNumericalPart -->
                                    <xsl:for-each select="./ms:corpusTextNumericalInfo">
                                        <!-- CorpusMediaPart -->
                                        <CorpusMediaPart>
                                            <!-- CorpusTextNumericalPart -->
                                            <CorpusTextNumericalPart>
                                                <!-- common corpus elements  -->
                                                <xsl:call-template name="CorpusPart">
                                                    <xsl:with-param name="el" select="." />
                                                    <xsl:with-param name="corpusMediaType" select="'CorpusTextNumericalPart'" />
                                                </xsl:call-template>
                                            </CorpusTextNumericalPart>
                                        </CorpusMediaPart>
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
                                <!-- geographicCoverage -->
                                <!-- register -->
                                <!-- userQuery -->
                                <!-- annotation -->
                                <annotation>
                                    <!-- TODO() ms:corpusAudioInfo/ms:annotationInfo -->
                                    <!--        ms:corpusTextInfo/ms:annotationInfo -->
                                    <!--        ms:corpusVideoInfo/ms:annotationInfo -->
                                    <!--        ms:corpusTextNumericalInfo/ms:annotationInfo -->
                                    <!--        ms:corpusImageInfo/ms:annotationInfo -->
                                    <annotationType>http://w3id.org/meta-share/omtd-share/StructuralAnnotationType</annotationType>
                                </annotation>
                                <!-- hasSubset -->
                                <xsl:for-each select="$corpusInfo/ms:corpusMediaType">
                                    <!-- hasSubset | corpusTextInfo -->
                                    <xsl:for-each select="./ms:corpusTextInfo">
                                        <xsl:call-template name="hasSubset">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- hasSubset | corpusAudioInfo -->
                                    <xsl:for-each select="./ms:corpusAudioInfo">
                                        <xsl:call-template name="hasSubset">
                                            <xsl:with-param name="el" select="./ms:audioSizeInfo" />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- hasSubset | corpusVideoInfo -->
                                    <xsl:for-each select="./ms:corpusVideoInfo">
                                        <xsl:call-template name="hasSubset">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- hasSubset | corpusImageInfo -->
                                    <xsl:for-each select="./ms:corpusImageInfo">
                                        <xsl:call-template name="hasSubset">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- hasSubset | corpusTextNumericalInfo -->
                                    <xsl:for-each select="./ms:corpusTextNumericalInfo">
                                        <xsl:call-template name="hasSubset">
                                            <xsl:with-param name="el" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <!-- hasSubset | corpusTextNgramInfo -->
                                    <!-- ToBeDefined -->
                                </xsl:for-each>
                            </Corpus>
                        </xsl:if>
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
                                <xsl:call-template name="hasSubset">
                                    <xsl:with-param name="el" select="$mediaType/ms:lexicalConceptualResourceMediaType/ms:lexicalConceptualResourceTextInfo" />
                                </xsl:call-template>
                            </LexicalConceptualResource>
                        </xsl:if>
                    </LRSubclass>
                </LanguageResource>
            </DescribedEntity>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
