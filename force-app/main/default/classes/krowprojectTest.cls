@isTest
public class krowprojectTest {
    @isTest public static void beforeupdateopp(){
        Account accObj = new Account();
        accObj.Name = 'Test_1';
        insert accObj;
        Opportunity oppObj = new Opportunity();
        oppObj.AccountId = accObj.Id;
        oppObj.StageName = 'Prospecting';
        oppObj.Name = 'Test_1';
        oppObj.CloseDate = System.today() + 30;
        insert oppObj;
        oppObj.StageName = 'Signature';
        update oppObj;
        List<Krow_Project__c> krwList = [Select Name,Onboarding_Type__c,Opportunity__c From Krow_Project__c WHERE Opportunity__c =:oppObj.Id];
        for (Krow_Project__c kr : krwList){
            System.assertEquals(oppObj.Id, kr.Opportunity__c);
            System.assertEquals('Customer Onboarding', kr.Onboarding_Type__c);
        }
    }
    @isTest public static void AfterUpdate(){
        
    }
}