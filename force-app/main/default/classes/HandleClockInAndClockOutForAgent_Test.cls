@isTest
public class HandleClockInAndClockOutForAgent_Test {
    
    private class RestMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{' +
                '"responseCode": "200",' +
                '"responseMessage": "Thành công",' + 
                '"responseData": {' +
                '"agentId": "2a00d624-ee7d-4736-bb11-0e70a373e243",' +
                '"agentStatus": "$Cmn_Ready",' +
                '"deleted": false' +
                '}' +
                '}';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
        
    @testSetup
    static void setupTestData() {
        // Tạo Profile cho User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        
        Id recordTypeId = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        // Tạo User kiểm thử
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
            recordTypeId = idPlan,
            Clock_in__c = datetime.now().addhours(-3),
            Shift__c = '8:00-22:00',
            Channel__c = 'Kênh số'
        );
        insert workManagement; 
        
        // Tạo dữ liệu kiểm thử cho Master_Data__c và Work_Management__c
        Master_Data__c masterData = new Master_Data__c(
            Name = 'Test Agent',
            Agent_Id__c = '2a00d624-ee7d-4736-bb11-0e70a373e243',
            recordTypeId = recordTypeId,
            isClockIn__c = true,
            Shift_inprogress__c = string.valueOf(workManagement.id)
        );
        insert masterData;
        
        workManagement.Agent__c = masterData.Id;
        update workManagement;
        
    }
    
    @isTest
    static void testSearchAgent() {
        // Đăng nhập người dùng kiểm thử
        User testUser = [SELECT Id, Extension_Number__c FROM User WHERE Username = 'testusffffer@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Chạy phương thức SearchAgent
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RestMock());
            List<HandleClockInAndClockOutForAgent.MasterDataWrapper> agents = HandleClockInAndClockOutForAgent.SearchAgent();
            Test.stopTest();

        }
    }
    
    @isTest
    static void testCheckOnlineAgent() {
        // Đăng nhập người dùng kiểm thử
        User testUser = [SELECT Id, Extension_Number__c FROM User WHERE Username = 'testusffffer@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Chạy phương thức checkOnlineAgent
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RestMock());
            HandleClockInAndClockOutForAgent.MasterDataWrapper result = HandleClockInAndClockOutForAgent.checkOnlineAgent();
            Test.stopTest();
        }
    }
    
    @isTest
    static void testHandleChooseAgent() {
        // Đăng nhập người dùng kiểm thử
        User testUser = [SELECT Id, Extension_Number__c FROM User WHERE Username = 'testusffffer@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Lấy ID của agent kiểm thử
            Master_Data__c agent = [SELECT Id FROM Master_Data__c WHERE Name = 'Test Agent' LIMIT 1];
            
            // Chạy phương thức HandleChooseAgent
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RestMock());
            Master_Data__c result = HandleClockInAndClockOutForAgent.HandleChooseAgent(agent.Id);
            Test.stopTest();
            
        }
    }
    
    @isTest
    static void testUpdateClockIn() {
        // Đăng nhập người dùng kiểm thử
        User testUser = [SELECT Id, Extension_Number__c FROM User WHERE Username = 'testusffffer@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Lấy ID của agent kiểm thử
            Master_Data__c agent = [SELECT Id FROM Master_Data__c WHERE Name = 'Test Agent' LIMIT 1];
            
            // Chạy phương thức UpdateClockIn
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RestMock());
            HandleClockInAndClockOutForAgent.MasterDataWrapper result = HandleClockInAndClockOutForAgent.UpdateClockIn(agent.Id, 'kenhso');
            Test.stopTest();
        }
    }
    
    @isTest
    static void testUpdateClockOut() {
        // Đăng nhập người dùng kiểm thử
        User testUser = [SELECT Id, Extension_Number__c FROM User WHERE Username = 'testusffffer@test.com' LIMIT 1];
        System.runAs(testUser) {
            // Lấy ID của agent kiểm thử
            Master_Data__c agent = [SELECT Id FROM Master_Data__c WHERE Name = 'Test Agent' LIMIT 1];
            
            // Chạy phương thức UpdateClockOut
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RestMock());
            HandleClockInAndClockOutForAgent.MasterDataWrapper result = HandleClockInAndClockOutForAgent.UpdateClockOut(agent.Id, 'kenhso');
            Test.stopTest();
   
        }
    }
}