public class OrderPOFromProjectController {
    @AuraEnabled
    public static object getMasterBudgets(String recId){
        
        map<String , List<buildertek__Purchase_Order__c>> GroupingMap = new map<String , List<buildertek__Purchase_Order__c>>(); 
        
        List<MasterBudgetsClass> MasterBudgetsClassList = new List<MasterBudgetsClass>();
        
        List<buildertek__Purchase_Order__c> nullspoRecList;
        
        List<buildertek__Purchase_Order__c> MainpoRecList = new List<buildertek__Purchase_Order__c>();
        
        If(Schema.sObjectType.buildertek__Purchase_Order__c.fields.Name.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Phase__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Vendor__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Status__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Description__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__PO_Total__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Paid_Amount__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Change_Order__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Date_Ordered__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__PO_Balance__c.isAccessible()){ 
               MainpoRecList = [SELECT Id,
                                Name, 
                                buildertek__Type__c,
                                toLabel(buildertek__Phase__c),
                                buildertek__Vendor__c,
                                buildertek__Vendor__r.Name,
                                buildertek__Vendor__r.buildertek__Email_Address__c,
                                buildertek__Status__c,
                                buildertek__Description__c,
                                buildertek__Change_Order__c,
                                buildertek__Change_Order__r.Name,
                                buildertek__PO_Total__c,
                                buildertek__Paid_Amount__c,
                                buildertek__PO_Balance__c,
                                buildertek__Date_Ordered__c,
                                buildertek__Project__c
                                FROM buildertek__Purchase_Order__c Where buildertek__Project__c =: recId AND buildertek__Phase__c != ''  ORDER BY buildertek__Phase__c  ASC NULLS last, Name DESC, buildertek__Status__c ASC];    
           }
        
        
        If(Schema.sObjectType.buildertek__Purchase_Order__c.fields.Name.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Phase__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Vendor__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Status__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Description__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__PO_Total__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Paid_Amount__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Date_Ordered__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__Change_Order__c.isAccessible() &&
           Schema.sObjectType.buildertek__Purchase_Order__c.fields.buildertek__PO_Balance__c.isAccessible()){ 
               nullspoRecList = [SELECT Id,
                                 Name, 
                                 buildertek__Type__c,
                                 toLabel(buildertek__Phase__c),
                                 buildertek__Vendor__c,
                                 buildertek__Vendor__r.Name,
                                 buildertek__Vendor__r.buildertek__Email_Address__c,
                                 buildertek__Change_Order__c,
                                 buildertek__Change_Order__r.Name,
                                 buildertek__Status__c,
                                 buildertek__Description__c,
                                 buildertek__PO_Total__c,
                                 buildertek__Paid_Amount__c,
                                 buildertek__PO_Balance__c,
                                 buildertek__Date_Ordered__c,
                                 buildertek__Project__c
                                 FROM buildertek__Purchase_Order__c Where buildertek__Project__c =: recId AND buildertek__Phase__c = ''  ORDER BY buildertek__Phase__c  ASC NULLS last, Name DESC, buildertek__Status__c ASC];    
           }
        
        if(nullspoRecList.size()>0){
            MainpoRecList.addAll(nullspoRecList);
        }
        
        for(buildertek__Purchase_Order__c POrec : MainpoRecList){
            if(GroupingMap.get(POrec.buildertek__Phase__c) == null){
                GroupingMap.put(POrec.buildertek__Phase__c , new List<buildertek__Purchase_Order__c>());
            }
            GroupingMap.get(POrec.buildertek__Phase__c).add(POrec);
        }
        
        
        for(String PO : GroupingMap.keySet()){
            MasterBudgetsClass MasterBudgetsClassRecord = new MasterBudgetsClass(); 
            MasterBudgetsClassRecord.groupName = PO;
            MasterBudgetsClassRecord.poCheck = false;
            MasterBudgetsClassRecord.poRecordList = GroupingMap.get(PO);
            List<POInnerClass> POInnerClassList = new List<POInnerClass>();
            for(buildertek__Purchase_Order__c PO1 : GroupingMap.get(PO)){
                POInnerClass POInnerClassRecord = new POInnerClass();
                POInnerClassRecord.poCheck = false;
                POInnerClassRecord.poRecord = PO1;
                POInnerClassList.add(POInnerClassRecord); 
            }
            MasterBudgetsClassRecord.poRecInner = POInnerClassList;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        
        return  MasterBudgetsClassList;   
    }
    
    public class MasterBudgetsClass{
        
