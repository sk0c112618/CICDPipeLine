public class OrderHelper {
    public static void beforeUpdate(List<Order> orList, Map<Id,Order> newMap,Map<Id,Order> oldMap){
        Set<Id> orderId = new Set<Id>();
        List<Krow_Project__c> kpList = new List<Krow_Project__c>();
        for (Order orObj : orList){
            if(orObj.OpportunityId != null){
                if(oldMap.get(orObj.id).Status != 'Complete' && newMap.get(orObj.Id).Status == 'Complete' && orObj.Opportunity.StageName == 'Signature'){
                    Krow_Project__c krpObj = new Krow_Project__c();
                   	krpObj.Onboarding_Type__c = 'Installation';
                    krpObj.OrderId__c = orObj.Id;
                    kpList.add(krpObj);
                    
                }
            }else{
                orObj.addError('Cannot Change Status to Complete as linked opprtunity stage is not Signature.');
            }
            
        }
        if(!kpList.isEmpty()){
            insert kpList;
        }
        List<Krow_Task__c> ktTaskList = [Select id  from Krow_Task__c WHere Krow_Project__r.isTemplateKrow__c = true];
       
        List<Krow_Task__c> clonedList = new List<Krow_Task__c>();
        for (Krow_Project__c kpObj : kpList){
            for (Krow_Task__c ktObj : ktTaskList){
                Krow_Task__c clonedTask = ktObj.Clone(true,true,false,false);
                clonedTask.Id = null;
                clonedTask.Krow_Project__c = kpObj.Id;
                clonedList.add(clonedTask);
            }
            
        }
        if(!clonedList.isEmpty()){
            insert clonedList;
        }
    }
    
}