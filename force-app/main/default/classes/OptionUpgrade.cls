public with sharing class OptionUpgrade {

    @AuraEnabled
    public static optionWrapper getDetails(String recordId, Integer pageNumber, Integer pageSize, String searchNameValue, String searchTypeValue, String searchManufacturerValue, String searchFamilyValue) {
        buildertek__Question__c option = [SELECT Id, Name, buildertek__Question_Group__c, buildertek__Product__c, buildertek__Product__r.Name, buildertek__Manufacturer__c, buildertek__Manufacturer__r.Name, 
                                            buildertek__Section__c, buildertek__Cost__c, buildertek__Upgrade_Costs__c, buildertek__Total_Sales_Price__c, buildertek__Price_Book__c, 
                                            buildertek__Question_Group__r.buildertek__Section__r.buildertek__Selection__r.buildertek__Project__r.buildertek__Price_Book__c FROM buildertek__Question__c WHERE Id =: recordId];
        List<Product2> productList = new List<Product2>();

        Integer offset = (pageNumber - 1) * pageSize;

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
                queryList = queryList + ' AND Family LIKE \'' + searchFamilyValue + '%\'';
            }
            if (searchNameValue == '' && searchTypeValue == '' && searchManufacturerValue == '' && searchFamilyValue == '') {
                queryList = queryList + ' LIMIT ' + pageSize + ' OFFSET ' + offset;
            }
            
            productList = Database.query(queryList);
        }

        Set<ID> productsIds = new Set<ID>();
        for (Product2 product : productList) {
            productsIds.add(product.Id);
        }

        List<ContentDocumentLink> contentLinkList = new List<ContentDocumentLink>();
        if (productsIds.size() > 0) {
            contentLinkList = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: productsIds];
        }

        String query = 'Select COUNT() FROM Product2 WHERE buildertek__Selection_Category_Lookup__c =: sectionId';
        Integer productCount = Database.countQuery(query);

        Map<String, String> priceBookMap = new Map<String, String>();
        list<pricebook2> PriceList = [SELECT Id, Name FROM pricebook2 ORDER BY Name ASC ];
        for (pricebook2 p : PriceList){
            priceBookMap.put(p.Name, p.Id);
        }

        optionWrapper optionWrapperData = new optionWrapper();
        optionWrapperData.option = option;
        optionWrapperData.projectPriceBook = option.buildertek__Question_Group__r.buildertek__Section__r.buildertek__Selection__r.buildertek__Project__r.buildertek__Price_Book__c;
        optionWrapperData.productCount = productCount;
        optionWrapperData.priceBookMap = priceBookMap;


        List<productWrapper> prodWrapperList = new List<productWrapper>();
        for (Product2 product : productList) {
            productWrapper prodWrapper = new productWrapper();
            prodWrapper.product = product;
            List<ContentDocumentLink> contentDocs = new List<ContentDocumentLink>();
            for (ContentDocumentLink content : contentLinkList) {
                if (content.LinkedEntityId == product.Id) {
                    contentDocs.add(content);
                }
            }
            prodWrapper.contentDocsList = contentDocs;
            prodWrapperList.add(prodWrapper);
        }
        optionWrapperData.productWrapperList = prodWrapperList;
        return optionWrapperData;
    }

    @AuraEnabled
    public static String upgradeOption(buildertek__Question__c optionValue, Product2 productValue){

        buildertek__Question__c newOption  = optionValue.clone();
        newOption.buildertek__Product__c = productValue.Id;
        newOption.buildertek__Manufacturer__c = productValue.buildertek__Manufacturer__c;
        newOption.buildertek__Selected__c = true;
        newOption.buildertek__Upgrade__c = true;
        newOption.buildertek__Date_Option_Upgraded__c = System.Today();
        newOption.buildertek__Original_Option__c = optionValue.Id;
        newOption.buildertek__Question_Group__c = optionValue.buildertek__Question_Group__c;
        insert newOption;

        optionValue.buildertek__Selected__c = false;
        update optionValue;

        return newOption.Id;
    }

    public class optionWrapper{
        @AuraEnabled
        public buildertek__Question__c option {get;set;}

        @AuraEnabled
        public String projectPriceBook {get;set;}

        @AuraEnabled
        public Integer productCount {get;set;}

        @AuraEnabled
        public Map<String, String> priceBookMap {get;set;}

        @AuraEnabled
        public List<productWrapper> productWrapperList {get;set;}
    }

    public class productWrapper{
        @AuraEnabled
        public Product2 product {get;set;}
        
        @AuraEnabled
        public List<ContentDocumentLink> contentDocsList {get;set;}
    }

}