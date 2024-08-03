/**
* @description       : The Class for test MBFPhoneController
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.05
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@isTest
private class MBFPhoneController_Test {
    
    @testSetup
    static void setupData() {
        Soft_Phone__c settings = new Soft_Phone__c();
        settings.Name = 'endpoint_middleware';
        settings.Value__c = 'endpoint_middleware';
        insert settings;
        
        Soft_Phone__c settings1 = new Soft_Phone__c();
        settings1.Name = 'userAuthSpx';
        settings1.Value__c = 'userAuthSpx';
        insert settings1;
        
        Soft_Phone__c settings3 = new Soft_Phone__c();
        settings3.Name = 'passwordAuthSpx';
        settings3.Value__c = 'passwordAuthSpx';
        insert settings3;  
        
        Soft_Phone__c settings4 = new Soft_Phone__c();
        settings4.Name = 'endpoint_frontstage';
        settings4.Value__c = 'endpoint_frontstage';
        insert settings4;  
        
        Soft_Phone__c settings5 = new Soft_Phone__c();
        settings5.Name = 'X_API_KEY';
        settings5.Value__c = 'X_API_KEY';
        insert settings5;
        
        // Insert test data that will be used in multiple test methods
        
        Id recordTypeIdAgent = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        // Create a test Master_Data__c record
        Master_Data__c masterData = new Master_Data__c(
            Name = 'Test Master Data',
            Agent_Id__c = '12345',
            Agent_code__c = 'A123',
            Unit_by_region__c = 'C8_MFS',
            Regional_Branch__c = '8',
            Management_Unit__c = 'C8',
            recordtypeId = recordTypeIdAgent
        );
        insert masterData;
        
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Services Manager'];
        User u = new User(
            Alias = 'testuser',
            Email='testuser@gimasys.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='testuser@gimasys.com',
            Id_Agent_Using__c=masterData.Id,
            Extensionid__c = '123'
        );
        insert u;
        
        // Create a test Master_Data__c record
        Master_Data__c masterData_2 = new Master_Data__c(
            Name = 'Test Master Data',
            Agent_Id__c = '45678',
            Agent_code__c = 'A456',
            Unit_by_region__c = 'C8_MFS',
            Management_Unit__c = '3'
        );
        insert masterData_2;
        
        // Create a test user 2
        User u_2 = new User(
            Alias = 'testuse2',
            Email='testuser2@gimasys.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='testuser_2@gimasys.com',
            Id_Agent_Using__c=masterData_2.Id,
            Extensionid__c = 'abc'
        );
        insert u_2;
        
        // Create a test Contact record
        Contact contact = new Contact(
            LastName = 'Test',
            Phone = '1234567890'
        );
        insert contact;
    }
    
    @isTest
    static void testSearchAgents() {
        Test.startTest();
        
        // Log in as test user
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuser@gimasys.com'];
        System.runAs(testUser) {
            // Test the searchAgents method
            List<MBFPhoneController.InfoAgent> agents = MBFPhoneController.searchAgents('Test');
            System.assertNotEquals(0, agents.size(), 'Agents should be found');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetUser() {
        Test.startTest();
        
        // Log in as test user
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuser@gimasys.com'];
        System.runAs(testUser) {
            // Test the getUser method
            MBFPhoneController.InfoAgent userAgent = MBFPhoneController.getUser();
            System.assertNotEquals(null, userAgent, 'User agent should be found');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetInfoCallByPhone() {
        Test.startTest();
        
        // Test the getInfoCallByPhone method
        MBFPhoneController.InfoCall infoCall = MBFPhoneController.getInfoCallByPhone('1234567890');
        MBFPhoneController.InfoCall infoCall3 = MBFPhoneController.getInfoCallByPhone('12345678940');
        
        Test.stopTest();
    }
    
    @isTest
    static void testAutoCreateCase() {
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuser@gimasys.com'];
        System.runAs(testUser) {
            // Test the autoCreateCase method
            Contact ct = new Contact();
            ct.LastName = 'Test Contact';
            ct.Phone = '98474746333';
            insert ct;
            
            MBFPhoneController.InfoCall infoCall = MBFPhoneController.autoCreateCase(ct.Id, '1234567890', 'call123');
            MBFPhoneController.getAgentByRegion();
            System.assertNotEquals(null, infoCall.caseId, 'Case should be created');
            System.assertNotEquals(null, infoCall.taskId, 'Task should be created');
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void testgetWallboardReport() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWallboard());
        
        Test.startTest();
        
        // Log in as test user
        User testUser = [SELECT Id FROM User WHERE UserName = 'testuser@gimasys.com'];
        System.runAs(testUser) {
            // Test the searchAgents method
            MBFPhoneController.wrapperGetWallboardReport wallBoard = MBFPhoneController.getWallboardReport(String.valueof(datetime.now()), String.valueof(datetime.now()));
        }
        
        Test.stopTest();
    }
    
    // Mock HTTP response generator for HTTP callout tests
    public class MockHttpResponseGeneratorWallboard implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"responseCode":"200","responseMessage":"Success","responseData":{"totalDtvAnswering":"10","totalCallOut":"20","totalDtvFreeTime":"5","totalCallAnswered":"15","totalDtvNotready":"2","totalCallDtv":"12","totalCall":"25","totalCallWait":"3","svRatio":"90%","svRatio60":"85%","managementUnit":"Unit1","tranDi":"3","nhanTran":"4","totalDtvCurrent":"8"}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testGetCalls() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Test the getCalls method
        MBFPhoneController.ResponseMiddleware response = MBFPhoneController.getCalls('agent123', 'active', '1', '10');
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetListAgentQueue() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAgentQueue());
        
        // Test the getListAgentQueue method
        MBFPhoneController.wrapperListAgrentQueue response = MBFPhoneController.getListAgentQueue('12345');
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
    // Mock HTTP response generator for HTTP callout tests
    public class MockHttpResponseGeneratorAgentQueue implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"responseCode":"200","responseMessage":"Thành công","responseData":[{"projectName":"Broadband","inbound":0,"max":0,"outbound":0},{"projectName":"Doanh Nghiep","inbound":0,"max":0,"outbound":0},{"projectName":"DV Di Dong","inbound":0,"max":0,"outbound":0},{"projectName":"MobiPay","inbound":0,"max":0,"outbound":0},{"projectName":"VIP","inbound":0,"max":0,"outbound":0}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testGetListAgentStatus() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAgentStatus());
        
        // Test the getListAgentStatus method
        String requestBody = '{"agentIds":["9f38a2e4-24ca-47e3-8d39-3e64cfe85383","be527727-416b-424d-8aad-6bf537877b52","21aa9fbf-c4fa-4889-b26e-abfb7135499f","5b87af86-07d3-4d8f-ad39-a18b12afb9ff","34bb38a6-7c20-4452-80ef-64950cf72e77"]}';
        MBFPhoneController.wrapperListAgrentStatus response = MBFPhoneController.getListAgentStatus(requestBody);
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
    
    // Mock HTTP response generator for HTTP callout tests
    public class MockHttpResponseGeneratorAgentStatus implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"responseCode":"200","responseMessage":"Thành công","responseData":[{"agentId":"9f38a2e4-24ca-47e3-8d39-3e64cfe85383","agentStatus":"$Cmn_Logoff","deleted":false,"workplaceState":null},{"agentId":"be527727-416b-424d-8aad-6bf537877b52","agentStatus":"$Cmn_Logoff","deleted":false,"workplaceState":null},{"agentId":"21aa9fbf-c4fa-4889-b26e-abfb7135499f","agentStatus":"$Cmn_Logoff","deleted":false,"workplaceState":null},{"agentId":"5b87af86-07d3-4d8f-ad39-a18b12afb9ff","agentStatus":"$Cmn_Unavailable","deleted":false,"workplaceState":"OutOfOrder"},{"agentId":"34bb38a6-7c20-4452-80ef-64950cf72e77","agentStatus":"$Cmn_Unavailable","deleted":false,"workplaceState":"Free"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testOutboundCall() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Test the OutboundCall method
        String requestBody = '{"phoneNumber":"1234567890"}';
        String OutboundListId = 'aff10863-fb17-4ec6-9cf8-78c3fe71294c';
        String response = MBFPhoneController.OutboundCall(requestBody,OutboundListId);
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
	
    @isTest
    static void testcreateCallRecord() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String response = MBFPhoneController.createCallRecord('Call ID', 'linkage');
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
    
    @isTest
    static void testgetPbxCallId() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String response = MBFPhoneController.getPbxCallId('Call ID');
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
    
    @isTest
    static void testsaveTransferCall() {
        Test.startTest();
        
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        String response = MBFPhoneController.saveTransferCall('Call ID');
        System.assertNotEquals(null, response, 'Response should be received');
        
        Test.stopTest();
    }
    
    // Mock HTTP response generator for HTTP callout tests
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"responseCode":"200","responseMessage":"Success","responseData":{"content":[],"last":true}}');
            res.setStatusCode(200);
            return res;
        }
    }
}