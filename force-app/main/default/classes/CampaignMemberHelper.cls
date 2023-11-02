public class CampaignMemberHelper {
    public static void afterUpdate(List<CampaignMember> newCampMem){
        // Getting Campaign Id 
        // Done
        Set<Id> campaignId = new Set<Id>();
        for (CampaignMember campMemObj : newCampMem){
            if(campMemObj.CampaignId != null){ 
                system.debug('Harsh');   
                campaignId.add(campMemObj.CampaignId);   
            } 
        }   
        // Getting All Account Ids That i Have to Update
        Set<Id> accId = new Set<Id>();  
        Map<Id, Campaign> campMap = new Map<Id,Campaign>([Select Id,(Select Contact.AccountId from CampaignMembers) from Campaign where Id =:campaignId]);
        for (Campaign campObj : campMap.Values()){
            for (CampaignMember cpMem : campObj.CampaignMembers){
                accId.add(cpMem.Contact.AccountId);   
            }
        }   
        // Only those contact that are in campaign gets fetched.
        // Number of Campaign Members in Account.
        if(!accId.isEmpty()){
            Set<Id> conId = new Set<Id>();
            Map<Id,List<Contact>> numCampaignMem = new Map<Id,List<Contact>>();
            //Integer avail = Limits.getLimitAggregateQueries();
            //Integer processed = Limits.getAggregateQueries();
            //System.debug('Available AggregateQueries '+avail);
            //System.debug('Processed AggregateQueries '+processed);
            //Integer Queries = Limits.getQueries();
            //Integer LimitQueryLocatorRows = Limits.getLimitQueryLocatorRows();
            //System.debug('Number of queries '+Queries);
            //System.debug('Total Number that can be returned '+LimitQueryLocatorRows);
            Map<Id,Account> acccuMap = new Map<Id,Account>([Select Id,(Select Id From Contacts Where Id In (Select ContactId from CampaignMember)) from Account Where Id =:accId]);
            //Integer avail_1 = Limits.getLimitAggregateQueries();
                                                                                        //Integer processed_1 = Limits.getAggregateQueries(); 
            //Integer Queries_1 = Limits.getQueries();
            //Integer LimitQueryLocatorRows_1 = Limits.getLimitQueryLocatorRows();
            //System.debug('Available AggregateQueries '+avail_1);
            //System.debug('Processed AggregateQueries '+processed_1);
            //System.debug('Number of queries '+Queries_1);
            //System.debug('Total Number that can be returned '+LimitQueryLocatorRows_1);
            
            for (Account accObj: acccuMap.Values()){
                List<Contact> conList = new List<Contact>();
                for (Contact conObj : accObj.Contacts){
                    conId.add(conObj.Id);
                    conList.add(conObj);
                }
                numCampaignMem.put(accObj.Id, conList);
            }
            //system.debug(numCampaignMem.Values());
            // Find all campaigns of these contacts
            Map<Id, Set<Id>> gg = new Map<Id, Set<Id>>();
            Map<Id,Contact> ccMap = new Map<Id,Contact>([Select id , (Select CampaignId,Contact.AccountId from CampaignMembers) From Contact WHERE Id=:conId]);
            for (Contact newCon : ccMap.Values()){
                Set<Id> campa = new Set<Id>();
                for (CampaignMember cm : newcon.CampaignMembers){
                    campa.add(cm.CampaignId);
                    if(gg.containsKey(cm.Contact.AccountId)){
                        gg.get(cm.Contact.AccountId).add(cm.CampaignId);
                    }else{
                        gg.put(cm.Contact.AccountId, campa);
                    }
                }
                
            }
            list<Account> toUpdateList = new List<Account>();
            for (Id ac : accId){
                Account toUpdate = new Account(Id = ac);
                toUpdate.Number_of_campaign_members__c = numCampaignMem.get(ac).size();
                toUpdate.Number_of_campaign__c = gg.get(ac).size();
                toUpdateList.add(toUpdate);
            }
            
            if (!toUpdateList.isEmpty()){
                Update toUpdateList;
            }
        }
    }
    
}