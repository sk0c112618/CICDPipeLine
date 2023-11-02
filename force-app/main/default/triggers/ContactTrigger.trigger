trigger ContactTrigger on Contact (before insert,After insert) {
    if (trigger.isInsert && trigger.isBefore){
        ContactTriggerHelper.duplicateContact(trigger.new);
    }
    if (trigger.isInsert && trigger.isAfter){
        ContactTriggerHelper.afterInsert(trigger.new);
    }
    
}