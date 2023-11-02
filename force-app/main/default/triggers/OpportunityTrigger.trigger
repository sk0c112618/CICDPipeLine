trigger OpportunityTrigger on Opportunity (before insert,after update) {
    if(trigger.isBefore && trigger.isInsert){
        opportunityHelper.test(trigger.new);
    }
    if (trigger.isAfter && trigger.isUpdate){
        opportunityHelper.beforeUpdate(trigger.new, trigger.newMap, trigger.oldMap);
    }
}