        @AuraEnabled
        public buildertek__Purchase_Order__c poRecord {get;set;}
        
        
        @AuraEnabled
        public boolean poCheck {get;set;}
        
        @AuraEnabled
        public String groupName {get;set;}
        
        @AuraEnabled
        public List<buildertek__Purchase_Order__c> poRecordList {get;set;}
        
        @AuraEnabled
        public List<POInnerClass> poRecInner {get;set;}
        
    }
    
    
    public class POInnerClass{
        @AuraEnabled
        public boolean poCheck {get;set;}
        
        @AuraEnabled
        public buildertek__Purchase_Order__c poRecord {get;set;}
    }
    
    
    @AuraEnabled
    public static object findByName(String searchKey , string recId) {
        map<String , List<buildertek__Purchase_Order__c>> GroupingMap = new map<String , List<buildertek__Purchase_Order__c>>(); 
        List<MasterBudgetsClass> MasterBudgetsClassList = new List<MasterBudgetsClass>();
        
        List<buildertek__Purchase_Order__c> nullspoRecList;
        
        List<buildertek__Purchase_Order__c> MainpoRecList = new List<buildertek__Purchase_Order__c>();
        
        String  name =  + searchKey + '%'; 
        if(name != null){
            MainpoRecList = [SELECT Id,
                             Name,
                             buildertek__Type__c,
                             toLabel(buildertek__Phase__c),
                             buildertek__Vendor__c,
                             buildertek__Vendor__r.Name,
                             buildertek__Vendor__r.buildertek__Email_Address__c,
                             buildertek__Change_Order__c,
                             buildertek__Change_Order__r.Name,
                             buildertek__Status__c,
                             buildertek__Description__c,
                             buildertek__PO_Total__c,
                             buildertek__Paid_Amount__c,
                             buildertek__PO_Balance__c,
                             buildertek__Date_Ordered__c
                             FROM buildertek__Purchase_Order__c
                             WHERE  buildertek__Vendor__r.Name LIKE :name AND buildertek__Project__c =: recId AND buildertek__Phase__c != '' ORDER BY buildertek__Phase__c ASC NULLS last]; 
        }
        
        if(name != null){
            nullspoRecList = [SELECT Id,
                              Name,
                              buildertek__Type__c,
                              toLabel(buildertek__Phase__c),
                              buildertek__Vendor__c,
                              buildertek__Vendor__r.Name,
                              buildertek__Vendor__r.buildertek__Email_Address__c,
                              buildertek__Change_Order__c,
                              buildertek__Change_Order__r.Name,
                              buildertek__Status__c,
                              buildertek__Description__c,
                              buildertek__PO_Total__c,
                              buildertek__Paid_Amount__c,
                              buildertek__PO_Balance__c,
                              buildertek__Date_Ordered__c
                              FROM buildertek__Purchase_Order__c
                              WHERE  buildertek__Vendor__r.Name LIKE :name AND buildertek__Project__c =: recId  AND buildertek__Phase__c = '' ORDER BY buildertek__Phase__c ASC NULLS last]; 
        }
        
        if(nullspoRecList.size()>0){
            MainpoRecList.addAll(nullspoRecList);
        }
        
        for(buildertek__Purchase_Order__c POrec : MainpoRecList){
            if(GroupingMap.get(POrec.buildertek__Phase__c) == null){
                GroupingMap.put(POrec.buildertek__Phase__c , new List<buildertek__Purchase_Order__c>());
            }
            GroupingMap.get(POrec.buildertek__Phase__c).add(POrec);
        }
        
        
        for(String PO : GroupingMap.keySet()){
            MasterBudgetsClass MasterBudgetsClassRecord = new MasterBudgetsClass(); 
            MasterBudgetsClassRecord.groupName = PO;
            MasterBudgetsClassRecord.poCheck = false;
            MasterBudgetsClassRecord.poRecordList = GroupingMap.get(PO);
            List<POInnerClass> POInnerClassList = new List<POInnerClass>();
            for(buildertek__Purchase_Order__c PO1 : GroupingMap.get(PO)){
                POInnerClass POInnerClassRecord = new POInnerClass();
                POInnerClassRecord.poCheck = false;
                POInnerClassRecord.poRecord = PO1;
                POInnerClassList.add(POInnerClassRecord); 
            }
            MasterBudgetsClassRecord.poRecInner = POInnerClassList;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
  
        return  MasterBudgetsClassList;  
    }
    
    @AuraEnabled
    public static object findByName1(String searchKey , string recId) {
        map<String , List<buildertek__Purchase_Order__c>> GroupingMap = new map<String , List<buildertek__Purchase_Order__c>>(); 
        List<MasterBudgetsClass> MasterBudgetsClassList = new List<MasterBudgetsClass>();
        
