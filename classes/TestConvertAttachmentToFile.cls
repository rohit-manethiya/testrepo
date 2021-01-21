@isTest
private class TestConvertAttachmentToFile {
    @TestSetup
    static void setupData() {
        Environment__c env1 = new Environment__c(Name = 'Dev1 Environment', Type__c = 'Sandbox');
        insert env1; 
        Utilities.insertAttachment(Blob.valueOf('test'), 'vlocity-settings.yaml', 'text', env1.Id);
    }

    static testMethod void testFileConvert() {
        Test.startTest();
        ConvertAttachmentToFile.convertToFile(true);
        Test.stopTest();
    }
}