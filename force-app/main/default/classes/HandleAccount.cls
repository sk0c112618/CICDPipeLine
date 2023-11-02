public class HandleAccount {
    public static void handleParentAccount(List<Voucher__c> vchList){
        List<String> companyNameString = new List<String>();
        for(Voucher__c vchObj : vchList){
            System.debug('Here in Parent 1');
            if(vchObj.Company_Name__c != null){
                companyNameString.add(vchObj.Company_Name__c);
            }
        }
        if(!companyNameString.isEmpty()){
            System.debug('Here in Parent 2');
            Map<String,Id> accMap = new Map<String,Id>();
            List<Account> accList = [Select id,Name from Account Where parentId = null and Name in :companyNameString];
            Map<String,Account> accMaptoInsert = new Map<String,Account>();  
            for (Account accObj : accList){
                System.debug('Here in Parent 2');
                accMap.put(accObj.Name, accObj.id);
            }
            for(Voucher__c vch : vchList){
                if(!accMap.containsKey(vch.Company_Name__c)){
                    System.debug('Here in Parent 4');
                    Account acc = new Account();
                    acc.Name = vch.Company_Name__c;
                    accMaptoInsert.put(acc.Name, acc);
                }
            }
            if(!accMaptoInsert.isEmpty()){
                insert accMaptoInsert.values();
            }
        }
        
    }
    public Static Void handleChildAccount(List<Voucher__c> vchList){
        System.debug('Here in child 1');
        List<String> childNameString = new List<String>();
        List<String> parentNameString = new List<String>();
        for(Voucher__c vch : vchList){
            if(vch.PartyName__c != null){
                System.debug('Here in child 2');
                childNameString.add(vch.PartyName__c);
                parentNameString.add(vch.Company_Name__c);
            }
        }
        if(!childNameString.isEmpty() && !parentNameString.isEmpty()){
            System.debug('Here in child 3');
            Map<String,Account> toInsert = new Map<String,Account>();
            Map<String,Id> childMap = new Map<String,Id>();
            Map<String,Id> ParentMap = new Map<String,Id>();
            List<Account> childAccounts = [Select id,Name from Account where name in:childNameString];
            List<Account> parentAccounts = [Select id,Name from Account where name in:parentNameString];
            for (Account accObjP : parentAccounts){
                ParentMap.put(accObjP.Name,accObjP.Id);
            }
            for (Account accObjCh : childAccounts){
                childMap.put(accObjCh.Name, accObjCh.id);
            }
            for (Voucher__c vchObj : vchList){
                if(!childMap.containsKey(vchObj.PartyName__c)){
                    System.debug('Here in child 4');
                    Account accObj = new Account();
                    accObj.Name = vchObj.PartyName__c;
                    accObj.ParentId = ParentMap.get(vchObj.Company_Name__c);
                    toInsert.put(accObj.Name,accObj);
                }
            }
            if(!toInsert.isEmpty()){
                insert toInsert.values();
            }
        }
    }
}