        List<buildertek__Purchase_Order__c> nullspoRecList;
        
        List<buildertek__Purchase_Order__c> MainpoRecList = new List<buildertek__Purchase_Order__c>();
        
        String  name = '%' + searchKey + '%'; 
        if(name != null){
            MainpoRecList = [SELECT Id,
                             Name,
                             buildertek__Type__c,
                             toLabel(buildertek__Phase__c),
                             buildertek__Vendor__c,
                             buildertek__Vendor__r.Name,
                             buildertek__Vendor__r.buildertek__Email_Address__c,
                             buildertek__Change_Order__c,
                             buildertek__Change_Order__r.Name,
                             buildertek__Status__c,
                             buildertek__Description__c,
                             buildertek__PO_Total__c,
                             buildertek__Paid_Amount__c,
                             buildertek__PO_Balance__c,
                             buildertek__Date_Ordered__c
                             FROM buildertek__Purchase_Order__c
                             WHERE  buildertek__Phase__c LIKE :name AND buildertek__Project__c =: recId AND buildertek__Phase__c != '' ORDER BY buildertek__Phase__c ASC NULLS last];
        } 
        
        if(name != null){
            nullspoRecList = [SELECT Id,
                              Name,
                              buildertek__Type__c,
                              toLabel(buildertek__Phase__c),
                              buildertek__Vendor__c,
                              buildertek__Vendor__r.Name,
                              buildertek__Vendor__r.buildertek__Email_Address__c,
                              buildertek__Change_Order__c,
                              buildertek__Change_Order__r.Name,
                              buildertek__Status__c,
                              buildertek__Description__c,
                              buildertek__PO_Total__c,
                              buildertek__Paid_Amount__c,
                              buildertek__PO_Balance__c,
                              buildertek__Date_Ordered__c
                              FROM buildertek__Purchase_Order__c
                              WHERE  buildertek__Phase__c LIKE :name AND buildertek__Project__c =: recId AND buildertek__Phase__c = '' ORDER BY buildertek__Phase__c ASC NULLS last];
        }
        
        if(nullspoRecList.size()>0){
            MainpoRecList.addAll(nullspoRecList);
        }
        
        for(buildertek__Purchase_Order__c POrec : MainpoRecList){
            if(GroupingMap.get(POrec.buildertek__Phase__c) == null){
                GroupingMap.put(POrec.buildertek__Phase__c , new List<buildertek__Purchase_Order__c>());
            }
            GroupingMap.get(POrec.buildertek__Phase__c).add(POrec);
        }
        
        
        for(String PO : GroupingMap.keySet()){
            MasterBudgetsClass MasterBudgetsClassRecord = new MasterBudgetsClass(); 
            MasterBudgetsClassRecord.groupName = PO;
            MasterBudgetsClassRecord.poCheck = false;
            MasterBudgetsClassRecord.poRecordList = GroupingMap.get(PO);
            List<POInnerClass> POInnerClassList = new List<POInnerClass>();
            for(buildertek__Purchase_Order__c PO1 : GroupingMap.get(PO)){
                POInnerClass POInnerClassRecord = new POInnerClass();
                POInnerClassRecord.poCheck = false;
                POInnerClassRecord.poRecord = PO1;
                POInnerClassList.add(POInnerClassRecord); 
            }
            MasterBudgetsClassRecord.poRecInner = POInnerClassList;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        
        
        return  MasterBudgetsClassList;  
    }
    
    @AuraEnabled
    public static object findByName2(String searchKey , string recId) {
        map<String , List<buildertek__Purchase_Order__c>> GroupingMap = new map<String , List<buildertek__Purchase_Order__c>>(); 
        List<MasterBudgetsClass> MasterBudgetsClassList = new List<MasterBudgetsClass>();
        
        List<buildertek__Purchase_Order__c> nullspoRecList;
        
        List<buildertek__Purchase_Order__c> MainpoRecList = new List<buildertek__Purchase_Order__c>();
        
