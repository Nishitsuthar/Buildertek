public with sharing class ImportMasterPunchLine {
    
    @AuraEnabled
    public static List<buildertek__Punch_List__c> getMasterPL() {
        List<buildertek__Punch_List__c> masterPLList = new List<buildertek__Punch_List__c>();
        try {
            masterPLList = [SELECT Id, Name, buildertek__Description__c, buildertek__Project__c, buildertek__Project__r.Name, buildertek__Type__c FROM buildertek__Punch_List__c WHERE buildertek__Type__c = 'Master'];

            return masterPLList;
        } catch (Exception e) {
            System.debug(e);
            System.debug('Line Number ==>'+ e.getLineNumber());
            System.debug('Message ===>'+ e.getMessage() + ' <==>'+ e.getStackTraceString());
            return null;
        }
    }
}