@istest
public class CreateRecordInWorkShift_Test {
    @testSetup
    static void setupTestData() {
        // Tạo Profile cho User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        
        // Tạo User kiểm thử
        User testUser = new User(
            Username = 'testuser1234567890@test.com',
            LastName = 'Test',
            Email = 'testuser1234567890@test.com',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
    }
    
    @isTest
    static void testInsertListWorkShift() {
        // Đăng nhập người dùng kiểm thử
        User testUser = [SELECT Id FROM User WHERE Username = 'testuser1234567890@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Tạo dữ liệu kiểm thử cho FlowInputs
            List<Id> agentIds = new List<Id>();
            for (Integer i = 0; i < 5; i++) {
                Master_Data__c agent = new Master_Data__c(Name = 'Test Agent ' + i);
                insert agent;
                agentIds.add(agent.Id);
            }
            
            CreateRecordInWorkShift.FlowInputs input = new CreateRecordInWorkShift.FlowInputs();
            input.idAgent = agentIds;
            input.fromTime = '08:00';
            input.toTime = '17:00';
            input.fromDate = Date.today();
            input.toDate = Date.today().addDays(2);
            input.key = 'TestKey';
            input.partner = 'TestPartner';
            
            List<CreateRecordInWorkShift.FlowInputs> inputs = new List<CreateRecordInWorkShift.FlowInputs>{input};
                
                // Chạy phương thức insertListWorkShift
                Test.startTest();
            CreateRecordInWorkShift.insertListWorkShift(inputs);
            Test.stopTest();
        }
    }
}