        String  name =  + searchKey + '%'; 
        if(name != null){
            MainpoRecList = [SELECT Id,
                             Name,
                             buildertek__Type__c,
                             toLabel(buildertek__Phase__c),
                             buildertek__Vendor__c,
                             buildertek__Vendor__r.Name,
                             buildertek__Vendor__r.buildertek__Email_Address__c,
                             buildertek__Change_Order__c,
                             buildertek__Change_Order__r.Name,
                             buildertek__Status__c,
                             buildertek__Description__c,
                             buildertek__PO_Total__c,
                             buildertek__Paid_Amount__c,
                             buildertek__PO_Balance__c,
                             buildertek__Date_Ordered__c
                             FROM buildertek__Purchase_Order__c
                             WHERE  buildertek__Status__c LIKE :name AND buildertek__Project__c =: recId AND buildertek__Phase__c != '' ORDER BY buildertek__Phase__c ASC NULLS last];
        }
        
        if(name != null){
            nullspoRecList = [SELECT Id,
                              Name,
                              buildertek__Type__c,
                              toLabel(buildertek__Phase__c),
                              buildertek__Vendor__c,
                              buildertek__Vendor__r.Name,
                              buildertek__Vendor__r.buildertek__Email_Address__c,
                              buildertek__Change_Order__c,
                              buildertek__Change_Order__r.Name,
                              buildertek__Status__c,
                              buildertek__Description__c,
                              buildertek__PO_Total__c,
                              buildertek__Paid_Amount__c,
                              buildertek__PO_Balance__c,
                              buildertek__Date_Ordered__c
                              FROM buildertek__Purchase_Order__c
                              WHERE  buildertek__Status__c LIKE :name AND buildertek__Project__c =: recId AND buildertek__Phase__c = '' ORDER BY buildertek__Phase__c ASC NULLS last];
        }
        
        if(nullspoRecList.size()>0){
            MainpoRecList.addAll(nullspoRecList);
        }
        
        for(buildertek__Purchase_Order__c POrec : MainpoRecList){
            if(GroupingMap.get(POrec.buildertek__Phase__c) == null){
                GroupingMap.put(POrec.buildertek__Phase__c , new List<buildertek__Purchase_Order__c>());
            }
            GroupingMap.get(POrec.buildertek__Phase__c).add(POrec);
        }
        
        
        for(String PO : GroupingMap.keySet()){
            MasterBudgetsClass MasterBudgetsClassRecord = new MasterBudgetsClass(); 
            MasterBudgetsClassRecord.groupName = PO;
            MasterBudgetsClassRecord.poCheck = false;
            MasterBudgetsClassRecord.poRecordList = GroupingMap.get(PO);
            List<POInnerClass> POInnerClassList = new List<POInnerClass>();
            for(buildertek__Purchase_Order__c PO1 : GroupingMap.get(PO)){
                POInnerClass POInnerClassRecord = new POInnerClass();
                POInnerClassRecord.poCheck = false;
                POInnerClassRecord.poRecord = PO1;
                POInnerClassList.add(POInnerClassRecord); 
            }
            MasterBudgetsClassRecord.poRecInner = POInnerClassList;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        
        
        return  MasterBudgetsClassList;  
    }
    
    
    @AuraEnabled
    public static object findByName3(String searchKey , string recId) {
        map<String , List<buildertek__Purchase_Order__c>> GroupingMap = new map<String , List<buildertek__Purchase_Order__c>>(); 
        List<MasterBudgetsClass> MasterBudgetsClassList = new List<MasterBudgetsClass>();
        
        List<buildertek__Purchase_Order__c> nullspoRecList;
        
        List<buildertek__Purchase_Order__c> MainpoRecList = new List<buildertek__Purchase_Order__c>();
        
        String  name = '%' + searchKey + '%'; 
        if(name != null){
            MainpoRecList = [SELECT Id,
                             Name,
                             buildertek__Type__c,
                             toLabel(buildertek__Phase__c),
                             buildertek__Vendor__c,
                             buildertek__Vendor__r.Name,
                             buildertek__Vendor__r.buildertek__Email_Address__c,
                             buildertek__Change_Order__c,
                             buildertek__Change_Order__r.Name,
                             buildertek__Status__c,
                             buildertek__Description__c,
                             buildertek__PO_Total__c,
                             buildertek__Paid_Amount__c,
                             buildertek__PO_Balance__c,
                             buildertek__Date_Ordered__c
                             FROM buildertek__Purchase_Order__c
                             WHERE  Name LIKE : name AND buildertek__Project__c =: recId AND buildertek__Phase__c != '' ORDER BY buildertek__Phase__c ASC NULLS last];
        } 
        
