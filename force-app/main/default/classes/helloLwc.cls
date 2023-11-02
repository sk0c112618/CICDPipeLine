public with sharing class helloLwc {
    @AuraEnabled(cacheable=true)
    public static List<Account> getContactList() {
        return [
            SELECT Id, Name,Industry
            FROM Account
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }
}