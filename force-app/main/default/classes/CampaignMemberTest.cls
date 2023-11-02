@isTest
public class CampaignMemberTest {
    @isTest public static void afterupdateContactWithAccount(){
        Integer NumberOfCampaign = 1;
        Integer NumberOfAccount = 1;
        Integer NumberOfContact = 2;
        TestDataFactory.CampaignData(NumberOfCampaign, NumberOfAccount, NumberOfContact);
        List<Account> accList = [Select id,Number_of_campaign__c,Number_of_campaign_members__c From Account];
        for (Account accObj : accList){
            System.assertEquals(NumberOfContact, accObj.Number_of_campaign_members__c);
            System.assertEquals(NumberOfCampaign, accObj.Number_of_campaign__c);
        }
    }
    @isTest public static void AccountContactInMultipleCampaigns(){
        Integer NumberOfCampaign = 2;
        Integer NumberOfAccount = 1;
        Integer NumberOfContact = 2;
        TestDataFactory.CampaignData(NumberOfCampaign, NumberOfAccount, NumberOfContact);
        List<Account> accList = [Select id,Number_of_campaign__c,Number_of_campaign_members__c From Account];
        for (Account accObj : accList){
            System.assertEquals(NumberOfContact, accObj.Number_of_campaign_members__c);
            System.assertEquals(NumberOfCampaign, accObj.Number_of_campaign__c);
        }
        
    }
    
    
    
}