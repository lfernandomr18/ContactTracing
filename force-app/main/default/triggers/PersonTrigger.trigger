trigger PersonTrigger on Person__c (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPersonTriggerHandler.beforeInsertPerson(Trigger.new);
        }
        when BEFORE_UPDATE {
            CTPersonTriggerHandler.beforeUpdatePerson(Trigger.new,Trigger.oldMap);
        }
        when AFTER_UPDATE {
            CTPersonTriggerHandler.afterUpdatePerson(Trigger.new,Trigger.oldMap);
        }
    }

}