@isTest
public class WorKManagermentTrigger_Test {
    @isTest
    static void testDeleteWorkManagement() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        
        User testUser = new User(
            Username = 'testusffffer@test.com',
            LastName = 'Test', 
            Email = 'testusfffer@test.com',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US',
            Extension_Number__c = '1001'
        );
        insert testUser;
        
        
       Work_Management__c workManagement = new Work_Management__c(
            Name = 'Test Work Management',
            User_Using__c = testUser.Id,
            Working_Date__c = Date.today(),
            Clock_in__c = datetime.now().addhours(-3),
            Shift__c = '8:00-22:00',
            Channel__c = 'Kênh số',
           recordTypeId = idPlan
        );
        insert workManagement; 
        
        // Tạo dữ liệu kiểm thử cho Master_Data__c và Work_Management__c
        Master_Data__c masterData = new Master_Data__c(
            Name = 'Test Agent',
            Agent_Id__c = '2a00d624-ee7d-4736-bb11-0e70a373e243',
            isClockIn__c = true, 
            Shift_inprogress__c = string.valueOf(workManagement.id)
        );
        insert masterData;
        
         workManagement.Agent__c = masterData.Id;
        update workManagement; 
        
        // Tạo sự kiện xóa bản ghi Work_Management__c
        Test.startTest();
        delete workManagement;
        Test.stopTest();
    }
}