        if(name != null){
            nullspoRecList = [SELECT Id,
                              Name,
                              buildertek__Type__c,
                              toLabel(buildertek__Phase__c),
                              buildertek__Vendor__c,
                              buildertek__Vendor__r.Name,
                              buildertek__Vendor__r.buildertek__Email_Address__c,
                              buildertek__Change_Order__c,
                              buildertek__Change_Order__r.Name,
                              buildertek__Status__c,
                              buildertek__Description__c,
                              buildertek__PO_Total__c,
                              buildertek__Paid_Amount__c,
                              buildertek__PO_Balance__c,
                              buildertek__Date_Ordered__c
                              FROM buildertek__Purchase_Order__c
                              WHERE  Name LIKE : name AND buildertek__Project__c =: recId AND buildertek__Phase__c = '' ORDER BY buildertek__Phase__c ASC NULLS last];
        } 
        
        
        if(nullspoRecList.size()>0){
            MainpoRecList.addAll(nullspoRecList);
        }
        
        for(buildertek__Purchase_Order__c POrec : MainpoRecList){
            if(GroupingMap.get(POrec.buildertek__Phase__c) == null){
                GroupingMap.put(POrec.buildertek__Phase__c , new List<buildertek__Purchase_Order__c>());
            }
            GroupingMap.get(POrec.buildertek__Phase__c).add(POrec);
        }
        
        
        for(String PO : GroupingMap.keySet()){
            MasterBudgetsClass MasterBudgetsClassRecord = new MasterBudgetsClass(); 
            MasterBudgetsClassRecord.groupName = PO;
            MasterBudgetsClassRecord.poCheck = false;
            MasterBudgetsClassRecord.poRecordList = GroupingMap.get(PO);
            List<POInnerClass> POInnerClassList = new List<POInnerClass>();
            for(buildertek__Purchase_Order__c PO1 : GroupingMap.get(PO)){
                POInnerClass POInnerClassRecord = new POInnerClass();
                POInnerClassRecord.poCheck = false;
                POInnerClassRecord.poRecord = PO1;
                POInnerClassList.add(POInnerClassRecord); 
            }
            MasterBudgetsClassRecord.poRecInner = POInnerClassList;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        
        
        return  MasterBudgetsClassList;  
    }
    
    @AuraEnabled
    public static object findByName4(String searchKey , string recId) {
        map<String , List<buildertek__Purchase_Order__c>> GroupingMap = new map<String , List<buildertek__Purchase_Order__c>>(); 
        List<MasterBudgetsClass> MasterBudgetsClassList = new List<MasterBudgetsClass>();
        
        List<buildertek__Purchase_Order__c> nullspoRecList;
        
        List<buildertek__Purchase_Order__c> MainpoRecList = new List<buildertek__Purchase_Order__c>();
        
        String  name = '%' + searchKey + '%'; 
        if(name != null){
            MainpoRecList = [SELECT Id,
                             Name,
                             buildertek__Type__c,
                             toLabel(buildertek__Phase__c),
                             buildertek__Vendor__c,
                             buildertek__Vendor__r.Name,
                             buildertek__Vendor__r.buildertek__Trade_Type_Lookup__r.Name,
                             buildertek__Vendor__r.buildertek__Email_Address__c,
                             buildertek__Change_Order__c,
                             buildertek__Change_Order__r.Name,
                             buildertek__Status__c,
                             buildertek__Description__c,
                             buildertek__PO_Total__c,
                             buildertek__Paid_Amount__c,
                             buildertek__PO_Balance__c,
                             buildertek__Date_Ordered__c
                             FROM buildertek__Purchase_Order__c
                             WHERE  buildertek__Vendor__r.buildertek__Trade_Type_Lookup__r.Name LIKE : name AND buildertek__Project__c =: recId AND buildertek__Phase__c != '' ORDER BY buildertek__Phase__c ASC NULLS last];
        } 
        
        if(name != null){
            nullspoRecList = [SELECT Id,
                              Name,
                              buildertek__Type__c,
                              toLabel(buildertek__Phase__c),
                              buildertek__Vendor__c,
                              buildertek__Vendor__r.Name,
                              buildertek__Vendor__r.buildertek__Trade_Type_Lookup__r.Name,
                              buildertek__Vendor__r.buildertek__Email_Address__c,
                              buildertek__Change_Order__c,
                              buildertek__Change_Order__r.Name,
                              buildertek__Status__c,
                              buildertek__Description__c,
                              buildertek__PO_Total__c,
                              buildertek__Paid_Amount__c,
                              buildertek__PO_Balance__c,
                              buildertek__Date_Ordered__c
                              FROM buildertek__Purchase_Order__c
                              WHERE  buildertek__Vendor__r.buildertek__Trade_Type_Lookup__r.Name LIKE : name AND buildertek__Project__c =: recId AND buildertek__Phase__c = '' ORDER BY buildertek__Phase__c ASC NULLS last];
        } 
        
        
        if(nullspoRecList.size()>0){
            MainpoRecList.addAll(nullspoRecList);
        }
        
