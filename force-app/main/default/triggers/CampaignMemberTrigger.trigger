trigger CampaignMemberTrigger on CampaignMember (after insert,after Update) {
    CampaignMemberHelper.afterUpdate(Trigger.new);
}