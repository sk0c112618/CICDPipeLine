trigger TaskTrigger on Task (before delete) {
    TaskTriggerHelper.beforedelete(trigger.new);
}