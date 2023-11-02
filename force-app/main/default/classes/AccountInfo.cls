@RestResource(urlMapping='/getAccount')
global class AccountInfo {
	@HTTPPOST
    global static AccountInfo.resultwrapper returndata(){
        RestRequest req = RestContext.request;
        String jsonStr = req.requestBody.toString();
        AccountInfo.AccWrapper accWrapperObj = (AccountInfo.AccWrapper)Json.deserialize(jsonStr, AccountInfo.AccWrapper.class);
        String strName = '%' + accWrapperObj.accNm +'%';
        List<Account> accList = [Select Name,Phone,Website from account Where Name like :strName];
        system.debug('Main'+accList);
        String strWebsite = '';
        if(!accList.isEmpty()){
            for (Account accObj : accList){
                if(accObj.Website != null){
                    if(strWebsite == ''){
                        strWebsite = accObj.website;
                    }else if (accObj.Website != '' && !strwebsite.contains(accObj.website)){
                        strWebsite = strWebsite + ',' + accObj.website;
                    }
                }
            }
        }
        AccountInfo.resultwrapper resultObj = new AccountInfo.resultwrapper();
        resultObj.result = strWebsite;
        return resultObj;
    }
    
    global class AccWrapper{
        public string accNm;
        public string accweb;
    }
    
    global class resultwrapper{
        public string result;
    }
}