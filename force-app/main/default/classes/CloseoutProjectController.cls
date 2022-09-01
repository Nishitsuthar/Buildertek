public with sharing class CloseoutProjectController {
    @AuraEnabled
    public static string getInvoiceLines(String recordId, String templateId){
        Contact con = [SELECT id, Email FROM Contact WHERE email != null ORDER BY createddate DESC LIMIT 1];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(templateId);
        email.setWhatId(recordId);
        email.setTargetObjectId(con.Id);
        email.setSaveAsActivity(false);
        email.setToAddresses(new String[]{con.email});

        Savepoint sp = Database.setSavepoint();
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        Database.rollback(sp);

        string templateBody = email.getHTMLBody();
        return templateBody;
    }

    @AuraEnabled
    public static List<buildertek__Billings__c> getInvoice(String recordId){
        List<buildertek__Billings__c> invoiceList = [SELECT Id, Name FROM buildertek__Billings__c WHERE buildertek__Project__c =: recordId];
        return invoiceList;
    }

    @AuraEnabled
    public static void createInvoice(String recordId){
        buildertek__Billings__c AR = new buildertek__Billings__c();
        AR.Name = 'Closeout-Project-Invoice';
        AR.Project__c = recordId;
		// insert AR;
    }
}