        for(buildertek__Purchase_Order__c POrec : MainpoRecList){
            if(GroupingMap.get(POrec.buildertek__Phase__c) == null){
                GroupingMap.put(POrec.buildertek__Phase__c , new List<buildertek__Purchase_Order__c>());
            }
            GroupingMap.get(POrec.buildertek__Phase__c).add(POrec);
        }
        
        
        for(String PO : GroupingMap.keySet()){
            MasterBudgetsClass MasterBudgetsClassRecord = new MasterBudgetsClass(); 
            MasterBudgetsClassRecord.groupName = PO;
            MasterBudgetsClassRecord.poCheck = false;
            MasterBudgetsClassRecord.poRecordList = GroupingMap.get(PO);
            List<POInnerClass> POInnerClassList = new List<POInnerClass>();
            for(buildertek__Purchase_Order__c PO1 : GroupingMap.get(PO)){
                POInnerClass POInnerClassRecord = new POInnerClass();
                POInnerClassRecord.poCheck = false;
                POInnerClassRecord.poRecord = PO1;
                POInnerClassList.add(POInnerClassRecord); 
            }
            MasterBudgetsClassRecord.poRecInner = POInnerClassList;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        
        
        return  MasterBudgetsClassList;  
    }
    
    
    
    
    
    public class PoDetailsInnerClass{
        @AuraEnabled
        public Decimal totalPOAmount {get;set;}
        
        @AuraEnabled
        public integer totalPOs {get;set;}
        
        @AuraEnabled
        public decimal totalPaidAmount {get;set;}
        
        @AuraEnabled
        public decimal totalRemainingAmount {get;set;}
        
        @AuraEnabled
        public decimal orderedPercent {get;set;}
        
        @AuraEnabled
        public decimal paidPercent {get;set;}
    }
    
    
    @AuraEnabled
    public static PoDetailsInnerClass getPORecListDetails(String recId){
        
        Integer totalRecords = 0;
        decimal totalPaid = 0;
        Integer totalOrderedPos = 0;
        decimal orderedPercent = 0;
        Integer totalPaidPOs = 0;
        decimal paidPercent = 0;
        
        List<buildertek__Purchase_Order__c> poRecList = [select Id,
                                                         Name,
                                                         buildertek__Type__c,
                                                         buildertek__Phase__c,
                                                         buildertek__Vendor__c,
                                                         buildertek__Vendor__r.Name,
                                                         buildertek__Status__c,
                                                         buildertek__Description__c,
                                                         buildertek__PO_Total__c,
                                                         buildertek__Paid_Amount__c,
                                                         buildertek__PO_Balance__c,
                                                         buildertek__Project__c
                                                         FROM buildertek__Purchase_Order__c where buildertek__Project__c =: recId];
        
        
        totalRecords = [SELECT COUNT() FROM buildertek__Purchase_Order__c where buildertek__Project__c =: recId];
        
        AggregateResult result = [SELECT SUM(buildertek__PO_Total__c )totalPO, buildertek__Project__c FROM buildertek__Purchase_Order__c where buildertek__Project__c =: recId group by buildertek__Project__c];
        
        decimal totalPOAmount = (decimal)result.get('totalPO');
        
        AggregateResult result1 = [SELECT SUM(buildertek__PO_Balance__c)totalPOBalance, buildertek__Project__c FROM buildertek__Purchase_Order__c where buildertek__Project__c =: recId group by buildertek__Project__c];
        
        
        decimal totalPOBalance = (decimal)result1 .get('totalPOBalance');
        
        
        AggregateResult totalPaidPurchaseOrders  = [SELECT SUM(buildertek__Paid_Amount__c )totalPaid, buildertek__Status__c FROM buildertek__Purchase_Order__c where buildertek__Status__c = 'Paid' group by buildertek__Status__c ];
        
        totalPaid = (decimal)totalPaidPurchaseOrders.get('totalPaid');
        
        totalOrderedPOs = [SELECT COUNT() FROM buildertek__Purchase_Order__c where buildertek__Status__c = 'Ordered' AND  buildertek__Project__c =: recId];
        
        if(totalOrderedPOs > 0){
            orderedPercent = totalOrderedPOs;
        }
        
        
        totalPaidPOs = [SELECT COUNT() FROM buildertek__Purchase_Order__c where buildertek__Status__c = 'Paid' AND  buildertek__Project__c =: recId];
        
        if(totalPaidPOs > 0){
            paidPercent = totalPaidPOs;       
        }
        
        if(totalRecords > 0){
            orderedPercent = (orderedPercent / totalRecords)*100;
            paidPercent = (paidPercent / totalRecords) * 100;
        }else{
            orderedPercent = orderedPercent;
            paidPercent = paidPercent;
        } 
        
        PoDetailsInnerClass MasterBudgetsClassRecord = new PoDetailsInnerClass();
        
        MasterBudgetsClassRecord.totalPOAmount = totalPOAmount;
        MasterBudgetsClassRecord.totalRemainingAmount = totalPOBalance;
        MasterBudgetsClassRecord.totalPOs = totalRecords;
        MasterBudgetsClassRecord.totalPaidAmount = totalPaid;
        MasterBudgetsClassRecord.orderedPercent = orderedPercent;
        MasterBudgetsClassRecord.paidPercent = paidPercent;
        
        return MasterBudgetsClassRecord;
    }
    
    
    @AuraEnabled
    public static MessageClass sendMail(List<String> budgetIds, string filedata){
        
        system.debug('budgetIds--------->'+budgetIds);
        
        system.debug('filedata------->'+filedata);
 
        List<Innerclass> inn;
        if(filedata != null && filedata != '' && filedata != '[]'){
            system.debug('filedata'+filedata);
            inn = (List<Innerclass>)JSON.deserialize((filedata),List<Innerclass>.Class);
            system.debug(inn);
            system.debug(inn[0].fileName);
            system.debug(inn[0].fileContent);
            system.debug('kdhiic------>'+inn[0].POId);
        }

        EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE name ='Purchase Order Template' limit 1];
        
        
        MessageClass msgCls = new MessageClass();
        
