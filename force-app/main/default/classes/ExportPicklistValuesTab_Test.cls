@isTest
private class ExportPicklistValuesTab_Test {
    @isTest
    static void testGetObjectsPicklistInfo() {
        // Create test data
        List<String> objectNames = new List<String>{'Account', 'Contact'};
        
        // Call the method to be tested
        List<ExportPicklistValuesTab.ObjectPicklistInfo> result = ExportPicklistValuesTab.getObjectsPicklistInfo(objectNames);
        
        // Perform assertions
        System.assertEquals(2, result.size(), 'Incorrect number of object picklist info');
        
        // Assert the first object picklist info
        ExportPicklistValuesTab.ObjectPicklistInfo object1 = result[0];
      //  System.assertEquals('Account', object1.objectName, 'Incorrect object name');
      //  System.assertEquals(12, object1.picklistInfoList.size(), 'Incorrect number of picklist info for Account');
        
        // Assert the first picklist info for Account
        ExportPicklistValuesTab.PicklistInfo picklist1 = object1.picklistInfoList[0];
        System.assertEquals('Type', picklist1.fieldLabel, 'Incorrect field label for Account.Type');
       // System.assertEquals('Type', picklist1.fieldApiName, 'Incorrect field API name for Account.Type');
       // System.assertEquals(3, picklist1.picklistValues.size(), 'Incorrect number of picklist values for Account.Type');
        
        // Assert the second object picklist info
        ExportPicklistValuesTab.ObjectPicklistInfo object2 = result[1];
        System.assertEquals('Contact', object2.objectName, 'Incorrect object name');
      //  System.assertEquals(2, object2.picklistInfoList.size(), 'Incorrect number of picklist info for Contact');
        
        // Assert the second picklist info for Contact
        ExportPicklistValuesTab.PicklistInfo picklist2 = object2.picklistInfoList[0];
        System.assertEquals('Salutation', picklist2.fieldLabel, 'Incorrect field label for Contact.Salutation');
      //  System.assertEquals('Salutation', picklist2.fieldApiName, 'Incorrect field API name for Contact.Salutation');
      //  System.assertEquals(5, picklist2.picklistValues.size(), 'Incorrect number of picklist values for Contact.Salutation');
        
        // Perform additional assertions or test cases as needed
        
        // ...
    }
}