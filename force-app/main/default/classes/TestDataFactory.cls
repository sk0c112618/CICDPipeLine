@isTest
public class TestDataFactory {
    public static void CampaignData(Integer NumOfCamp,Integer NumOfAcc,Integer NumOfContacts){
        
        List<Account> accList = new List<Account>();
        // Number Of Accounts.
        for (Integer i=1;i<NumOfAcc+1;i++){
            Account accObj = new Account();
            accObj.Name = 'TestDataAccount'+i;
            accList.add(accObj);
        }
        insert accList;
        // Number Of Contacts per Account.
        List<Contact> conList = new List<Contact>();
        for (Integer j=0;j<accList.size();j++){
            Account accObj1 = accList[j];
            for (Integer k=1;k<NumOfContacts+1;k++){
                Contact conObj = new Contact(AccountId = accObj1.Id);
                conObj.lastName = 'TestDataContact'+accObj1.Name+k;
                conList.add(conObj);
            }
        }
        insert conList;
        // Number Of Campaigns
        List<Campaign> campList = new List<Campaign>();
        for (Integer l=1;l<NumOfCamp+1;l++){
            Campaign campObj = New Campaign();
            campObj.Name = 'TestDataCampaign'+ l;
            campObj.IsActive = True;
            campObj.StartDate= system.today();
            campObj.EndDate = system.today() + 30;
            campObj.Status = 'In Progress';
            campList.add(campObj);
        }
        insert campList;
        List<CampaignMember> campMemList = new List<CampaignMember>();
        for(Integer m=0;m<campList.size();m++){
            Campaign cmpObj = campList[m];
            for (Integer n=0;n<conList.size();n++){
                Contact cont = conList[n];
                CampaignMember cm = New CampaignMember();
                cm.CampaignId = cmpObj.Id;
                cm.ContactId = cont.Id;
                cm.Status = 'Sent';
                campMemList.add(cm);
            }
        }
        insert campMemList;
   }
}