@isTest 
public class TestContactTrigger {
    @isTest public static void beforeInsert(){
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Phone = '1234567891';
        insert acc;
        Contact c = new Contact(AccountId = acc.Id);
        c.LastName = 'Test_1';
        c.Phone = '0000000000';
        insert c;
        Account act = [Select Id,Phone,Number_of_Contacts__c From Account Limit 1];
        System.assertEquals('0000000000',act.Phone );
        System.assertEquals(1 , act.Number_of_Contacts__c);
        Contact co = [Select Id,LastName, Phone From Contact Limit 1];
        co.Phone = '2222222222';
        Update co;
        Account act_1 = [Select Id,Phone,Number_of_Contacts__c From Account Limit 1];
        system.assertEquals('2222222222',act_1.Phone);
    }
    @isTest public static void afterundeletetest(){
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Phone = '1234567891';
        insert acc;
        Contact c = new Contact(AccountId = acc.Id);
        c.LastName = 'Test_1';
        c.Phone = '0000000000';
        insert c;
        Contact co = new Contact(AccountId = acc.Id);
        co.LastName = 'Test_1';
        co.Phone = '1111111111';
        insert co;
        
       	delete co;
        Account act = [Select Id,Phone,Number_of_Contacts__c From Account Limit 1];
        System.assertEquals('0000000000',act.Phone );
    }
    
}