        List<String> VendorEmails = new List<String>();
        
        List<buildertek__Purchase_Order__c> poList = [Select Id, Name, buildertek__Vendor__c, buildertek__Vendor__r.buildertek__Email_Address__c, buildertek__Vendor__r.Name, buildertek__Status__c,buildertek__Date_Ordered__c,buildertek__PO_Total__c from buildertek__Purchase_Order__c Where Id IN: budgetIds];
        
        system.debug('poList--------->'+poList);
        
        List<buildertek__Purchase_Order__c> OrderedPOList =  new List<buildertek__Purchase_Order__c>();
        
        
        List<contact> conlist = [select id,name from contact limit 1];
        
        List<buildertek__ConfirmationPageSiteURL__c> confirmationurl = buildertek__ConfirmationPageSiteURL__c.getall().values();
        string SiteUrl;
        if(confirmationurl.size() > 0){
            SiteUrl = confirmationurl[0].buildertek__SiteURL__c ;
        }
        
        if(!poList.isEmpty()){
            
            // Step 0: Create a master list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

            Map<Id, List<ContentVersion>> conDocMap = new Map<Id, List<ContentVersion>>();
            List<ContentVersion> cvList = new List<ContentVersion>();
            
            for (buildertek__Purchase_Order__c myContact : poList) {
                if (myContact.buildertek__Vendor__c != null && myContact.buildertek__Vendor__r.buildertek__Email_Address__c != null) {
                    
                    // Update Puechase Order Status To Ordered
                    buildertek__Purchase_Order__c poRec = new buildertek__Purchase_Order__c();
                    poRec.buildertek__Status__c = 'Ordered';
                    poRec.buildertek__Date_Ordered__c = System.today();
                    poRec.Id = myContact.Id;
                    OrderedPOList.add(poRec);
                    //
                    
                    String body = '';
                    List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setTemplateId(et.Id);
                    msg.setWhatId(myContact.Id);
                    msg.setTargetObjectId(conlist[0].Id);
                    system.debug('testtttttttttttttt------------>'+myContact.buildertek__Vendor__r.buildertek__Email_Address__c);
                    msg.toAddresses = new String[] { myContact.buildertek__Vendor__r.buildertek__Email_Address__c };
                        //msg.setToAddresses(new list<string>{EmaiValue});
                        lstMsgs.add(msg);
                    //Messaging.sendEmail(lstMsgs);
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(lstMsgs);
                    Database.rollback(sp);
                    
                    system.debug('after savepoint------->');
                    
                    // List<Messaging.Emailfileattachment> signeefileAttachments = new List<Messaging.Emailfileattachment>();
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new list<string>{myContact.buildertek__Vendor__r.buildertek__Email_Address__c});
                    email.setSubject(lstMsgs[0].Subject);
                    
                    body += 'Hi, <br/><br/> ';
                    body += '</br> Please &nbsp;'; 
                    body += '<a href='+ SiteUrl +'buildertek__ConfirmationPage?Id='+myContact.Id+'&templateId='+et.Id+'>Click here</a>';
                    body += '&nbsp;to confirm your Purchase Order details.' ;
                    
                    //email.setPlainTextBody(emailBody);
                    email.setHtmlBody(body);
                    
                    system.debug('myContact.Id------->'+myContact.Id);
                    
                    PageReference pagePdf = new PageReference('/apex/PurchaseOrderAttachment'); 
                    pagePdf.getParameters().put('budgetId', myContact.Id);
                    
                    blob pdfPageBlob = pagePdf.getContentAsPDF();
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    
                    if(filedata != null && filedata != '' && filedata != '[]'){
                        for(Innerclass i:inn){
                            system.debug('myContact.id------->'+myContact.id);
                            system.debug('i.POId--------->'+i.POId);
                            if(myContact.id == i.POId){
                                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                                efa.setFileName(i.fileName); 
                                system.debug('wiuhwih------->'+EncodingUtil.base64Decode(i.fileContent));
                                efa.setBody(EncodingUtil.base64Decode(i.fileContent)); 
                                //efa.setContentType('application/pdf');
                                fileAttachments.add(efa);

                                // Below code for saving Document into Files section.
                                ContentVersion contentVersion = new ContentVersion(Title = i.fileName, PathOnClient = i.fileName, VersionData = EncodingUtil.base64Decode(i.fileContent), IsMajorVersion = true);
                                cvList.add(contentVersion);

                                if(!conDocMap.containsKey(myContact.Id)){
                                    conDocMap.put(myContact.Id, new List<ContentVersion>());
                                }
                                conDocMap.get(myContact.Id).add(contentVersion);

                            }
                        }
                    }
                    if(fileAttachments.size()>0){
                        email.setFileAttachments(fileAttachments);
                    }
                    mails.add(email);
                }
            }
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mails);
            msgCls.Status = 'Success';
            msgCls.Message = 'Email sent to selected Vendors successfully';

