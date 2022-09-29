public with sharing class Create_PO_From_Selection {

    @AuraEnabled
    public static string createPO(String recordId) {
        try {
            buildertek__Question_Group__c option = [SELECT Id, Name FROM buildertek__Question_Group__c WHERE Id =: recordId];

            List<buildertek__Question__c> questionList = [SELECT Id, Name FROM buildertek__Question__c WHERE buildertek__Question_Group__c =: recordId];

            for (buildertek__Question__c question : questionList) {
                if (question.buildertek__Selected__c == true) {
                    
                }
            }

            buildertek__Purchase_Order__c po = new buildertek__Purchase_Order__c();

            insert po;

            buildertek__Purchase_Order_Item__c poItem = new buildertek__Purchase_Order_Item__c();
            poItem.buildertek__Purchase_Order__c = po.Id;
            
            insert poItem;

            return po.Id;
        } catch (Exception e) {
            System.debug('Error => '+e.getMessage());
            return 'Error';
        }
    }
}