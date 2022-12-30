trigger ContactTrigger on Contact (after insert,after update) {
    switch on Trigger.operationType{
        
        when AFTER_INSERT{
            ContactTriggerHandler.updateActiveContactNumber(Trigger.new);
        }
        when AFTER_UPDATE{
            ContactTriggerHandler.updateActiveContactNumber(Trigger.new);
        }
        when AFTER_DELETE{
            ContactTriggerHandler.updateActiveContactNumber(Trigger.old);
        }
        when AFTER_UNDELETE{
            ContactTriggerHandler.updateActiveContactNumber(Trigger.new);
        }
    }
}