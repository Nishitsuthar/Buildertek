@isTest
public  class SubContractOrderFromProjectClassTest {
    @isTest static void testmethod1(){

      

        Account account1 = new Account(
            Name = 'Sample Account 1'
        );
        insert account1;
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            LastName = 'LastName1',
            email='sagar@buildertek.com'
        );
        insert contact1;

        



        buildertek__Project__c project = new buildertek__Project__c(
            Name = 'Sample Project',
            buildertek__Account__c = account1.Id,
            buildertek__Project_Manager__c = UserInfo.getUserId(),
            Project_Tax_Rate__c = 10.5
        );
        insert project;
        buildertek__Purchase_Order__c purchaseOrder = new buildertek__Purchase_Order__c();
        purchaseOrder.buildertek__Contractor_Resource__c = contact1.Id;
        purchaseOrder.buildertek__Vendor__c = account1.Id;
        purchaseOrder.buildertek__Project__c = project.Id;
        purchaseOrder.buildertek__Ship_To_Address__c = account1.Id;
        insert purchaseOrder;

        Contract contra= new Contract();
        contra.Name='Test';
        contra.AccountId=account1.Id;
        contra.CustomerSignedId=contact1.Id;
        // contra.buildertek__Contract_Amount__c=0;
        // contra.buildertek__Purchase_Order__c=purchaseOrder.Id;

        insert contra;


        buildertek__Project__c proj = new buildertek__Project__c();
	    proj.Name = 'Test Project';
	    insert proj;

    
        
        List<buildertek__Budget__c> budgetList = new List<buildertek__Budget__c>();
	    buildertek__Budget__c budget = new buildertek__Budget__c();
	    budget.Name = 'Test Budget';
	    budget.buildertek__Project__c = proj.Id;
	    budget.buildertek__Type__c = 'Master';
	    budgetList.add(budget);
	    insert budgetList;
	    
        buildertek__Budget_Item__c budget1Item = new buildertek__Budget_Item__c();
        budget1Item.Name='test';
        budget1Item.buildertek__Contractor__r.Name=account1.Name;
        budget1Item.buildertek__Budget__c=budgetList[0].Id;
        budget1Item.buildertek__Budget__r.buildertek__Project__c=proj.Id;
        budget1Item.buildertek__Contractor__r.buildertek__Email_Address__c=null;
        // budget1Item.buildertek__Sub_Contract__r.buildertek__Contract_Amount__c=0;
        budget1Item.buildertek__Group__r.Name='Test';
        budget1Item.buildertek__Description__c='Test';
        budget1Item.buildertek__Cost_Code__r.Name='Test';
        budget1Item.buildertek__Sub_Contract__c=contra.Id;
        budget1Item.buildertek__Sub_Contract__r.Name=contra.Name;
        budget1Item.buildertek__Sub_Contract__r.buildertek__Purchase_Order__c=purchaseOrder.Id;
        budget1Item.buildertek__Purchase_Order__c=purchaseOrder.Id;

        insert budget1Item;

        SubContractOrderFromProjectClass subContract = new SubContractOrderFromProjectClass();
        // Message wrapper
        SubContractOrderFromProjectClass.MessageClass messageWrapper = new SubContractOrderFromProjectClass.MessageClass();
        messageWrapper.Status='Passed';
        messageWrapper.Message='Test';

        // Master Budget wrapper
        SubContractOrderFromProjectClass.MasterBudgetsClass masterBudget = new SubContractOrderFromProjectClass.MasterBudgetsClass();
        masterBudget.budgetRecord=budget1Item;
        masterBudget.budgetCheck=true;

        List<buildertek__Budget_Item__c> budgetItemList= new  List<buildertek__Budget_Item__c>();
        SubContractOrderFromProjectClass.getMasterBudgets(proj.Id);
        SubContractOrderFromProjectClass.findByName('test', proj.Id);
        SubContractOrderFromProjectClass.findByName1('test', proj.Id);
        SubContractOrderFromProjectClass.findByName2('test', proj.Id);

        



    




    }
  
}