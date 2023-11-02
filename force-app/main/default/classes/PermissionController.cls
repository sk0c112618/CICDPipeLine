public class PermissionController {
    public static List<string> fieldApiNmForCst;
    public static List<string> fieldApiNmForStd;
    public static string selectedObjName;
    public static List<string> profileAllVal;
    public static List<String> fieldPermissionsNewList;
   
    public static Map<String,String> fieldPermissionsNewMapForReadStd;
    public static Map<String,String> fieldPermissionsNewMapForEditStd;
   
    public static Map<String,String> fieldPermissionsNewMapForReadCst;
    public static Map<String,String> fieldPermissionsNewMapForEditCst;
    public class PermissionDataWrapper {
        //below have standard filds of selected object
        @AuraEnabled
        public List<Map<String, String>> standardFieldList { get; set; }
        //below have custom filds of selected object
        @AuraEnabled
        public List<Map<String, String>> customFieldList { get; set; }
        //below have data of read edit (true , false)
        @AuraEnabled
        public Map<String, List<FieldPermissions>> fieldPermissionsMap { get; set; }
    }
   
    @AuraEnabled
    public static PermissionDataWrapper getData(String selectedObject, List<String> allValues) {
        try {
            selectedObjName = selectedObject;
            profileAllVal = allValues;
            fieldApiNmForCst = new List<string>();
            fieldApiNmForStd = new List<string>();
            List<Map<String, String>> standardFieldList = new List<Map<String, String>>();
            List<Map<String, String>> customFieldList = new List<Map<String, String>>();
           
            // Get object describe details
            Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(selectedObjName).getDescribe();
            // Select object field info
            Map<String, Schema.SObjectField> fieldsMap = objectDescribe.fields.getMap();
            // For the custom fields
            List<Schema.DescribeFieldResult> fieldDescribeListCustom = new List<Schema.DescribeFieldResult>();
            List<Schema.DescribeFieldResult> fieldDescribeListStandard = new List<Schema.DescribeFieldResult>();
           
            for (String fieldName : fieldsMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
               
                if (fieldDescribe.isCustom()) {
                    fieldApiNmForCst.add(fieldDescribe.getName());
                    fieldDescribeListCustom.add(fieldDescribe);
                }
                if (!fieldDescribe.isCustom()) {
                    fieldApiNmForStd.add(fieldDescribe.getName());
                    fieldDescribeListStandard.add(fieldDescribe);
                }
            }
           
            PermissionDataWrapper permissionData = new PermissionDataWrapper();
            // Set the values in the permissionData wrapper
            permissionData.standardFieldList = getFieldInfoMapForStd(fieldDescribeListStandard);
            permissionData.customFieldList = getFieldInfoMap(fieldDescribeListCustom);
            return permissionData;
        } catch(exception ex){
           
            /*cl_eme__Metadata_Exception_log__c exceptionRecord = new cl_eme__Metadata_Exception_log__c();
            exceptionRecord.Name = ex.getMessage();
            exceptionRecord.cl_eme__Line_number__c = ex.getStackTraceString();
            insert exceptionRecord;*/
            return null; // or any appropriate action you want to take
           
        }
    }    
    //below have data of read edit (true , false)
    // For the Custom readable permissions
    public void getFieldPermissionsMapForRead(String selectedObject, List<String> allValues,List<string> fieldApiNmForCst) {
        fieldPermissionsNewMapForReadCst = new Map<String,String>();
        fieldPermissionsNewMapForEditCst = new Map<String,String>();
        List<FieldPermissions>getFieldPerData = new List<FieldPermissions>();
        Set<String> profileNmSet = new Set<string>();
       
        List<FieldPermissions> objectFieldsList =  [
            SELECT Id, SobjectType, Field, PermissionsRead,PermissionsEdit, Parent.Profile.Name
            FROM FieldPermissions
            WHERE SobjectType = :selectedObject AND Parent.Profile.Name IN :allValues
            ORDER BY Parent.Profile.Name, Field
        ];
        Map<String,String> fieldMap = new Map<String,String>();
       
        for(string fieldApNm:fieldApiNmForCst){
            if(!fieldMap.containsKey(selectedObject + '.' + fieldApNm)){
                fieldMap.put(selectedObject + '.' + fieldApNm,fieldApNm);
            }
        }
        //Readable
        For(FieldPermissions fieldPermissionObj : objectFieldsList){
            //for(string fieldApNm:fieldApiNmForCst){
            //Readable
            if(fieldMap.containskey(fieldPermissionObj.field)){
               
                if(fieldPermissionObj.Field.contains(fieldMap.get(String.valueOf(fieldPermissionObj.field)))){
                    if(fieldPermissionsNewMapForReadCst.containsKey(fieldPermissionObj.field))
                        fieldPermissionsNewMapForReadCst.put(fieldPermissionObj.field, fieldPermissionsNewMapForReadCst.get(fieldPermissionObj.field) + ',' + fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsRead);
                    else
                        fieldPermissionsNewMapForReadCst.put(fieldPermissionObj.field, fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsRead);
                }
                //Editable
                // fieldApNm = selectedObject + '.' + fieldApNm;
                if(fieldPermissionObj.Field.contains(fieldMap.get(String.valueOf(fieldPermissionObj.field)))){
                    if(fieldPermissionsNewMapForEditCst.containsKey(fieldPermissionObj.field))
                        fieldPermissionsNewMapForEditCst.put(fieldPermissionObj.field, fieldPermissionsNewMapForEditCst.get(fieldPermissionObj.field) + ',' + fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsEdit);
                    else
                        fieldPermissionsNewMapForEditCst.put(fieldPermissionObj.field, fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsEdit);
                }                
            }
        }
    }
    //For Standard Permission
    public void getFieldPermissionsMapForReadForStd(String selectedObject, List<String> allValues,List<string> fieldApiNmForStd) {
        fieldPermissionsNewMapForReadStd = new Map<String,String>();
        fieldPermissionsNewMapForEditStd = new Map<String,String>();
        List<FieldPermissions>getFieldPerData = new List<FieldPermissions>();
        Set<String> profileNmSet = new Set<string>();
       
        List<FieldPermissions> objectFieldsList =  [
            SELECT Id, SobjectType, Field, PermissionsRead,PermissionsEdit,Parent.Profile.Name
            FROM FieldPermissions
            WHERE SobjectType = :selectedObject AND Parent.Profile.Name IN :allValues
            ORDER BY Parent.Profile.Name, Field
        ];
       
        Map<String,String> fieldMap = new Map<String,String>();
       
        for(string fieldApNm:fieldApiNmForStd){
            if(!fieldMap.containsKey(selectedObject + '.' + fieldApNm)){
                fieldMap.put(selectedObject + '.' + fieldApNm,fieldApNm);
            }
        }
        For(FieldPermissions fieldPermissionObj : objectFieldsList){
            //Readable
            if(fieldMap.containskey(fieldPermissionObj.field)){
                if(fieldPermissionObj.Field.contains(fieldMap.get(String.valueOf(fieldPermissionObj.field)))){
                    if(fieldPermissionsNewMapForReadStd.containsKey(fieldPermissionObj.field))
                        fieldPermissionsNewMapForReadStd.put(fieldPermissionObj.field, fieldPermissionsNewMapForReadStd.get(fieldPermissionObj.field) + ',' + fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsRead);
                    else
                        fieldPermissionsNewMapForReadStd.put(fieldPermissionObj.field, fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsRead);
                }
                //Editable
                if(fieldPermissionObj.Field.contains(fieldMap.get(fieldPermissionObj.field))){
                    if(fieldPermissionsNewMapForEditStd.containsKey(fieldPermissionObj.field))
                        fieldPermissionsNewMapForEditStd.put(fieldPermissionObj.field, fieldPermissionsNewMapForEditStd.get(fieldPermissionObj.field) + ',' + fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsEdit);
                    else
                        fieldPermissionsNewMapForEditStd.put(fieldPermissionObj.field, fieldPermissionObj.Parent.Profile.Name + '=>' + fieldPermissionObj.PermissionsEdit);
                }
            }  
        }
       
       
    }
    //Custom Field
    @TestVisible
    private static List<Map<String, String>> getFieldInfoMap(List<Schema.DescribeFieldResult> fieldDescribelst) {
        List<Map<String, String>> fields = new List<Map<String, String>>();
       
        PermissionController obj1 = new PermissionController();
        obj1.getFieldPermissionsMapForRead(selectedObjName,profileAllVal,fieldApiNmForCst);
       
        for(Schema.DescribeFieldResult fieldDescribe : fieldDescribelst){
            Map<String, String> fieldInfo = new Map<String, String>();
            fieldInfo.put('fieldApiName', fieldDescribe.getName());
            fieldInfo.put('fieldLabel', fieldDescribe.getLabel());
            fieldInfo.put('fieldHelpText', fieldDescribe.getInlineHelpText());
            fieldInfo.put('fieldDataType', String.valueOf(fieldDescribe.getType()));
            fieldInfo.put('fieldLength', String.valueOf(fieldDescribe.getLength()));
            fieldInfo.put('fieldMandatory', String.valueOf(!fieldDescribe.isNillable()));
            fieldInfo.put('isExternalId', String.valueOf(fieldDescribe.isExternalId()));
            fieldInfo.put('defaultValue', String.valueOf(fieldDescribe.getDefaultValue()));
            fieldInfo.put('formulaDefaultValue', fieldDescribe.getCalculatedFormula());
            //add
            if (fieldDescribe.isDependentPicklist()) {
                fieldInfo.put('isDependentPicklist', 'true');
                fieldInfo.put('controllingField', String.valueOf(fieldDescribe.getController()));
            }
           
            if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                fieldInfo.put('picklistValues', getPicklistValues(fieldDescribe));
            }
           
            // For Readable Key
            fieldInfo.put('Readable', 'FieldName=>' + fieldDescribe.getName());
            for(String str : fieldPermissionsNewMapForReadCst.keySet()){
                if(str.contains(fieldDescribe.getName())){
                    String readValue = fieldPermissionsNewMapForReadCst.get(str);
                    fieldInfo.put('Readable', 'FieldName=>' + fieldDescribe.getName() + ',' + readValue);  
                }
            }
            // For Editable Key
            fieldInfo.put('Editable', 'FieldName=>' + fieldDescribe.getName());
            for(String str : fieldPermissionsNewMapForEditCst.keySet()){
                if(str.contains(fieldDescribe.getName())){
                    String editValue = fieldPermissionsNewMapForEditCst.get(str);
                    fieldInfo.put('Editable', 'FieldName=>' + fieldDescribe.getName() + ',' + editValue);  
                }
            }
            for(String profileName : profileAllVal){
                String readableValue = fieldInfo.get('Readable');
                if(!readableValue.contains(profileName)){
                    fieldInfo.put('Readable',fieldInfo.get('Readable') + ',' + profileName + '=>false');
                }
                //editable
                String editableValue = fieldInfo.get('Editable');
                if(!editableValue.contains(profileName)){
                    fieldInfo.put('Editable',fieldInfo.get('Editable') + ',' + profileName + '=>false');
                }
            }
            fields.add(fieldInfo);
        }
        return fields;
    }
   
    //Standard Field
    public static  List<Map<String, String>> getFieldInfoMapForStd(List<Schema.DescribeFieldResult> fieldDescribelst) {
       
        List<Map<String, String>> fields = new List<Map<String, String>>();
       
        PermissionController obj = new PermissionController();
        obj.getFieldPermissionsMapForReadForStd(selectedObjName,profileAllVal,fieldApiNmForStd);
        for(Schema.DescribeFieldResult fieldDescribe : fieldDescribelst){
            Map<String, String> fieldInfo = new Map<String, String>();
            fieldInfo.put('fieldApiName', fieldDescribe.getName());
            fieldInfo.put('fieldLabel', fieldDescribe.getLabel());
            fieldInfo.put('fieldHelpText', fieldDescribe.getInlineHelpText());
            fieldInfo.put('fieldDataType', String.valueOf(fieldDescribe.getType()));
            fieldInfo.put('fieldLength', String.valueOf(fieldDescribe.getLength()));
            fieldInfo.put('fieldMandatory', String.valueOf(!fieldDescribe.isNillable()));
            fieldInfo.put('isExternalId', String.valueOf(fieldDescribe.isExternalId()));
            fieldInfo.put('defaultValue', String.valueOf(fieldDescribe.getDefaultValue()));
            fieldInfo.put('formulaDefaultValue', fieldDescribe.getCalculatedFormula());
            //add
            if (fieldDescribe.isDependentPicklist()) {
                fieldInfo.put('isDependentPicklist', 'true');
                fieldInfo.put('controllingField', String.valueOf(fieldDescribe.getController()));
            }
            if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                fieldInfo.put('picklistValues', getPicklistValues(fieldDescribe));
            }
           
            // For Readable Key  
            for(String str : fieldPermissionsNewMapForReadStd.keySet()){
                if(str.contains(fieldDescribe.getName())){
                    String readValue = fieldPermissionsNewMapForReadStd.get(str);
                    fieldInfo.put('Readable', 'FieldName=>' + fieldDescribe.getName() + ',' + readValue);  
                }
            }
            // For Editable Key
            for(String str : fieldPermissionsNewMapForEditStd.keySet()){
                if(str.contains(fieldDescribe.getName())){
                    String editValue = fieldPermissionsNewMapForEditStd.get(str);
                    fieldInfo.put('Editable', 'FieldName=>' + fieldDescribe.getName() + ',' + editValue);  
                }            
            }
           
            for(String profileName : profileAllVal){
                String readableValue = fieldInfo.get('Readable');
                if(String.isNotBlank(readableValue) && !readableValue.contains(profileName)){
                    fieldInfo.put('Readable',fieldInfo.get('Readable') + ',' + profileName + '=>false');
                }
                String editableValue = fieldInfo.get('Editable');
                if(String.isNotBlank(editableValue) && !editableValue.contains(profileName)){
                    fieldInfo.put('Editable',fieldInfo.get('Editable') + ',' + profileName + '=>false');
                }
            }
            fields.add(fieldInfo);
        }
       
        return fields;
    }
    // use to get picklist values comma seprated
    public static String getPicklistValues(Schema.DescribeFieldResult fieldDescribe) {
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        List<String> values = new List<String>();
       
        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            values.add(picklistEntry.getValue());
        }
        return String.join(values, ',');
    }
   
    //Custom Field
    public static Map<String, String> getFieldInfoMapMerge(Schema.DescribeFieldResult fieldDescribe,List<string>  fieldApiNm) {
        Map<String, String> fieldInfo = new Map<String, String>();
        fieldInfo.put('fieldApiName', fieldDescribe.getName());
        fieldInfo.put('fieldLabel', fieldDescribe.getLabel());
        fieldInfo.put('fieldHelpText', fieldDescribe.getInlineHelpText());
        fieldInfo.put('fieldDataType', String.valueOf(fieldDescribe.getType()));
        fieldInfo.put('fieldLength', String.valueOf(fieldDescribe.getLength()));
        fieldInfo.put('fieldMandatory', String.valueOf(!fieldDescribe.isNillable()));
        fieldInfo.put('isExternalId', String.valueOf(fieldDescribe.isExternalId()));
        fieldInfo.put('defaultValue', String.valueOf(fieldDescribe.getDefaultValue()));
        fieldInfo.put('formulaDefaultValue', fieldDescribe.getCalculatedFormula());
        //add
        if (fieldDescribe.isDependentPicklist()) {
            fieldInfo.put('isDependentPicklist', 'true');
            fieldInfo.put('controllingField', String.valueOf(fieldDescribe.getController()));
        }
       
        if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
            fieldInfo.put('picklistValues', getPicklistValues(fieldDescribe));
        }
        PermissionController obj1 = new PermissionController();
        obj1.getFieldPermissionsMapForRead(selectedObjName,profileAllVal,fieldApiNm);
        // For Readable Key
        fieldInfo.put('Readable', 'FieldName=>' + fieldDescribe.getName());
        for(String str : fieldPermissionsNewMapForReadCst.keySet()){
            if(str.contains(fieldDescribe.getName())){
                String readValue = fieldPermissionsNewMapForReadCst.get(str);
                fieldInfo.put('Readable', 'FieldName=>' + fieldDescribe.getName() + ',' + readValue);  
            }
        }
        // For Editable Key
        fieldInfo.put('Editable', 'FieldName=>' + fieldDescribe.getName());
        for(String str : fieldPermissionsNewMapForEditCst.keySet()){
            if(str.contains(fieldDescribe.getName())){
                String editValue = fieldPermissionsNewMapForEditCst.get(str);
                fieldInfo.put('Editable', 'FieldName=>' + fieldDescribe.getName() + ',' + editValue);  
            }
        }
        for(String profileName : profileAllVal){
            String readableValue = fieldInfo.get('Readable');
            if(!readableValue.contains(profileName)){
                fieldInfo.put('Readable',fieldInfo.get('Readable') + ',' + profileName + '=>false');
            }
            //editable
            String editableValue = fieldInfo.get('Editable');
            if(!editableValue.contains(profileName)){
                fieldInfo.put('Editable',fieldInfo.get('Editable') + ',' + profileName + '=>false');
            }
        }
        return fieldInfo;
    }
   
}