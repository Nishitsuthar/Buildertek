public with sharing class OptionUpgrade {

    @AuraEnabled
    public static List<Product2> getDetails(String recordId, String searchNameValue, String searchTypeValue, String searchManufacturerValue, String searchFamilyValue) {
        buildertek__Question__c option = [SELECT Id, Name, buildertek__Product__c, buildertek__Section__c FROM buildertek__Question__c WHERE Id =: recordId];
        List<Product2> productList = new List<Product2>();
        if (option.buildertek__Section__c != null) {
            String sectionId = option.buildertek__Section__c;
            String queryList = 'SELECT Id, Name, buildertek__Selection_Category_Lookup__c, buildertek__Product_Type__r.Name, buildertek__Manufacturer__r.Name, Family, buildertek__Category__r.Name, (SELECT Id, Name, UnitPrice FROM PricebookEntries) FROM Product2 WHERE buildertek__Selection_Category_Lookup__c =: sectionId';
            
            if (searchNameValue != null && searchNameValue != '') {
                queryList = queryList + ' AND Name LIKE \'' + searchNameValue + '%\'';
            }
    
            if (searchTypeValue != null && searchTypeValue != '') {
                queryList = queryList + ' AND buildertek__Product_Type__r.Name LIKE \'' + searchTypeValue + '%\'';
            }
    
            if (searchManufacturerValue != null && searchManufacturerValue != '') {
                queryList = queryList + ' AND buildertek__Manufacturer__r.Name LIKE \'' + searchManufacturerValue + '%\'';
            }
    
            if (searchFamilyValue != null && searchFamilyValue != '') {
                queryList = queryList + ' AND buildertek__Category__r.Name LIKE \'' + searchFamilyValue + '%\'';
            }
            
            productList = Database.query(queryList);
        }
        return productList;
    }

}