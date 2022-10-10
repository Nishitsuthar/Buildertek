public class createCO {
    @AuraEnabled
    public static String changeOrderList(buildertek__Change_Order__c cOrder , Id optionId) {
       

        buildertek__Question__c optionList = new buildertek__Question__c();
        optionList = [Select id , Name, buildertek__Quantity__c  ,  buildertek__Manufacturer__c   From buildertek__Question__c where Id =: optionId];

        cOrder.buildertek__Date_Created__c=Date.Today();
        cOrder.buildertek__Customer_Account__c= optionList.buildertek__Manufacturer__c;
        insert cOrder;

        buildertek__Change_Order_Item__c orderLine = new buildertek__Change_Order_Item__c();
        orderLine.Name=optionList.Name;
        orderLine.buildertek__Quantity__c=optionList.buildertek__Quantity__c ;
        orderLine.buildertek__Change_Order__c=cOrder.Id;
        insert orderLine;

      

        return cOrder.Id;
    }

 
}