public class BT_ChangeOrderonOverage {
    public Boolean isCreateChangeOrderonOverage{get;set;}
    public buildertek__Admin_Interface_Node_Configuration__c adminterface {get;set;} 
    public string  emailsubject {get;set;}
    // public Boolean  CheckRecordTypeVisibilityYes {get;set;}
    // public Boolean  CheckRecordTypeVisibilityNo {get;set;}
    // public Boolean  CheckVisibility {get;set;}
    public Boolean  radiovalue {get;set;}
    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','true')); 
        options.add(new SelectOption('No','false')); 
        return options; 
    }
    
    public BT_ChangeOrderonOverage(){
        
        List<BT_CO_Lines_From_Product__c> test = [SELECT buildertek__CO_Lines_Using_Product__c from BT_CO_Lines_From_Product__c];
        System.debug(test[0].buildertek__CO_Lines_Using_Product__c);
        radiovalue = test[0].buildertek__CO_Lines_Using_Product__c;


        buildertek__Admin_Interface_Node_Configuration__c adminInterfaceNodeConfigurations = [Select Id,buildertek__Change_Order_Configuration__c,buildertek__Email_Subject__c from buildertek__Admin_Interface_Node_Configuration__c WHERE Name=:'Change Order Configuration'];
        isCreateChangeOrderonOverage=adminInterfaceNodeConfigurations.buildertek__Change_Order_Configuration__c;
        emailsubject = adminInterfaceNodeConfigurations.buildertek__Email_Subject__c;
        
        
        // if(test[0].buildertek__CO_Lines_Using_Product__c == true){
        //     CheckRecordTypeVisibilityYes = true;
        //     CheckRecordTypeVisibilityNo = false;
        // }else{
        //     CheckRecordTypeVisibilityYes = false;
        //     CheckRecordTypeVisibilityNo = true;

        // }


       
       // CheckRecordTypeVisibility = test[0].buildertek__CO_Lines_Using_Product__c;
    }
    

    // public void selectOnClick()
    // {
    //     //radiovalue will store the selected option
    //     system.debug('selectedOption::'+CheckVisibility);
    // }


    public void onCreateChangeOrderonOverage(){
        System.debug('radiovalue=='+radiovalue);
        buildertek__Admin_Interface_Node_Configuration__c adminInterfaceNodeConfigurations = [Select Id,buildertek__Change_Order_Configuration__c,buildertek__Email_Subject__c from buildertek__Admin_Interface_Node_Configuration__c WHERE Name=:'Change Order Configuration'];
        adminInterfaceNodeConfigurations.buildertek__Change_Order_Configuration__c=isCreateChangeOrderonOverage;
        adminInterfaceNodeConfigurations.buildertek__Email_Subject__c = emailsubject;
        update adminInterfaceNodeConfigurations;

        List<BT_CO_Lines_From_Product__c> test = [SELECT buildertek__CO_Lines_Using_Product__c from BT_CO_Lines_From_Product__c];
        
        // System.debug('CheckRecordTypeVisibilityYes=='+CheckRecordTypeVisibilityYes);
        // System.debug('CheckRecordTypeVisibilityNo=='+CheckRecordTypeVisibilityNo);
        // if(CheckRecordTypeVisibilityYes == true && CheckRecordTypeVisibilityNo == false){
        //     test[0].buildertek__CO_Lines_Using_Product__c = true;
        // }else if(CheckRecordTypeVisibilityNo == true && CheckRecordTypeVisibilityYes == false){
        //     test[0].buildertek__CO_Lines_Using_Product__c = false;

        // }
        System.debug('Data to be updated==='+test);
        
        test[0].buildertek__CO_Lines_Using_Product__c = radiovalue;
        update test;

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Updated Successfully'));
    }



    // public void changeOption(Boolean myParam) {
    //     System.debug('get boolean value --> '+myParam);
    // }
}