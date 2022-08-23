public class ViewInvoiceForInvoiceAPController {
    @AuraEnabled
    public Static List<EmailTemplate> getTemplates(){
        List<Emailtemplate> temrec;
        if (Schema.sObjectType.Emailtemplate.fields.Id.isAccessible() && Schema.sObjectType.Emailtemplate.fields.Name.isAccessible() && Schema.sObjectType.Emailtemplate.fields.folderid.isAccessible() && Schema.sObjectType.Folder.fields.Name.isAccessible()){
            temrec = [Select Id, Name, folder.name
                      from Emailtemplate
                      where folder.name = 'Invoices AP']; /* and Name !=:'Invoice3' */
        }
        return temrec; 
    }
    
    @AuraEnabled
    public static string getInvoiceLines(String recordId, String templateId){
        
         List<buildertek__BT_Payment_App_Sign_Url__c> paymentAppSignUrl = [select Name__c, buildertek__Site_Url__c from buildertek__BT_Payment_App_Sign_Url__c limit 1];
        
        system.debug('recId'+recordId);
         system.debug('templateId'+templateId);
        
        PageReference pagePdf = new PageReference(paymentAppSignUrl[0].buildertek__Site_Url__c+'/apex/BT_Invoice');
        if(paymentAppSignUrl[0].buildertek__Site_Url__c != null || paymentAppSignUrl[0].buildertek__Site_Url__c != 'undefined'){
        String url = paymentAppSignUrl[0].buildertek__Site_Url__c;
        return url ;
                                   }
        //pagePdf.getParameters().put('recId', recordId);
       // pagePdf.getParameters().put('tempId', templateId);
        
        return null;
    }

}