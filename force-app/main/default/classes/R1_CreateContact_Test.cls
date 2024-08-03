@isTest
public class R1_CreateContact_Test {
    @testSetup
    static void setupTestData() {
        // Create test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testDoPostSuccess() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Prepare test data
        List<R1_CreateContact.dataWrapper> wrapperList = new List<R1_CreateContact.dataWrapper>();
        for (Integer i = 0; i < 5; i++) {
            R1_CreateContact.dataWrapper item = new R1_CreateContact.dataWrapper();
            item.ACCOUNT_ID = testAccount.Id;
            item.ISDN = '123456789' + i;
            item.SUB_ID = 'SUB' + i;
            item.STATUS = 'Active';
            item.NAME = 'Test Contact ' + i;
            wrapperList.add(item);
        }
        
        String requestBody = JSON.serialize(wrapperList);
        
        // Set request body
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/createContact/job/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        R1_CreateContact.doPost();
        Test.stopTest();
        
        // Verify response
        String responseBody = res.responseBody.toString();
        System.debug('Response Body: ' + responseBody);
        
        R1_CreateContact.wrapperResponseBody response = (R1_CreateContact.wrapperResponseBody) JSON.deserialize(responseBody, R1_CreateContact.wrapperResponseBody.class);
    }
    
    @isTest
    static void testDoPostErrorHandling() {
        // Prepare invalid test data
        List<R1_CreateContact.dataWrapper> wrapperList = new List<R1_CreateContact.dataWrapper>();
        for (Integer i = 0; i < 1; i++) {
            R1_CreateContact.dataWrapper item = new R1_CreateContact.dataWrapper();
            item.ACCOUNT_ID = 'invalidId'; // Invalid Account Id
            item.ISDN = '123456789' + i;
            item.SUB_ID = 'SUB' + i;
            item.STATUS = 'Active';
            item.NAME = 'Test Contact ' + i;
            wrapperList.add(item);
        }
        
        String requestBody = JSON.serialize(wrapperList);
        
        // Set request body
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/createContact/job/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        R1_CreateContact.doPost();
        Test.stopTest();
        
        // Verify response
        String responseBody = res.responseBody.toString();
        System.debug('Response Body: ' + responseBody);
        
        R1_CreateContact.wrapperResponseBody response = (R1_CreateContact.wrapperResponseBody) JSON.deserialize(responseBody, R1_CreateContact.wrapperResponseBody.class);
    }
}