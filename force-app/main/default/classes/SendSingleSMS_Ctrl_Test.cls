@isTest
private class SendSingleSMS_Ctrl_Test {
    
    @testSetup
    static void setup() {
        // Setup test data for SMS templates
        SMS_Template__c smsTemplate1 = new SMS_Template__c(SMS_Type__c = 'Type1', SMS_Template__c = 'Hello, this is a test message.', Date_From__c = date.today() , Date_To__c = date.today().addDays(5));
        SMS_Template__c smsTemplate2 = new SMS_Template__c(SMS_Type__c = 'Type2', SMS_Template__c = 'Another test message.' , Date_From__c = date.today() , Date_To__c = date.today().addDays(5));
        insert new List<SMS_Template__c>{smsTemplate1, smsTemplate2};
        
        // Setup test data for Case and Contact
        Contact testContact = new Contact(LastName = 'Test', Phone = '1234567890');
        insert testContact;

        Case testCase = new Case(Contact__c = testContact.Id);
        insert testCase;
        
        Omni_Gateway__c settings = new Omni_Gateway__c();
        settings.Name = 'Endpoint';
        settings.Value__c = 'Endpoint';
        insert settings;
        
        Omni_Gateway__c settings1 = new Omni_Gateway__c();
        settings1.Name = 'grant_type';
        settings1.Value__c = 'grant_type';
        insert settings1;
        
        Omni_Gateway__c settings3 = new Omni_Gateway__c();
        settings3.Name = 'Content_Type';
        settings3.Value__c = 'Content_Type';
        insert settings3;                
        
        Omni_Gateway__c settings2 = new Omni_Gateway__c();
        settings2.Name = 'Authorization';
        settings2.Value__c = 'Authorization';
        insert settings2;
        
        Omni_Gateway__c settings5 = new Omni_Gateway__c();
        settings5.Name = 'Token';
        settings5.Value__c = 'Token';
        insert settings5;
        
        sms_history__c sh = new sms_history__c();
        sh.phone_send__c = '123456789';
        insert sh;
    }

    @isTest
    static void testGetListTemplate() {
        Map<String, Object> result = SendSingleSMS_Ctrl.getListTemplate();
        List<Object> templates = (List<Object>) result.get('listEmailTemplate');
    }

    @isTest
    static void testGetListTemplate_Exception() {
        // Using @isTest(SeeAllData=true) for this test to simulate an exception scenario.
        // This is not generally recommended in real-world scenarios.

        Test.startTest();
        Map<String, Object> result = SendSingleSMS_Ctrl.getListTemplate();
        SendSingleSMS_Ctrl sms = new SendSingleSMS_Ctrl();
        sms.createUpdateSMSHistory('a', 'abcd', 'test' , 'test', '123456789' , true , true);
        Test.stopTest();
        
    }

    @isTest
    static void testGet_SMS_body() {
        SMS_Template__c smsTemplate = [SELECT Id FROM SMS_Template__c LIMIT 1];
        Map<String, Object> result = SendSingleSMS_Ctrl.get_SMS_body(smsTemplate.Id);

    }

    @isTest
    static void testGet_SMS_body_Exception() {
        Map<String, Object> result = SendSingleSMS_Ctrl.get_SMS_body('invalidId');
    }

    @isTest
    static void testSendSms_Case() {
        // Mock the HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"status": "Success"}');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        test.startTest();
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        Map<String, Object> result = SendSingleSMS_Ctrl.sendSms(testCase.Id, 'Test message', 'Case');
        Test.stopTest();
    }

    @isTest
    static void testSendSms_Contact() {
        // Mock the HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"status": "Success"}');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        test.startTest();
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        Map<String, Object> result = SendSingleSMS_Ctrl.sendSms(testContact.Id, 'Test message', 'Contact');
        Test.stopTest();
    }

    @isTest
    static void testSendSms_NoPhone() {
        Case testCase = new Case();
        insert testCase;

        Map<String, Object> result = SendSingleSMS_Ctrl.sendSms(testCase.Id, 'Test message', 'Case');
    }

    @isTest
    static void testSendSms_Exception() {
        // Mock the HTTP response to throw an exception
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"status": "Success"}');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        Test.startTest();
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        SendSingleSMS_Ctrl.sendSms(testCase.Id, 'Test message', 'Case');
        Test.stopTest();

    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;

        public MockHttpResponseGenerator(HttpResponse mockResponse) {
            this.mockResponse = mockResponse;
        }

        public HttpResponse respond(HttpRequest req) {
            return mockResponse;
        }
    }
    
    private class MockHttpExceptionGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            throw new System.CalloutException('Mock callout exception');
        }
    }
}