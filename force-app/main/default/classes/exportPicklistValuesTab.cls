/*
    Name : objectListController.cls
    Author: Shubham Vaishnav
    Company: CRM Landing
    History:
    Version 1.0 
*/

// This is a controller class for retrieving picklist information for specified object names
public with sharing class exportPicklistValuesTab {

/*
    @description       : This method retrieves picklist information for specified object names and returns a list of object picklist information. 
    @author            : Shubham Vaishnav
    @last modified on  : 22-22-2023
    @last modified by  : Shubham Vaishnav
    @param List<String> objectNames
    @return  objectPicklistInfoList;
*/

   @AuraEnabled(cacheable=true)
    public static List<ObjectPicklistInfo> getObjectsPicklistInfo(List<String> objectNames) {
        List<ObjectPicklistInfo> objectPicklistInfoList = new List<ObjectPicklistInfo>();
        
        for (String objectName : objectNames) {
            ObjectPicklistInfo objectPicklistInfo = new ObjectPicklistInfo();
            objectPicklistInfo.objectName = objectName;
            objectPicklistInfo.picklistInfoList = new List<PicklistInfo>();
            
            // Fetch the object's describe information
            Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
            
            // Get the field describe results for all fields
            Map<String, Schema.SObjectField> fieldsMap = objectDescribe.fields.getMap();
            
            for (String fieldName : fieldsMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
                
                // Check if the field is a picklist
                if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
                    PicklistInfo info = new PicklistInfo();
                    info.fieldLabel = fieldDescribe.getLabel();
                    info.fieldApiName = fieldDescribe.getName();
                    info.picklistValues = new List<String>();
                    
                    // Fetch the picklist values
                    List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
                    for (Schema.PicklistEntry picklistEntry : picklistValues) {
                        info.picklistValues.add(picklistEntry.getLabel() + ':' + picklistEntry.getValue());
                    }
                    
                    objectPicklistInfo.picklistInfoList.add(info);
                }
            }
            
            objectPicklistInfoList.add(objectPicklistInfo);
        }
        
        return objectPicklistInfoList;
    }
    
    // Inner class representing object picklist information
    public class ObjectPicklistInfo {
        @AuraEnabled
        public String objectName { get; set; } // Represents the name of the object
        
        @AuraEnabled
        public List<PicklistInfo> picklistInfoList { get; set; } // Represents a list of picklist information for the object
    }
    
    // Inner class representing picklist information
    public class PicklistInfo {
        @AuraEnabled
        public String fieldLabel { get; set; } // Represents the label of the picklist field
        
        @AuraEnabled
        public String fieldApiName { get; set; } // Represents the API name of the picklist field
        
        @AuraEnabled
        public List<String> picklistValues { get; set; } // Represents the list of picklist values for the field
    }
}