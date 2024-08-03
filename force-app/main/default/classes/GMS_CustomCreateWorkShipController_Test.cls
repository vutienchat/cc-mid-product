@isTest
public class GMS_CustomCreateWorkShipController_Test {
    @isTest
    static void testGetGlobalPicklistValues() {
        // Create a test User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(
            Alias = 'testU',
            Email = 'testU@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testU@testorg.com'
        );
        insert testUser;
        
        System.runAs(testUser) {
            // Create a test Master Data record
            Master_Data__c testMasterData = new Master_Data__c(
                Name = 'Test Master Data',
                User_uses__c = testUser.Id,
                Unit_by_region__c = 'C1_MFS' // Set the Unit_by_region__c value
            );
            insert testMasterData;
            
            // Call the controller method
            List<GMS_CustomCreateWorkShipController.PicklistValue> result = GMS_CustomCreateWorkShipController.getGlobalPicklistValues();
            
        }
    }
    
    @isTest
    static void testGetAgentByPartner() {
        // Create a test Master Data record for Agent
        Master_Data__c testAgent = new Master_Data__c(
            Name = 'Test Agent',
            Unit_by_region__c = 'C1_MFS',
            RecordTypeId = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByName().get('Agent').getRecordTypeId()
        );
        insert testAgent;
        
        // Call the controller method
        List<GMS_CustomCreateWorkShipController.PicklistValue> result = GMS_CustomCreateWorkShipController.getAgentByPartner('C1_MFS');
    }
}