public class newOptionClass {
    @AuraEnabled
    public static String createoption(buildertek__Question__c option){
        // List<buildertek__Question__c> opt=new List<buildertek__Question__c>();
        // opt=[select id, Name, buildertek__Price_Book__c, 
        //         buildertek__Product__c, buildertek__Quantity__c, 
        //         buildertek__Cost__c, buildertek__Markup__c, 
        //         buildertek__Upgrade_Costs__c, buildertek__Question_Group__c, 
        //         buildertek__Manufacturer__c, buildertek__Selected__c, 
        //         buildertek__Default_Option__c, buildertek__Upgrade__c, 
        //         buildertek__Date_Option_Upgraded__c, buildertek__Original_Option__c,
        //         buildertek__Purchase_Order__c, buildertek__Purchase_Order_Line__c, 
        //         buildertek__Change_Order__c, buildertek__Change_Order_Line__c from buildertek__Question__c where Id =: option];

        //         for (buildertek__Question__c option1 : opt){
        //             if(option1.Name==null){
        //                 option1.Name=option1.buildertek__Product__c;
        //             }
        //         }

        // insert opt;
        // return 'test';

    //     Set<Id> st=new Set<Id>();
    //     Map<Id,buildertek__Question__c> optMap=new Map<Id,buildertek__Question__c>([select Id,Name from buildertek__Question__c where Id =: st]);
    //    // List<buildertek__Question__c> opList=new List<buildertek__Question__c>();
    //     for(buildertek__Question__c op:option){
    //         if(op.name==null){
    //             if(optMap.containsKey(op.buildertek__Product__c)){
    //                 op.Name=optMap.get(op.buildertek__Product__c).Name;
    //             }
    //         }
    //     }
    
    Set<Id> st=new Set<Id>();
    String q='select id,name from buildertek__Question__c where id =: st';
    // List<sObject> sObjectList = Database.query(q);

        insert option;
        return option.Id;
    }

    @AuraEnabled
    public static Product2 getProduct(String productId){
        Product2 prod = [SELECT Id, Name, buildertek__Manufacturer__c FROM Product2 WHERE Id =: productId];
        return prod;
    }
    
}