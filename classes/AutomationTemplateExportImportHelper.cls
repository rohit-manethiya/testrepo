public with sharing class AutomationTemplateExportImportHelper {
    public static Id exportAutomationAndReturnContentDocumentId(Id automationTemplateId, String automationTemplateName) {
        Id createdFileId = null;
        try {
            List<Deployment__c> deployments = returnAutomationWithSteps(automationTemplateId);
            if (!deployments.isEmpty()) {
                createdFileId = insertFileToAutomationTemplateAndReturnContentDocumentId(
                    automationTemplateId,
                    automationTemplateName,
                    JSON.serializePretty(deployments[0])
                );
            }
        } catch (Exception ex) {
            System.debug('error : ' + ex.getMessage());
        }
        return createdFileId;
    }

    private static List<Deployment__c> returnAutomationWithSteps(Id automationId) {
        List<Deployment__c> deployments = [
            SELECT
                Name,
                Description__c,
                Active__c,
                (
                    SELECT
                        Automated_Behaviour__c,
                        Deployment__c,
                        Name,
                        Read_Only__c,
                        Notify_Task_Owner__c,
                        Manual_Task_Notified__c,
                        SUM_Deployed__c,
                        Org_Count__c,
                        Count_Completed__c,
                        Type__c,
                        dataJson__c,
                        Status__c,
                        View_Attachment__c,
                        Status_Flag__c,
                        Run_all_tests__c,
                        Order__c,
                        Git_Repository__c,
                        Deployed__c,
                        Completed__c,
                        Commit_Name__c,
                        Commit_Id__c,
                        Branch__c,
                        CheckOnly__c
                    FROM Steps__r
                )
            FROM Deployment__c
            WHERE Id = :automationId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        return deployments;
    }

    private static Id insertFileToAutomationTemplateAndReturnContentDocumentId(
        Id automationTemplateId,
        String automationTemplateName,
        String fileContent
    ) {
        String contentName = String.isNotBlank(automationTemplateName) ? automationTemplateName : automationTemplateId;
        ContentVersion contentVersionRecord = new ContentVersion();
        contentVersionRecord.ContentLocation = 'S';
        contentVersionRecord.PathOnClient = contentName + '.json';
        contentVersionRecord.Title = contentName;
        contentVersionRecord.VersionData = Blob.valueOf(fileContent);
        insert contentVersionRecord;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionRecord.Id].ContentDocumentId;
        ContentDocumentLink contentDocumentRecordLink = new ContentDocumentLink();
        contentDocumentRecordLink.LinkedEntityId = automationTemplateId;
        contentDocumentRecordLink.ContentDocumentId = contentDocumentId;
        contentDocumentRecordLink.shareType = 'V';
        insert contentDocumentRecordLink;

        return contentDocumentId;
    }
}