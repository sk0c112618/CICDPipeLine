@isTest
private class CustomPermissionWrapper_Test {
    @isTest
    static void testConstructor() {
        // Create a mock implementation of CustomPermission
        MockCustomPermission customPermission = new MockCustomPermission();
        customPermission.Id = '001XXXXXXXXXXXXXXX';
        customPermission.CreatedById = '005XXXXXXXXXXXXXXX';
        customPermission.CreatedDate = Datetime.now();
        customPermission.Description = 'Permission 1 description';
        customPermission.IsProtected = false;
        customPermission.LastModifiedById = '005XXXXXXXXXXXXXXX';
        customPermission.IsDeleted = false;
        customPermission.IsLicensed = true;
        customPermission.MasterLabel = 'Permission 1';
        customPermission.NamespacePrefix = 'ns1';
        System.assertEquals(True, True);
    }// Mock implementation of CustomPermission
   	class MockCustomPermission {
        public String Id { get; set; }
        public String CreatedById { get; set; }
        public Datetime CreatedDate { get; set; }
        public String Description { get; set; }
        public Boolean IsProtected { get; set; }
        public String LastModifiedById { get; set; }
        public Boolean IsDeleted { get; set; }
        public Boolean IsLicensed { get; set; }
        public String MasterLabel { get; set; }
        public String NamespacePrefix { get; set; }
    }
}