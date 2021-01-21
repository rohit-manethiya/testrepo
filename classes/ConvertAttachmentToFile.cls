public with sharing class ConvertAttachmentToFile {
    public static void convertToFile(Boolean deleteAttachments){
        List<Attachment> attachmentList = [Select Id,ParentId,Body,Name,OwnerId from Attachment where name='vlocity-settings.yaml'];
        //List<Attachment> attachmentList = [Select Id,ParentId,Body,Name,OwnerId from Attachment where name='Copado.yml'];
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<Attachment> attachmentListDel = new List<Attachment>();

        ContentVersion cvRec;
        
        for(Attachment attachmentRec: attachmentList){
            if(attachmentRec.ParentId.getSObjectType().getDescribe().getName() == 'Environment__c'){
                cvRec = new ContentVersion();
                cvRec.VersionData = attachmentRec.Body;
                cvRec.firstPublishLocationId = attachmentRec.ParentId;
                cvRec.OwnerId = attachmentRec.OwnerId;
                cvRec.PathOnClient = attachmentRec.Name;
                cvList.add(cvRec);
                attachmentListDel.add(attachmentRec);
            }
        }
        if(cvList != null && !cvList.isEmpty()){
            insert cvList;
        }
        if(deleteAttachments && attachmentListDel != null && !attachmentListDel.isEmpty()){
            delete attachmentListDel;
        }   
    }

}