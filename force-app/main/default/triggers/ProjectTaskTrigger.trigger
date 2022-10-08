/*
Copyright (c) 2017-2018, BuilderTek.
All rights reserved.

Developed By: Sagar
Date: 24/05/2018
*/
trigger ProjectTaskTrigger on buildertek__Project_Task__c(after insert, after update, before delete, after delete, before insert, before update, After Undelete ){
    
    if (!BT_Utils.isTriggerDeactivate('Project_Task__c') && !ProjectTaskTriggerHandler.blnSkipTaskTrigger){
        ProjectTaskTriggerHandler handler = new ProjectTaskTriggerHandler(Trigger.isExecuting, Trigger.size);
        if (Trigger.isInsert){
             
            if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                return;
            }
            if (Trigger.isBefore){
                if (!ProjectTaskTriggerHandler.OnBeforeInsertCall) {
                    ProjectTaskTriggerHandler.OnBeforeInsertCall = true;
                    handler.OnBeforeInsert(Trigger.new);
                }
                
            } else if(Trigger.isAfter){
                
                if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                    
                }else{

                    if (!ProjectTaskTriggerHandler.updateChildDatesWithPredecessorCall) {
                        ProjectTaskTriggerHandler.updateChildDatesWithPredecessorCall = true;
                        handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                    }

                    if (!ProjectTaskTriggerHandler.OnAfterInsertItemCountCall) {
                        ProjectTaskTriggerHandler.OnAfterInsertItemCountCall = true;
                        handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                    }
                    
                    if (!ProjectTaskTriggerHandler.OnAfterInsertCall) {
                        ProjectTaskTriggerHandler.OnAfterInsertCall = true;
                        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
                    }
                    if (!ProjectTaskTriggerHandler.UpdateOriginalstartandEndDatesCall) {
                        ProjectTaskTriggerHandler.UpdateOriginalstartandEndDatesCall = true;
                        handler.UpdateOriginalstartandEndDates(Trigger.new, Trigger.newMap);
                    }
                    if (ProjectTaskTriggerHandler.isTask == true){

                        if (!ProjectTaskTriggerHandler.OnAfterInsertItemCountCall) {
                            ProjectTaskTriggerHandler.OnAfterInsertItemCountCall = true;
                            handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                        }

                        if (!ProjectTaskTriggerHandler.OnBeforeInsert1Call) {
                            ProjectTaskTriggerHandler.OnBeforeInsert1Call = true;
                            handler.OnBeforeInsert1(Trigger.new);
                        }
                        ProjectTaskTriggerHandler.isTask = false;
                    }
                    //insert update milestones
                    if (!ProjectTaskTriggerHandler.insertUpdateMilestonesCall) {
                        ProjectTaskTriggerHandler.insertUpdateMilestonesCall = true;
                        handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                    }
                }
                
                
                /*  handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);

                    handler.OnAfterInsert(Trigger.new, Trigger.newMap);
                    handler.UpdateOriginalstartandEndDates(Trigger.new, Trigger.newMap);
                    if (ProjectTaskTriggerHandler.isTask == true){
                        handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                        handler.OnBeforeInsert1(Trigger.new);
                        ProjectTaskTriggerHandler.isTask = false;
                    }*/
                
            }
        } else if (Trigger.isUpdate){
            
            if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                return;
            }
            if (Trigger.isAfter){
                if (!ProjectTaskTriggerHandler.updateChildDatesWithPredecessorCall) {
                    ProjectTaskTriggerHandler.updateChildDatesWithPredecessorCall = true;
                    handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                }
            }
            if (Trigger.isBefore){
                if (!ProjectTaskTriggerHandler.OnBeforeUpdateCall) {
                    ProjectTaskTriggerHandler.OnBeforeUpdateCall = true;
                    handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
                }
            } else if (Trigger.isAfter){
                if (!ProjectTaskTriggerHandler.OnAfterUpdateCall) {
                    ProjectTaskTriggerHandler.OnAfterUpdateCall = true;
                    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
                }
                if (!ProjectTaskTriggerHandler.OnAfterUpdateOriginalstartandEndCall) {
                    ProjectTaskTriggerHandler.OnAfterUpdateOriginalstartandEndCall = true;
                    handler.OnAfterUpdateOriginalstartandEndDates(Trigger.old, Trigger.new, Trigger.newMap, trigger.oldMap);
                }
                
                if (!ProjectTaskTriggerHandler.insertUpdateMilestonesCall) {
                    ProjectTaskTriggerHandler.insertUpdateMilestonesCall = true;
                    handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                }
            }
            
            
            //insert update milestones
            
            
        }else if (Trigger.isDelete && Trigger.isAfter){
            
            if (!ProjectTaskTriggerHandler.OnAfterInsertItemCountCall) {
                ProjectTaskTriggerHandler.OnAfterInsertItemCountCall = true;
                handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            }
            
            if (!ProjectTaskTriggerHandler.OnAfterDeleteCall) {
                ProjectTaskTriggerHandler.OnAfterDeleteCall = true;
                handler.OnAfterDelete(Trigger.old);
            }
            
        }else if (Trigger.isUnDelete && Trigger.isAfter){
            
            if (!ProjectTaskTriggerHandler.OnAfterInsertItemCountCall) {
                ProjectTaskTriggerHandler.OnAfterInsertItemCountCall = true;
                handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            }
        }
        
    }
    
}