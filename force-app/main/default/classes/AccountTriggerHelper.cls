public class AccountTriggerHelper {
    public static void beforeInsert(List<Account> accList){
        for (Account accObj: accList){
            if(accObj.BillingCity != null){accObj.ShippingCity = accObj.BillingCity;}
            if(accObj.BillingCountry != null){accObj.ShippingCountry = accObj.BillingCountry;}
            if(accObj.BillingPostalCode != null){accObj.ShippingPostalCode = accObj.BillingPostalCode;}
            if(accObj.BillingState != null){accObj.ShippingState = accObj.BillingState;}
            if(accObj.BillingStreet != null){accObj.ShippingStreet = accObj.BillingStreet;}
        }
    }
}