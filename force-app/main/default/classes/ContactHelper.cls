public class ContactHelper {
    public static void contactBefore(List<Contact> conList){
        ContactHelper.updateAccountOnCreateUndelete(conList);
    } 
    public static void afterUpdate(List<Contact> conList,Map<Id,Contact> newMap, Map<id,Contact> oldMap){
        system.debug('Hi');
        Map<Id,Account> accMap = new Map<Id,Account>();
        for (Contact conObj : conList){
            if (conObj.AccountId != null && conObj.Phone !=null){
                if (conObj.Phone != oldMap.get(conObj.Id).Phone){
                        Account accObj = new Account(Id=conObj.AccountId);
                        accObj.Phone = conObj.Phone;
                        accMap.put(accObj.Id, accObj);
                }
            }
        }
        if (!accMap.isEmpty()){
            update accMap.values();
        }
    }
    public static void afterUndelete(List<Contact> conList){
       ContactHelper.updateAccountOnCreateUndelete(conList);
    }
    public static void afterDelete(List<Contact> conList){
        Set<Id> accSet = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Contact con : conList){
            if (con.AccountId!=null){
                accSet.add(con.AccountId);}
        }
        List<account> accList=[Select Id,(Select AccountId,Phone From Contacts where AccountId!=null AND Phone != null order by createddate desc limit 1 ) from  account Where Id In : accSet ];
        for (Account accObj : accList){
            for (Contact conObj : accObj.contacts){
                if (conObj.AccountId != null && conObj.Phone !=null){
                    Account acc = new Account(Id = conObj.AccountId);
                    acc.Phone = conObj.Phone;
                    accMap.put(acc.Id, acc);
                }
            }
        }
        if (!accMap.isEmpty()){
            update accMap.values();
        }
    }
    public static void updateAccountOnCreateUndelete(List<Contact> conList){
        Map<Id,Account> accMap = new Map<Id,Account>();
        for (Contact conObj : conList){
            if (conObj.AccountId != null){
                if (conObj.Phone != null){
                    Account accObj = new Account(Id = conObj.AccountId);
                    accObj.Phone = conObj.Phone;
                    accMap.put(accObj.Id, accObj);
                }
            }
        }
        if (!accMap.isEmpty()){
            update accMap.values();
        }
        
    }
    public static void UpdateNumberOfContact(List<Contact> contList){
        Set<Id> accIds = new Set<Id>();
        for (Contact conObj : contList){
            if(conObj.AccountId != null){accIds.add(conObj.AccountId);} 
        }
        List<AggregateResult> groupedResults = [SELECT AccountId, COUNT(Id) FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId];
        List<Account> accList = new List<Account>();
    	for (AggregateResult ar : groupedResults){
            if ((Id)ar.get('AccountId')!=null && Integer.valueOf(ar.get('expr0'))!=null){
        		Account accObj = new Account(Id = (Id)ar.get('AccountId'));
        		accObj.Number_of_Contacts__c = Integer.valueOf(ar.get('expr0'));
                accList.add(accObj);}
    	}
        if( accList.size()>0){Update accList;}
}
}