            System.debug('Started-----');
            if(cvList.size() > 0) {
                cvList = new List<ContentVersion>();
                for(Id ids : conDocMap.keySet()){
                    List<ContentVersion> cvl = new List<ContentVersion>();
                    cvl = conDocMap.get(ids);
                    insert cvl;
                    cvList.addAll(cvl);
                    conDocMap.put(ids, cvl);
                }
                List<ContentVersion> documents = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id IN :cvList];
                List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();

                for(buildertek__Purchase_Order__c myContact : poList) {
                    List<ContentVersion> cvlinklist = new List<ContentVersion>();
                    cvlinklist = conDocMap.get(myContact.Id);
                    for(Integer i=0; i<documents.size(); i++){
                        for(ContentVersion cvl : cvlinklist) {
                            if(cvl.Id == documents[i].Id){
                                ContentDocumentLink cdl = new ContentDocumentLink();
                                cdl.LinkedEntityId = myContact.Id;
                                cdl.ContentDocumentId = documents[i].ContentDocumentId;
                                cdl.ShareType = 'V';
                                cdl.Visibility = 'AllUsers';
                                cdlList.add(cdl);
                                System.debug('ContentDocumentLink Added.');
                            }
                        }
                    }
                }
                if(cdlList.size() > 0){
                    insert cdlList;
                }
            }
            
        }else{
            msgCls.Status = 'Failed';
            msgCls.Message = 'Please select atleast one Purchase Order'; 
        }
        
        system.debug('OrderedPOList----->'+OrderedPOList);
        
        if(!OrderedPOList.isEmpty()){
            update OrderedPOList;
        }
        
        return msgCls ;
    }
    
    public class MessageClass{
        @AuraEnabled
        public String Status {get;set;}
        @AuraEnabled
        public string Message {get;set;}
        
    } 
    
    
    public class Innerclass{
        @AuraEnabled public string fileName;
        @AuraEnabled public string fileContent;
        @AuraEnabled public string POId;
    }
    
      @AuraEnabled  
    public static String getContactName(String recId){
        if(recId != null && recId != ''){
            List<Contact> conList = [select Name from Contact where buildertek__Primary_PO_Contact__c = True AND AccountId =: recId];
            System.debug('Contacts : '+conList);
            if(conList.size() > 0){
                return conList[0].Name;
            }
            else{
                return 'undefine';
            }
        }
        else{
            return 'Id is null';
        }
    }
    
    
}