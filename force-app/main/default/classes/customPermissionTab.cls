/*
Name : customPermissionTab.cls
Author: Yash Dagdi
Company: CRM Landing
History:
Version 1.0 date 
*/

public with sharing class customPermissionTab {
    
    // Inner class to wrap the CustomPermission object and expose only the required fields
    public class CustomPermissionWrapper {
        @AuraEnabled
        public String Id { get; set; }
        @AuraEnabled
        public String DeveloperName { get; set; }
        @AuraEnabled
        public String CreatedByName { get; set; }
        @AuraEnabled
        public Datetime CreatedDate { get; set; }
        @AuraEnabled
        public String Description { get; set; }
        @AuraEnabled
        public Boolean IsProtected { get; set; }
        @AuraEnabled
        public String LastModifiedByName { get; set; }
        @AuraEnabled
        public Boolean IsDeleted { get; set; }
        @AuraEnabled
        public Boolean IsLicensed { get; set; }
        @AuraEnabled
        public String MasterLabel { get; set; }
        @AuraEnabled
        public String NamespacePrefix { get; set; }
        
        
        // Constructor to populate the wrapper object with data from CustomPermission object
        public CustomPermissionWrapper(CustomPermission customPermission) {
            this.Id = customPermission.Id;
            this.DeveloperName = customPermission.DeveloperName;
            this.CreatedByName = customPermission.CreatedBy.Name;
            this.CreatedDate = customPermission.CreatedDate;
            this.Description = customPermission.Description;
            this.IsProtected = customPermission.IsProtected;
            this.LastModifiedByName = customPermission.LastModifiedBy.Name;
            this.IsDeleted = customPermission.IsDeleted;
            this.IsLicensed = customPermission.IsLicensed;
            this.MasterLabel = customPermission.MasterLabel;
            this.NamespacePrefix = customPermission.NamespacePrefix;
        }
    }
    
    /*
@description       : getCustomPermissions Method to retrieve a list of CustomPermissionWrapper objects
@author            : Yash Dagdi
@last modified on  : 22-22-2023
@last modified by  : Yash Dagdi
@param String 
@return  customPermissions;
*/
    @AuraEnabled(cacheable=true)
    public static List<CustomPermissionWrapper> getCustomPermissions() {
        List<CustomPermissionWrapper> customPermissions = new List<CustomPermissionWrapper>();
        
        // Query CustomPermission records and retrieve the required fields
        List<CustomPermission> customPermissionList = [SELECT Id, DeveloperName, CreatedBy.Name, CreatedDate, Description, IsProtected, LastModifiedBy.Name, IsDeleted, IsLicensed, MasterLabel, NamespacePrefix FROM CustomPermission];
        
        // Iterate over the queried records and create CustomPermissionWrapper objects
        for (CustomPermission customPermission : customPermissionList) {
            CustomPermissionWrapper wrapper = new CustomPermissionWrapper(customPermission);
            customPermissions.add(wrapper);
        }
        
        return customPermissions; // Return the list of CustomPermissionWrapper objects
    }
}