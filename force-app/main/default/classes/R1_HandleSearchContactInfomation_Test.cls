@isTest
public class R1_HandleSearchContactInfomation_Test {
    @testSetup static void InitTestData(){
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
    }
    
    @isTest
    static void testCheckCurDebitAndHotBill() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.CheckCurDebitAndHotBill(requestBody);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCheckSubService() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.CheckSubService(requestBody);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCheckSubCharge() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.CheckSubCharge(requestBody);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCheckFeebackRequest() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.CheckFeebackRequest(requestBody);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCheckInformationContact() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.CheckInformationContact(requestBody);
        Test.stopTest();
        
    }
    
    @isTest
    static void testSearchDataARPU() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.searchDataARPU(requestBody);
        Test.stopTest();
        
    }
    
    @isTest
    static void testSearchBlackListWhiteList() {
        String requestBody = '{"phone": "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        String response = R1_HandleSearchContactInfomation.searchBlackListWhiteList(requestBody);
        Test.stopTest();
        
    }
}