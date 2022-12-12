public without sharing class NewPRLineDetails {
    @AuraEnabled
    public static String createPRLineDetails(buildertek__Pricing_Request_Line_Details__c PRLineDetails) {
        System.debug('in method calling');
        insert PRLineDetails;
        return PRLineDetails.Id;
    }

    @AuraEnabled
    public static List<Product2> getProductDetails(Id priceBookId){
        System.debug('getProductDetails');
        List<PricebookEntry> pbEntryList = [SELECT Id, Name, Product2Id, Product2.Name FROM PricebookEntry WHERE Pricebook2Id =: priceBookId];
        System.debug('pbEntryList ==> '+pbEntryList);
        List<Product2> productList = new List<Product2>();
        for (PricebookEntry pbEntry : pbEntryList) {
            System.debug('pbEntry --> '+pbEntry);
            Product2 product = new Product2();
            product.Id = pbEntry.Product2Id;
            product.Name = pbEntry.Product2.Name;
            System.debug('product ==> '+product);
            productList.add(product);
        }
        System.debug('productList ===>'+productList);
        return productList;
    }
}