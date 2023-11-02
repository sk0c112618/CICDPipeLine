trigger AccountTrigger on Account (before insert) {
    AccountTriggerHelper.beforeInsert(trigger.new);
}