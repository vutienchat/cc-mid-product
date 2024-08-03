@isTest
public class R1_HandlerCheckShiftForAgent_Test {
    @isTest
    static void testGetShiftForAgent() {
        // Tạo dữ liệu giả cho User
        User testUser = new User(
            Username = 'testuffser@test.com',
            LastName = 'Test',
            Email = 'testusffser@test.com',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'][0].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        // Tạo dữ liệu giả cho Master_Data__c
        Master_Data__c masterData = new Master_Data__c(
            Name = 'Test Master Data',
            Shift_inprogress__c = null
        );
        insert masterData;
        
        // Tạo dữ liệu giả cho Work_Management__c
        Work_Management__c workManagement = new Work_Management__c(
            Name = 'Test Work Management',
            Shift__c = 'Morning'
        );
        insert workManagement;
        
        // Cập nhật User với Id_Agent_Using__c
        testUser.Id_Agent_Using__c = masterData.Id;
        update testUser;
        
        // Cập nhật Master_Data__c với Shift_inprogress__c
        masterData.Shift_inprogress__c = workManagement.Id;
        update masterData;
        
        // Chạy phương thức getShiftForAgent trong môi trường kiểm thử
        Test.startTest();
        String shift = R1_HandlerCheckShiftForAgentController.getShiftForAgent();
        Test.stopTest();

    }
}