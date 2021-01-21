/**
 * Copado SFDX client api. In this class salesforce dx related callout and common operation methods are being handled.
 * Salesforce DX is an open and standard developer experience, letting you build with the tools you love including Git, Selenium, Eclipse, Sublime, and more.
 * Salesforce DX includes an updated Eclipse integrated development environment (IDE) that significantly expands the value of the toolset to developers.
 * With Copado's DX solution everybody, even someone who doesn't know CLI can use most of DX features.
 * @author Mert YALTI
 * @author Jesus Gaviria
 * @see SfdxAPIHelper
 * @version 1.0
 * @since Copado v11
 */
public with sharing class SfdxAPI extends SfdxAPIHelper {
    public static String convertIgnore { get; set; }
    public static String pushIgnore { get; set; }
    private static String STARTING = 'Starting...';
    /**
     * SFDX Scratch Org creation call out.
     * @author Mert YALTI
     * @param  orgDefinitionJSON JSON file which defines scratch org structure. The scratch org definition file is a blueprint for a scratch org. It mimics the shape of an org that you use in the development life cycle, such as org type, edition, features etc.
     * @param  devHubOrgId       Hub org Id. The Developer Hub (Dev Hub) lets you create and manage scratch orgs. The scratch org is a source-driven and disposable deployment of Salesforce code and metadata, made for developers and automation.
     * @param  copadoDxOrgId     Copado org credential Id which will contain information about the scratch org that will be created. Backend will update this org credential with scratch org details when the scratch org is created.
     * @param  durationDays      duration of the scratch org(in days) (default:7, min:1,max:30)
     * @see HttpRequest
     * @see HttpResponse
     * @return HttpResponse body
     */
    /*public static void orgCreate(String orgDefinitionJSON, String devHubOrgId, String orgName, Integer durationDays, String flowId, String targetEnv, String usId) {
        durationDays = durationDays == null || durationDays == 0 ? 7 : durationDays;
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrg?devHubOrgId=' + EncodingUtil.urlEncode(devHubOrgId, 'UTF-8') + '&orgName=' + EncodingUtil.urlEncode(orgName, 'UTF-8') + '&durationDays=' + durationDays;
        if(String.isNotBlank(flowId) && flowId != '-- None --') {
            callURL += '&flowId=' + EncodingUtil.urlEncode(flowId, 'UTF-8');
            if(String.isNotBlank(targetEnv) && targetEnv != '-- None --') { 
                callURL += '&targetEnv=' + EncodingUtil.urlEncode(targetEnv, 'UTF-8');
            } else { // jg: not required!
                throw new CopadoDxException('Target Environment needs to be defined when deployment flow step creation requested.');
            }
        }
        if(String.isNotBlank(usId)) {
            callURL += '&userStoryId=' + EncodingUtil.urlEncode(usId, 'UTF-8');
        }
        Map<String, String> attachments = new Map<String, String>();
        orgDefinitionJSON = sfdxApiHelper.returnJsonAfterCorrection(orgDefinitionJSON);
        attachments.put(SfdxAPIHelper.DX_DEFINITION_FILE, orgDefinitionJSON);

        try {
            HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, JSON.serialize(attachments), true);
            String body = res.getBody();
            System.debug(loggingLevel.INFO, '*** org_create body: ' + body);
            if(String.isNotBlank(body)) {
                CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.class);
                if(String.isNotBlank(r.copadoJobId)) {
                    JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_CREATE_ORG, null, STARTING);
                }
            }
        } catch(Exception e) {
            throw new CopadoDxException('An error has been occurred during org creation.' + e.getMessage());
        }

        //return body;
    }*/

    /**
     * SFDX Package creation call out.
     * @author Umit Can UCKAN
     * @param projectJson               JSON file which defines Project org structure.
     * @param description               package description
     * @param packageName               (required) package name
     * @param nonamespace               creates the package with no namespace; available only for unlocked packages.
     * @param packageType               (required) package type (Managed,Unlocked)
     * @param devHubOrgCredentialId     sf org credential record Id for the Dev hub you want to create the package on
     * @param artifactId                sf artifact record Id to update after the operation
     */
    /*public static void packageCreate(String projectJson, String description, String packageName, Boolean nonamespace, String packageType, Id devHubOrgCredentialId, Id artifactId) {
        String callURL = Settings.server_url + '/json/v1/package/create?description=' + EncodingUtil.urlEncode(description, 'UTF-8') + '&name=' + EncodingUtil.urlEncode(packageName, 'UTF-8') + (nonamespace != null ? ('&noNamespace=' + nonamespace) : '') + '&packageType=' + packageType + '&devHubOrgId=' + devHubOrgCredentialId + '&artifactId=' + artifactId;
        try {
            Map<String, String> attachments = new Map<String, String>();
            attachments.put(SfdxAPIHelper.DX_PROJECT_FILE, projectJSON);
            HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, JSON.serialize(attachments), false);
            String body = res.getBody();

            if(res.getStatusCode() != 200){
                throw new CopadoDxException('Package create cannot be executed.. Status code: '+res.getStatusCode());
            }

            if(String.isNotBlank(body)) {
                CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.class);
                if(String.isNotBlank(r.copadoJobId)) {
                    JobsManager.createRunningJob(r.copadoJobId, CopadoNotificationHelper.DX_CREATE_PACKAGE, null, STARTING);
                }
            }
            SfdxAPIHelper.PackageCreateResponse respObj = (SfdxAPIHelper.PackageCreateResponse) Json.deserialize(body, SfdxAPIHelper.PackageCreateResponse.class);
        } catch(Exception ex) {
            throw new CopadoDxException('An error has been occurred during package creation.' + ex.getMessage());
        }
    }*/

    /**
     * SFDX Package version creation call out.
     * @author Umit Can UCKAN
     * @param projectJson               JSON file which defines Project org structure.
     * @param orgDefinitionJSON         JSON file which defines scratch org structure. The scratch org definition file is a blueprint for a scratch org. It mimics the shape of an org that you use in the development life cycle, such as org type, edition, features etc.
     * @param branch                    the package version’s branch
     * @param installationKey           installation key for key-protected package (either --installationkey or --installationkeybypass is required)
     * @param installationKeyBypass     bypass the installation key requirement (either --installationkey or --installationkeybypass is required)
     * @param packageId                 ID (starts with 0Ho) or alias of the package to create a version of
     * @param tag                       the package version’s tag
     * @param devHubOrgCredentialId     sf org credential record Id for the Dev hub you want to create the package on
     * @param versionDescription        the description of the package version to be created
     * @param versionName               the name of the package version to be created
     * @param versionNumber             the version number of the package version to be created
     * @param artifactId                sf artifact record Id to update after the operation
     */
    /*@Future(callout=true)
    public static void packageVersionCreate(String projectJson, String orgDefinitionJSON, String branch, String installationKey, Boolean installationKeyBypass, Id packageId, String tag, Id devHubOrgCredentialId, String versionDescription, String versionName, String versionNumber, Id artifactId) {
        String callURL = Settings.Server_URL + '/json/v1/package/version/create?&packageId=' + packageId + '&devHubOrgId=' + devHubOrgCredentialId + +'&versionName=' + EncodingUtil.urlEncode(versionName, 'UTF-8') + '&versionNumber=' + versionNumber + '&artifactId=' + artifactId;
        if(!String.isBlank(branch)) {
            callURL += '&branch=' + EncodingUtil.urlEncode(branch, 'UTF-8');
        }
        if(String.isNotBlank(installationKey) && installationKeyBypass == false) {
            callURL += '&installationKey=' + installationKey;
        } else {
            callURL += '&installationKeyByPass=' + installationKeyBypass;
        }
        if(String.isNotBlank(tag)) {
            callURL += '&tag=' + EncodingUtil.urlEncode(tag, 'UTF-8');
        }
        if(String.isNotBlank(versionDescription)) {
            callURL += '&versionDescription=' + EncodingUtil.urlEncode(versionDescription, 'UTF-8');
        }

        try {
            Map<String, String> attachments = new Map<String, String>();
            orgDefinitionJSON = orgDefinitionJSON != null ? sfdxApiHelper.returnJsonAfterCorrection(orgDefinitionJSON) : SfdxAPIHelper.prepareDefaultOrgDefinitionJSON();
            attachments.put(SfdxAPIHelper.DX_PROJECT_FILE, projectJSON);
            attachments.put(SfdxAPIHelper.DX_DEFINITION_FILE, SfdxAPIHelper.orgDefinitionDefaultKeyFixer(orgDefinitionJSON));
            
            HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, JSON.serialize(attachments), true);
            String body = res.getBody();
            if(String.isNotBlank(body)) {
                CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.class);
                if(String.isNotBlank(r.copadoJobId)) {
                    JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_CREATE_PACKAGE_VERSION, null, STARTING);
                }
            }
            SfdxAPIHelper.PackageCreateResponse respObj = (SfdxAPIHelper.PackageCreateResponse) Json.deserialize(body.replace('\n', '\\n'), SfdxAPIHelper.PackageCreateResponse.class);
         } catch(Exception ex) {
            throw new CopadoDxException(Label.Error_During_Package_Version_Creation + ': ' + ex.getMessage());
        }
    }*/

    /**
     * SFDX Package Update call out.
     * @author Umit Can UCKAN
     * @param projectJson                 JSON file which defines Project org structure.
     * @param description                 new package description
     * @param name                        new package name
     * @param packageId                   (required) ID (starts with 0Ho) or alias of the package to update
     * @param devHubOrgCredentialId       sf org credential record Id for the Dev hub you want to create the package on
     * @param artifactId                  sf artifact record Id to update after the operation
     */
    /*public static void packageUpdate(String projectJson, String description, String name, Id packageId, Id devHubOrgCredentialId, Id artifactId) {
        // Commented out since front end implementation is not completed yet and this method causes code coverage issue.

        /*String callURL = Settings.Server_URL + '/json/v1/dx/<Luis2CreatePackageUpdate>?description=' + EncodingUtil.urlEncode(description, 'UTF-8') + '&name=' + EncodingUtil.urlEncode(name, 'UTF-8') + '&package=' + packageId + '&artifactId=' + artifactId + '&devHubOrgCredentialId=' + devHubOrgCredentialId;
        try {
            String body = '{"status":0,"result":{"id":"0Hof2000000PAwyCAG","success":true,"errors":[]}}';
            SfdxAPIHelper.PackageCreateResponse respObj = (SfdxAPIHelper.PackageCreateResponse) JSON.deserialize(body.replace('\n', '\\n'), SfdxAPIHelper.PackageCreateResponse.class);
        } catch(Exception ex) {
            throw new CopadoDxException('An error has been occurred during package update.' + ex.getMessage());
        }
    }*/
    /**
     * SFDX Package version Update call out.
     * @author Umit Can UCKAN
     * @param projectJson               JSON file which defines Project org structure.
     * @param branch                    the package version’s branch
     * @param installationkey           installation key for key-protected package (either --installationkey or --installationkeybypass is required)
     * @param packageId                 ID (starts with 0Ho) or alias of the package to create a version of
     * @param tag                       the package version’s tag
     * @param versiondescription        new package version description
     * @param versionname               the name of the package version to be created
     * @param artifactId                sf artifact record Id to update after the operation
     * @param devHubOrgCredentialId     sf org credential record Id for the Dev hub you want to create the package on
     */
    /*public static void packageVersionUpdate(String projectJson, String branch, String installationkey, Id packageId, String tag, String versiondescription, String versionname, Id artifactId, Id devHubOrgCredentialId) {
        // Commented out since front end implementation is not completed yet and this method causes code coverage issue.

        /*String callURL = Settings.Server_URL + '/json/v1/dx/<Luis2CreatePackageVersionUpdate>?branch=' + EncodingUtil.urlEncode(branch, 'UTF-8') + '&versiondescription=' + EncodingUtil.urlEncode(versiondescription, 'UTF-8') + '&installationkey=' + installationkey + '&package=' + packageId + '&tag=' + EncodingUtil.urlEncode(tag, 'UTF-8') + '&versionname=' + EncodingUtil.urlEncode(versionname, 'UTF-8') + '&artifactId=' + artifactId + '&devHubOrgCredentialId=' + devHubOrgCredentialId;
        try {
            String body = '{"status":0,"result":{"id":"04tf2000002JT8jAAG","success":true,"errors":[]}}';
            SfdxAPIHelper.PackageCreateResponse respObj = (SfdxAPIHelper.PackageCreateResponse) Json.deserialize(body.replace('\n', '\\n'), SfdxAPIHelper.PackageCreateResponse.class);
            System.debug('respObj==> ' + respObj);
        } catch(Exception ex) {
            throw new CopadoDxException('An error has been occurred during package version update.' + ex.getMessage());
        }
    }*/
    /**
     * SFDX Promote Beta Package to Released.
     * @author Umit Can UCKAN
     * @param projectJson                 JSON file which defines Project org structure.
     * @param packageId                   (required) ID (starts with 0Ho) or alias of the package to update
     * @param devHubOrgCredentialId       sf org credential record Id for the Dev hub you want to create the package on
     * @param artifactId                  sf artifact record Id to update after the operation
     * @param artifactVersionId           sf artifact version to be promoted
     */
    public static void promoteBetaPackagetoReleased(String projectJson, Id packageId, Id devHubOrgCredentialId, Id artifactId, Id artifactVersionId) {
        if(String.isBlank(projectJson) && packageId == null && devHubOrgCredentialId == null && artifactVersionId == null) {
            throw new CopadoDxException('Required parameter or parameters are missing for promoting this beta version!!!'); //TODO : Custom Label
        }
        String callURL = Settings.server_url + '/json/v1/promoteToReleased?packageId=' + packageId + '&artifactId=' + artifactId + '&devHubOrgId=' + devHubOrgCredentialId + '&artifactVersionId=' + artifactVersionId;
        try {
            Map<String, String> attachments = new Map<String, String>();
            attachments.put(DXLabel.PROJECT_FILE, projectJSON);
            HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, JSON.serialize(attachments), true);
            String body = res.getBody();//success response example
            // Sample response String body = '{"status":0,"result":{"id":"04tf2000000oFUwAAM","success":true,"errors":[]}}';

            if(String.isNotBlank(body)) {
                CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.class);
                if(String.isNotBlank(r.copadoJobId)) {
                    JobsManager.createRunningJob(r.copadoJobId, CopadoNotificationHelper.DX_PROMOTE_BETA_RELEASED, null, STARTING);
                }
            }

            SfdxAPIHelper.PackageCreateResponse respObj = (SfdxAPIHelper.PackageCreateResponse) JSON.deserialize(body.replace('\n', '\\n'), SfdxAPIHelper.PackageCreateResponse.class);
            System.debug('respObj==> ' + respObj);
        } catch(Exception ex) {
            throw new CopadoDxException('An error has been occurred during artifact version promotion.' + ex.getMessage());
        }
    }

    /*public static void installPackages(Id targetOrgId, String packagesToInstallJSON) {
        if(String.isEmpty(targetOrgId)) {
            throw new CopadoDxException('Required target org parameter is missing!!!'); //TODO : Custom Label
        }
        String callUrl = Settings.server_url + '/json/v1/package/install?targetOrgId=' + targetOrgId;
        try {
            HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, packagesToInstallJSON, true);
            String body = res.getBody();

            if(String.isNotBlank(body)) {
                CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.class);
                if(String.isNotBlank(r.copadoJobId)) {
                    JobsManager.createRunningJob(r.copadoJobId, CopadoNotificationHelper.DX_INSTALLED_PACKAGES, null, STARTING);
                }
            }
        } catch(Exception ex) {
            throw new CopadoDxException('An error has been occurred during package installation' + ex.getMessage());
        }
    }*/

    /**
     * Open an org any org
     * sfdx force:org:open
     * -p, --path PATH navigation URL path
     * -u, --targetusername TARGETUSERNAME  username or alias for the target org; overrides default target org display navigation URL, but don’t launch browser
     * Scratch org information will be encrypted in an attachment on org credentials callURL
     * Regular orgs like sandbox, dev org, prod will be accessible via oAuth token and user name
     * @param username Scratch org user name
     * @param copadoDxOrgId username for the dev hub org
     * @return HttpResponse body
     */
    public static String orgOpen(String orgId) {
        if(String.isEmpty(orgId)) {
            throw new CopadoDxException(Label.Org_Open_OrgId_Required);
        }
        String callURL = Settings.Server_URL + '/json/v1/org/' + EncodingUtil.urlEncode(orgId, 'UTF-8') + '/accessUrl';
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** org_open body: ' + body);
        return body;
    }

    /**
     * Mark a scratch org for deletion
     * sfdx force:org:delete
     * Flags:
     *  -p, --noprompt => no prompt to confirm deletion (Will be used all the time by the backend since confirmation will be handled by UI)
     *  -v, --targetdevhubusername TARGETDEVHUBUSERNAME username or alias for the dev hub org; overrides default dev hub org
     *  -u, --targetusername TARGETUSERNAME (required) username or alias for the target org
     * Sanity check is required before killing an org
     * source_status should be triggered to display changed metadata
     * And also related user stories, scheduled permissions where scratch org is source etc should be displayed
     * @param username Scratch org user name
     * @return HttpResponse body
     */
    /*public static String orgDelete(String scratchOrgId) {
        if(String.isEmpty(scratchOrgId)) {
            throw new CopadoDxException(Label.Org_Delete_OrgId_Required);
            return null;
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrg/' + EncodingUtil.urlEncode(scratchOrgId, 'UTF-8');
        HttpResponse res = SfdxAPIHelper.callDxJob('DELETE', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** org_delete body: ' + body);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_DELETE_ORG, null, STARTING);
        }
        return body;
    }*/

    /**
     * get org description
     * Output includes your access token, client ID, connected status, org ID, instance URL, username, and alias, if applicable.
     * Use --verbose to include the SFDX auth URL. (We dont need this for Copado UI, but customers may need it)
     * @param username Scratch org user name
     * @return HttpResponse body
     */
    /*public static String orgDisplay(String scratchOrgId) {
        if(String.isEmpty(scratchOrgId)) {
            throw new CopadoDxException(Label.Org_Display_Username_Required);
            return null;
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrg/' + EncodingUtil.urlEncode(scratchOrgId, 'UTF-8') + '/orgDetails';
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** org_display body: ' + body);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_ORG_DETAILS, null, STARTING);
        }
        return body;
    }*/

    /*public static String generatePassword(String scratchOrgId) {
        if(String.isEmpty(scratchOrgId)) {
            throw new CopadoDxException(Label.Org_Display_Username_Required);
            return null;
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrg/' + EncodingUtil.urlEncode(scratchOrgId, 'UTF-8') + '/ideDetails';
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** generatePassword body: ' + body);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_ORG_IDE_DETAILS, null, STARTING);
        }
        return body;
    }*/

    /**
     * list changes in a scratch org
     * sfdx force:source:status
     * -a, --all list all the changes that have been made (Will not be used in Copado)
     * -l, --local list the changes that have been made locally (Will not be used in Copado)
     * -r, --remote list the changes that have been made in the scratch org (AuditTrail)
     * -u, --targetusername TARGETUSERNAME  username or alias for the target org;
     * @param username Scratch org user name
     * @return HttpResponse body
     */
    /*public static String sourceStatus(String scratchOrgId, String repositoryId, String branch) {
        if(String.isEmpty(scratchOrgId)) {
            throw new CopadoDxException(Label.Org_Status_OrgId_Required);
            return null;
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrg/' + EncodingUtil.urlEncode(scratchOrgId, 'UTF-8') + '/sourceStatus?repositoryId=' + EncodingUtil.urlEncode(repositoryId, 'UTF-8') + '&branch=' + EncodingUtil.urlEncode(branch, 'UTF-8');
        System.debug(loggingLevel.INFO, '*** callURL body: ' + callURL);
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** source_status body: ' + body);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_SOURCE_STATUS, null, STARTING);
        }
        return body;
    }*/

    /*public static void fullScratchOrg(String definitionJSON, String devHubOrgId, String orgName, Integer durationDays, String flowId, String targetEnv, String artifactIds, String sourceOrgId, String sourceBranch, String permSets, String projectJSON, String mdSourcesJson, String dxRepositoryId, String usId, String convertSource, String packageDetailsJson) {
        String metadataSourceParameters = '';
        if(String.isNotBlank(artifactIds)) {
            metadataSourceParameters = '&artifactIds=' + EncodingUtil.urlEncode(artifactIds.replace('[', '').replace(']', ''), 'UTF-8');
        } else if(String.isNotBlank(sourceOrgId)) {
            metadataSourceParameters = '&orgId=' + EncodingUtil.urlEncode(sourceOrgId, 'UTF-8');
        } else if(String.isNotBlank(sourceBranch)) {
            metadataSourceParameters = '&branch=' + EncodingUtil.urlEncode(sourceBranch, 'UTF-8');
        }

        if(String.isNotBlank(dxRepositoryId)) {
            metadataSourceParameters = metadataSourceParameters + '&dxRepositoryId=' + EncodingUtil.urlEncode(dxRepositoryId, 'UTF-8');
        }
        if(String.isNotBlank(usId)) {
            metadataSourceParameters = metadataSourceParameters + '&userStoryId=' + EncodingUtil.urlEncode(usId, 'UTF-8');
        }
        if(String.isNotBlank(permSets)) {
            metadataSourceParameters = metadataSourceParameters + '&permSets=' + EncodingUtil.urlEncode(permSets, 'UTF-8');
        }

        //metadataSourceParameters = '&branch=master&repositoryId=a0Q0Y00000FsuDW&dxRepositoryId=a0Q0Y00000FsuDW';
        String callURL = Settings.Server_URL + '/json/v1/dx/fullScratchOrg/?devHubOrgId=' + EncodingUtil.urlEncode(devHubOrgId, 'UTF-8') + '&sendEmail=true' + '&durationDays=' + durationDays + '&orgName=' + EncodingUtil.urlEncode(orgName, 'UTF-8') + '&convertSource=' + convertSource;
        if(String.isNotBlank(metadataSourceParameters)) {
            callURL += metadataSourceParameters;
        }
        if(String.isNotBlank(flowId) && flowId != '-- None --') {
            callURL += '&flowId=' + EncodingUtil.urlEncode(flowId, 'UTF-8');
            if(String.isNotBlank(targetEnv) && targetEnv != '-- None --') {
                callURL += '&targetEnv=' + EncodingUtil.urlEncode(targetEnv, 'UTF-8');
            } else {
                throw new CopadoDxException('Target Environment needs to be defined when deployment flow step creation requested.');
            }
        }
        Map<String, String> attachments = new Map<String, String>();
        //below puts current user's email to scratch org template's admin email field on Json
        definitionJSON = sfdxApiHelper.returnJsonAfterCorrection(definitionJSON);
        if(String.isNotBlank(definitionJSON))attachments.put(SfdxAPIHelper.DX_DEFINITION_FILE, definitionJSON); else throw new CopadoDxException('Scratch Org Definition is required');

        if(String.isNotBlank(projectJSON)) attachments.put(SfdxAPIHelper.DX_PROJECT_FILE, SfdxAPIHelper.orgDefinitionDefaultKeyFixer(projectJSON));
        if(String.isNotBlank(mdSourcesJson)) attachments.put(SfdxAPIHelper.DX_METADATA_SOURCES, mdSourcesJson);
        if(String.isNotBlank(packageDetailsJson)) attachments.put(SfdxAPIHelper.DX_PACKAGE_DETAILS, packageDetailsJson);

        System.debug(loggingLevel.INFO, '*** callURL: ' + callURL);
        System.debug(LoggingLevel.INFO, '***JSON.serialize(attachments) :' + JSON.serialize(attachments));
        HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, JSON.serialize(attachments), true);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** fullScratchOrg body: ' + body);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, 'DxCreateFullScratchOrgJob', null, STARTING);
        }
    }*/

    @Future(callout=true)
    public static void refreshStatus() {
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrgsStatus';
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** source_pull body: ' + body);
    }

    public static String retrieveBranchesFromRepository(String repoId) {
        if(String.isEmpty(repoId)) {
            throw new CopadoDxException(Label.RepoId_Required);
            return null;
        }
        repoId = repoId != null ? repoId : '';
        String callURL = Settings.Server_URL + '/json/v1/dx/gitBranches/' + EncodingUtil.urlEncode(repoId, 'UTF-8');
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** source_pull body: ' + body);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, 'DxListRepositoryBranches', null, STARTING);
        }
        return body;
    }

    public static String artifactSnapshot(String artifactId) {
        if(String.isEmpty(artifactId)) {
            throw new CopadoDxException(Label.ArtifactId_Required);
        }
        //repoId = repoId != null ? repoId : '';
        String callURL = Settings.Server_URL + '/json/v1/dx/artifactSnapshot/' + EncodingUtil.urlEncode(artifactId, 'UTF-8');
        HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, null, false);
        String body = res.getBody();
        System.debug(loggingLevel.INFO, '*** source_pull body: ' + body);
        return body;
    }

    /*public static void getListOfPackages(String orgId) {
        if(String.isEmpty(orgId)) {
            throw new CopadoDxException('Org Id is required to retrieve list of packages'); //TODO: custom label
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/packagesList/' + EncodingUtil.urlEncode(orgId, 'UTF-8');
        HttpResponse res = SfdxAPIHelper.callDxJob('GET', callURL, null, false);
        String body = res.getBody();
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, 'DxListOrgPackagesJob', null, STARTING);
        }
    }*/

    public static void mergeReleases(String artifactId, String releaseId) {
        if(String.isEmpty(artifactId) || String.isEmpty(releaseId)) {
            throw new CopadoDxException('Artifact Id and Release Id are required to merge releases'); //TODO: custom label
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/artifact/' + artifactId + '/mergeRelease?releaseId=' + releaseId;
        HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, null, false);
        String body = res.getBody();
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_ARTIFACT_MERGE_RELEASE, null, STARTING);
        }
    }

    public static void createProjectBranch(String orgId, String dxRepoId) {
        if(String.isEmpty(orgId)) {
            throw new CopadoDxException('Scratch Org Id is required');//TODO: custom label
        } else if(String.isEmpty(dxRepoId)) {
            throw new CopadoDxException('Repository Id where Project branch will be created is required.');//TODO: custom label
        }
        String callURL = Settings.Server_URL + '/json/v1/dx/scratchOrg/' + orgId + '/projectBranch?dxRepositoryId=' + dxRepoId;
        HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, null, false);
        String body = res.getBody();
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(body, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, CopadoNotificationHelper.DX_CREATE_PROJECT_BRANCH, null, STARTING);
        }
    }

    /**
     * Calls backend job to create necesary information to authorize the scratchorg
     */
    @Future(callout=true)
    public static void authorizeExternalScratchOrg(String orgCredentialId, String authUrl) {
        String callURL = Settings.Server_URL + '/dx/scratchorg/external/' + orgCredentialId + '/register';
        String body = JSON.serialize(new Map<String, String>{'sfdxAuthUrl' => authUrl});
        HttpResponse res = SfdxAPIHelper.callDxJob('POST', callURL, body, false);
        String response = res.getBody();

        System.debug(loggingLevel.INFO, '*** externalScratchOrg body: ' + response);
        CopadoNotificationHelper.copadoFrontAPIreponse r = (CopadoNotificationHelper.copadoFrontAPIreponse) JSON.deserialize(response, CopadoNotificationHelper.copadoFrontAPIreponse.Class);
        if(String.isNotBlank(r.copadoJobId)) {
            JobsManager.createRunningJob(r.CopadoJobId, 'registerExternalScratchOrg', orgCredentialId, STARTING);
        }
    }

    public class CopadoDxException extends Exception {
    }
}