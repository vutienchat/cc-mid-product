@istest
public class R1_UploadCampaignMemberController_Test {
    @testSetup
    static void setupTestData() {
        // Create a test campaign
        Campaign testCampaign = new Campaign(Name = 'Test Campaign');
        insert testCampaign;
        
        // Create test contacts
        contact ct = new contact();
        ct.LastName = 'TestLastName';
        ct.Phone = '123456789';
        ct.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        ct.Status__c = '1';
        insert ct;
    }
    
    @isTest
    static void testSaveFile() {
        // Get the test campaign
        Campaign testCampaign = [SELECT Id FROM Campaign LIMIT 1];
        
        // Prepare CSV data
   
        String base64Data = '\"CampaignId,Phone,Status\\r\\n' + testCampaign.Id + ',123456789,Sent\\r\\nCampaignId,Phone,Status\\r\\n' + testCampaign.Id + ',359655444696,Sent\\r\\n"';
        
        Test.startTest(); 
        R1_UploadCampaignMemberController.result result = R1_UploadCampaignMemberController.saveFile(base64Data);
        Test.stopTest();
    }
    
    @isTest
    static void testSaveFileWithErrors() {
        // Get the test campaign
        Campaign testCampaign = [SELECT Id FROM Campaign LIMIT 1];
        
        // Prepare CSV data with some invalid phone numbers
       String base64Data = '\"CampaignId,Phone,Status\\r\\n' + testCampaign.Id + ',359655444696,Sent\\r\\n"';

        Test.startTest();
        R1_UploadCampaignMemberController.result result = R1_UploadCampaignMemberController.saveFile(base64Data);
        Test.stopTest();
    }
}