public with sharing class Create_Sales_Order_Btn {
    @AuraEnabled
    public static string createSalesOrder(String recordId) {
        try {
            
            return 'Success';
        } catch (Exception e) {
            System.debug('Error => '+e.getMessage());
            return 'Error';
        }
    }
}