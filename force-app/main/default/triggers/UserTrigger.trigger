trigger UserTrigger on User (before insert, after insert) {
    
    UserTriggerHandler UserTriggerHandler = new UserTriggerHandler();
    
    
    
    buildertek__Admin_Interface_Node_Configuration__c adminInterfaceNodeConfigurations = [Select Id, buildertek__User_SOV_Sharing__c	
                                                                                          from buildertek__Admin_Interface_Node_Configuration__c
                                                                                          WHERE Name = :'Payment Application Configuration'];
    Boolean isUserEnable = false;
    if(adminInterfaceNodeConfigurations.buildertek__User_SOV_Sharing__c	 == true){
        isUserEnable = true;
    }
    
    if(isUserEnable == true){
        if(Trigger.isInsert){
            if (Trigger.isAfter){
                system.debug('is after');
                UserTriggerHandler.isAfterInsert(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
            }
        }    
    }
    
    
}