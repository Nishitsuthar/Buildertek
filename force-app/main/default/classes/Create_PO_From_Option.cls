public with sharing class Create_PO_From_Option {

    @AuraEnabled
    public static string createPO(String recordId) {
        try {
            
            return null;
        } catch (Exception e) {
            System.debug('Error => '+e.getMessage());
            return null;
        }
    }
}