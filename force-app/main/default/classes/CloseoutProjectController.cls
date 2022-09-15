public with sharing class CloseoutProjectController {
    @AuraEnabled
    public static void createInvoice(String recordId){
        string mainAR = '';
        buildertek__Billings__c oldAR = [SELECT Id, Name FROM buildertek__Billings__c WHERE Project__c =: recordId AND Name =: 'Closeout-Project-Invoice' LIMIT 1];
        if (oldAR == null) {
            buildertek__Billings__c AR = new buildertek__Billings__c();
            AR.Name = 'Closeout-Project-Invoice';
            AR.Project__c = recordId;
            insert AR;
            mainAR = AR.Id;
        } else {
            mainAR = oldAR.Id;
        }

        EmailTemplate eTemp = [SELECT Id, Name FROM EmailTemplate WHERE Name =: 'Invoice (AR) w/ Change Orders' LIMIT 1];
        Contact con = [SELECT id, Email FROM Contact WHERE email != null ORDER BY createddate DESC LIMIT 1];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(eTemp.Id);
        email.setWhatId(mainAR);
        email.setTargetObjectId(con.Id);
        email.setSaveAsActivity(false);
        email.setToAddresses(new String[]{con.email});

        Savepoint sp = Database.setSavepoint();
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        Database.rollback(sp);

        string templateBody = email.getHTMLBody();
        // return templateBody;
    }
}