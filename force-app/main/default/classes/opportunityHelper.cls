public with sharing class opportunityHelper {
    public static void beforeUpdate(List<Opportunity> oppList, Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap){
        Set<Id> oppId = new Set<Id>();
        for(Opportunity oppObj : oppList){
            if (oldMap.get(oppObj.Id).StageName != 'Signature' && newMap.get(oppObj.Id).StageName == 'Signature'){
                oppId.add(oppObj.Id);
            }
        }
        List<Krow_Project__c> krwList = new List<Krow_Project__c>();
        for (Id key : oppId){
            Krow_Project__c kpObj = new Krow_Project__c();
            kpObj.Opportunity__c = key;
            kpObj.Onboarding_Type__c = 'Customer Onboarding';
            krwList.add(kpObj);
        }
        if(!krwList.isEmpty()){
            insert krwList;
        }
    }
    public static void test(List<Opportunity> newOpp){
        Set<Id> accSet = new Set<Id>();
        for (Opportunity oppObj : newOpp){
            if(oppObj.AccountId != null){
             accSet.add(oppObj.AccountId);   
            }
        }
        if(!accSet.isEmpty()){
            Map<Id,account> accMap =new Map<Id,Account>([select id,(select id from opportunities where stageName != 'Closed Won' and stageName != 'Closed Lost' and AccountId != null ) from Account where id =: accSet with Security_Enforced]);
            for (Opportunity oppOb : newOpp){
                if(oppOb.StageName != 'Closed Won' && oppOb.StageName != 'Closed Lost'){
                    if(accMap.get(oppOb.accountId).opportunities.size() > 0){
                        oppOb.addError('Already has an open opportunity');
                    }
                }
            }
        }
    }
}