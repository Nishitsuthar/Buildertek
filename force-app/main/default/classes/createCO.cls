public class createCO {
    @AuraEnabled
    public static String changeOrderList(buildertek__Change_Order__c cOrder , String optionId) {
		//Product2 prd=new Product2();
     //   prd=[select Id,Name,buildertek__Manufacturer__c from Product2 LIMIT 1];
      //  System.debug('prd------>'+prd);
        buildertek__Question__c optionList = new buildertek__Question__c();
        optionList = [Select id , Name, buildertek__Quantity__c,buildertek__Change_Order__c,buildertek__Purchase_Order__c ,buildertek__Upgrade_Costs__c ,buildertek__Manufacturer__c,buildertek__Question_Group__r.buildertek__Section__r.buildertek__Selection__r.buildertek__Project__c,buildertek__Product__r.buildertek__Manufacturer__c From buildertek__Question__c where Id =: optionId];
		System.debug('optionList--->'+optionList);
        if(String.isBlank(cOrder.Name)){
            cOrder.Name=optionList.Name;
        }
        
        cOrder.buildertek__Date_Created__c=Date.Today();
        cOrder.buildertek__Customer_Account__c= optionList.buildertek__Manufacturer__c;
        cOrder.buildertek__Purchase_Order__c=optionList.buildertek__Purchase_Order__c;
        cOrder.buildertek__Project__c=optionList.buildertek__Question_Group__r.buildertek__Section__r.buildertek__Selection__r.buildertek__Project__c;
        cOrder.buildertek__Status__c='Pending';
        cOrder.buildertek__Type__c='Customer';  
        cOrder.buildertek__Vendor__c=optionList.buildertek__Product__r.buildertek__Manufacturer__c;
        System.debug('Product Account --->'+optionList.buildertek__Product__r.buildertek__Manufacturer__c);
        System.debug('Vendor----->'+cOrder.buildertek__Vendor__c);
        insert cOrder;        
        System.debug('CODER---->>'+cOrder);      

        buildertek__Change_Order_Item__c orderLine = new buildertek__Change_Order_Item__c();
        orderLine.Name=optionList.Name;
        orderLine.buildertek__Quantity__c=optionList.buildertek__Quantity__c ;
        orderLine.buildertek__Unit_Price__c=optionList.buildertek__Upgrade_Costs__c;
        orderLine.buildertek__Change_Order__c=cOrder.Id;
        
        insert orderLine;
        optionList.buildertek__Change_Order__c=cOrder.Id;
        update optionList;
        // if(orderLine.size()>0){
        //     insert orderLine;
        // }
        return cOrder.Id;
    }

 
}