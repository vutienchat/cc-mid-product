@isTest
public class UploadWorkShipController_Test {
    
    static testmethod void testfileupload(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            EmailEncodingKey = 'UTF-8',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            Region__c = '1', // Custom field
            CompanyName = 'Test Company',
            Title = 'Test Title',
            Phone = '1234567890'
        );
        insert testUser;

        
        Master_Data__c mdt = new Master_Data__c();
        mdt.Name = 'Test';
        mdt.Agent_Code__c = '1234';
        mdt.Email__c = 'test1234@gmail.com';
        mdt.Unit_by_region__c = 'C1_MFS';
        mdt.User_uses__c = testUser.Id;
        insert mdt;
        
         
        date myDate = date.today();
        String month = string.valueOf(myDate.month());
        String year = string.valueOf(myDate.year());
        
        String base64Data = '\"STT,Họ Tên, DS, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31\\r\\n1,Test1.com,1234,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00,8:00-14:00\\r\\n\"';

        String data = JSON.deserializeUntyped(base64Data).toString();
        list<String> lstCSVLines = data.split('\n');
        
        for(Integer i = 1; i < lstCSVLines.size(); i++) {
            UploadWorkShipController.saveFile(lstCSVLines[i], month, year, 'C1_MFS');   
        }
        
        Test.startTest();
        
        UploadWorkShipController.deleteWorkShipLineItem(month, year, 'C1_MFS');
        Test.stopTest();
        
        List<Work_Management__c> lst = new List<Work_Management__c>();
        Work_Management__c w = new Work_Management__c();
        w.shift__c = '8:00-14:00';
        w.Agent__c = mdt.Id;
        w.Working_Date__c = date.today();
        lst.add(w);
        System.runAs(testUser) {
        UploadWorkShipController.createWorkship(lst, 'C1_MFS');
        UploadWorkShipController.getGlobalPicklistValues();
        UploadWorkShipController.getDefaulValuePartner();
        }
    }
}