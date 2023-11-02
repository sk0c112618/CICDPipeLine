trigger TriggerContact on Contact (After insert, before update , after undelete,after delete) {
    if (trigger.isAfter && trigger.isInsert){
        ContactHelper.contactBefore(trigger.new);
        ContactHelper.UpdateNumberOfContact(trigger.new);
    }else if (trigger.isBefore && trigger.isUpdate){ 
        ContactHelper.afterUpdate(trigger.new, trigger.newMap,trigger.oldMap);  
    }else if (trigger.isAfter && trigger.isunDelete){ 
        
        ContactHelper.UpdateNumberOfContact(trigger.new);
        ContactHelper.afterUndelete(trigger.new);
    }else if (trigger.isAfter && trigger.isDelete){
        ContactHelper.AfterDelete(trigger.old);
        ContactHelper.UpdateNumberOfContact(trigger.old);
    }
}