
@isTest
public class createCO_selectionType_Test {

    @TestSetup
    static void testData(){

        buildertek__Change_Order__c changeOrder = new buildertek__Change_Order__c();
        changeOrder.Name = 'Test';
        changeOrder.buildertek__Details__c = 'Details Testing';
        changeOrder.buildertek__Due_Date__c = System.today().addDays(2);
        insert changeOrder;

        buildertek__Project__c project = new buildertek__Project__c();
        project.Name = 'Test Project';
        insert project;

        buildertek__Selection__c selectionSheet = new buildertek__Selection__c();
        selectionSheet.Name = 'selectionSheet Testing';
        selectionSheet.buildertek__Project__c = project.Id;

        buildertek__Section__c selectionCategory = new buildertek__Section__c();
        selectionCategory.Name = 'selectionCategory Testing';
        selectionCategory.buildertek__Selection__c = selectionSheet.Id;

        buildertek__Question_Group__c selectionType = new buildertek__Question_Group__c();
        selectionType.Name = 'Testing';
        selectionType.buildertek__Section__c = selectionCategory.Id;
        insert selectionType;

        buildertek__Question__c option = new buildertek__Question__c();
        option.Name = 'Testing 1';
        option.buildertek__Change_Order__c = changeOrder.Id;
        option.buildertek__Quantity__c = 1;
        option.buildertek__Upgrade_Costs__c = 200;
        option.buildertek__Question_Group__c = selectionType.Id;
        option.buildertek__Upgrade__c = true;
        option.buildertek__Change_Order__c = null;
        insert option;

    }

    @IsTest
    static void testMethod1(){
        
        buildertek__Change_Order__c changeOrder = [SELECT Id,Name,buildertek__Details__c, buildertek__Due_Date__c FROM buildertek__Change_Order__c LIMIT 1];
        buildertek__Question_Group__c selectionType = [SELECT Id,Name FROM buildertek__Question_Group__c LIMIT 1];

        createCO_selectionType.changeOptionList(changeOrder, selectionType.Id);
    }
    
}
