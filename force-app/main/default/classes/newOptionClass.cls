public class newOptionClass {
    @AuraEnabled
    public static String createoption(String optionId){
        Pricebook2 price=new Pricebook2();
        Product2 prd=new Product2();
        buildertek__Question__c opt=new buildertek__Question__c();
        opt=[select id, Name, buildertek__Price_Book__c, buildertek__Product__c, buildertek__Quantity__c, buildertek__Cost__c, buildertek__Markup__c, buildertek__Upgrade_Costs__c, buildertek__Question_Group__c, buildertek__Manufacturer__c, buildertek__Selected__c, buildertek__Default_Option__c, buildertek__Upgrade__c, buildertek__Date_Option_Upgraded__c, buildertek__Original_Option__c, buildertek__Purchase_Order__c, buildertek__Purchase_Order_Line__c, buildertek__Change_Order__c, buildertek__Change_Order_Line__c from buildertek__Question__c where Id =: optionId];
        
        opt.buildertek__Price_Book__c=price.Name;
        opt.buildertek__Product__c=prd.Name;
        return 'test';
    }
}