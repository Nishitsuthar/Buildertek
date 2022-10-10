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
<<<<<<< HEAD
                system.debug('insertBefore1'+ProjectTaskTriggerHandler.blnSkipTaskTrigger);
//                handler.OnBeforeInsert(Trigger.new);
                ProjectTaskTriggerHandler.OnBeforeInsert(JSON.serialize(Trigger.new));
=======
                if (!ProjectTaskTriggerHandler.OnBeforeInsertCall) {
                    ProjectTaskTriggerHandler.OnBeforeInsertCall = true;
                    handler.OnBeforeInsert(Trigger.new);
                }
>>>>>>> 71788203f2caec53c3b46e9c418a36c780aaab30
                
            } else if(Trigger.isAfter){
                
                if (ProjectTaskTriggerHandler.blnSkipTaskTrigger){
                    
                }else{
<<<<<<< HEAD
                    //handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                    ProjectTaskTriggerHandler.updateChildDatesWithPredecessor(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                    system.debug('test2-----------------------------------------------------------------------------ProjectTaskTrigger 34');
                    
//                    handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                    ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
                    
                    //handler.OnAfterInsert(Trigger.new, Trigger.newMap);
                    ProjectTaskTriggerHandler.OnAfterInsert(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                    handler.UpdateOriginalstartandEndDates(Trigger.new, Trigger.newMap);
                    if (ProjectTaskTriggerHandler.isTask == true){
//                        handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
                        ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
                        handler.OnBeforeInsert1(Trigger.new);
                        ProjectTaskTriggerHandler.isTask = false;
                    }
                    //insert update milestones
                    //handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                    ProjectTaskTriggerHandler.insertUpdateMilestones(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
=======

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
>>>>>>> 71788203f2caec53c3b46e9c418a36c780aaab30
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
<<<<<<< HEAD
                system.debug('test-----------------------------------------------------------------------------');
                
                //handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                ProjectTaskTriggerHandler.updateChildDatesWithPredecessor(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
                
                system.debug('test2-----------------------------------------------------------------------------');
                
                
=======
                if (!ProjectTaskTriggerHandler.updateChildDatesWithPredecessorCall) {
                    ProjectTaskTriggerHandler.updateChildDatesWithPredecessorCall = true;
                    handler.updateChildDatesWithPredecessor(Trigger.new, Trigger.newMap);
                }
>>>>>>> 71788203f2caec53c3b46e9c418a36c780aaab30
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
                
<<<<<<< HEAD
                //handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                ProjectTaskTriggerHandler.insertUpdateMilestones(JSON.serialize(Trigger.new),JSON.serialize(Trigger.newMap));
=======
                if (!ProjectTaskTriggerHandler.insertUpdateMilestonesCall) {
                    ProjectTaskTriggerHandler.insertUpdateMilestonesCall = true;
                    handler.insertUpdateMilestones(Trigger.new, Trigger.newMap);
                }
>>>>>>> 71788203f2caec53c3b46e9c418a36c780aaab30
            }
            
            
            //insert update milestones
            
            
        }else if (Trigger.isDelete && Trigger.isAfter){
            
<<<<<<< HEAD
            //handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
=======
            if (!ProjectTaskTriggerHandler.OnAfterInsertItemCountCall) {
                ProjectTaskTriggerHandler.OnAfterInsertItemCountCall = true;
                handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            }
>>>>>>> 71788203f2caec53c3b46e9c418a36c780aaab30
            
            if (!ProjectTaskTriggerHandler.OnAfterDeleteCall) {
                ProjectTaskTriggerHandler.OnAfterDeleteCall = true;
                handler.OnAfterDelete(Trigger.old);
            }
            
        }else if (Trigger.isUnDelete && Trigger.isAfter){
            
<<<<<<< HEAD
            //handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            ProjectTaskTriggerHandler.OnAfterInsertItemCount(JSON.serialize(Trigger.new),JSON.serialize(Trigger.old));
=======
            if (!ProjectTaskTriggerHandler.OnAfterInsertItemCountCall) {
                ProjectTaskTriggerHandler.OnAfterInsertItemCountCall = true;
                handler.OnAfterInsertItemCount(Trigger.new, Trigger.old);
            }
>>>>>>> 71788203f2caec53c3b46e9c418a36c780aaab30
        }
        
    }
    
}