public class ContactTriggerHelper {
    Public static void afterInsert(List<Contact> contactList){
        List<Contact> conList = new List<Contact>();
        for (Contact conObj : contactList){
            if (conObj.Email != null){
                conList.add(conObj);
            }
        }
        If(!conList.IsEmpty()){
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
            EmailTemplate templateId = [select Id, Name FROM EmailTemplate where Name ='Contact Acknowledgement Mail'];
            for(Contact coObj : conList){ 
                if(CoObj.Email != null ){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = new String[] {coObj.Email};
                        message.setTreatTargetObjectAsRecipient(false);
                    message.setTargetObjectId(coObj.id);
                    message.setTemplateID(templateId.Id);
                    mails.add(message);
                }
            }
            If(!mails.isEmpty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
            }
        }
    }
    Public static void duplicateContact(List<Contact> contactList){
        Set<String> EmailSet = new Set<String>();
        Set<String> PhoneSet = new Set<String>();
        List<Contact> conList = new List<Contact>();
        Map<Id,String> conMapPhone = new Map<Id,String>();
        for (Contact conObj : contactList){
            if(conObj.Email != null){
                EmailSet.add(conObj.Email);
                conList.add(conObj);
            }
            If(conObj.Phone != null){
                PhoneSet.add(conObj.Phone);
                conList.add(conObj);
            }
        }
        if(!EmailSet.isEmpty() && !PhoneSet.isEmpty()){
            Map<Id,Contact> conMap = new Map<Id,Contact>([Select id,Email,Phone from contact where Email in :EmailSet or Phone in :PhoneSet]);
            Set<String> EmailSetmain = new Set<String>();
            Set<String> PhoneSetmain = new Set<String>();
            for (Contact con : conMap.values()){
                if(con.Email != null){
                    EmailSetmain.add(con.Email);
                }
                If(con.Phone != null){
                    PhoneSetmain.add(con.Phone);
                }	
            }
            for (Contact conL : conList){
                If(conL.Email != null && ConL.Phone != null){
                    if(EmailSetmain.contains(conL.Email) || PhoneSetmain.contains(conL.Phone) ){conL.addError('Contact already Exists');}
                } 
            }
        }else if (!EmailSet.isEmpty()){
            Map<Id,Contact> conMap = new Map<Id,Contact>([Select id,Email,Phone from contact where Email in :EmailSet]);
            Set<String> EmailSetmain = new Set<String>();
            for (Contact con : conMap.values()){
                if(con.Email != null){
                    EmailSetmain.add(con.Email);
                }	
            }
            for (Contact conL : conList){
                If(conL.Email != null ){
                    if(EmailSetmain.contains(conL.Email) ){conL.addError('Contact already Exists');}
                } 
            }
        }else if (!conMapPhone.isEmpty()){
            Map<Id,Contact> conMap = new Map<Id,Contact>([Select id,Email,Phone from contact where Email in :PhoneSet]);
            Set<String> PhoneSetmain = new Set<String>();
            for (Contact con : conMap.values()){
                if(con.Phone != null){
                    PhoneSetmain.add(con.Phone);
                }	
            }
            for (Contact conL : conList){
                If(conL.Phone != null ){
                    if(PhoneSetmain.contains(conL.Phone) ){conL.addError('Contact already Exists');}
                } 
            }
        }
    }
}