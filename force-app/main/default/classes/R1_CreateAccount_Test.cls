/**
* @description       : The Class for test R1_CreateAccount_Test
* @author            : dvthanh - GMS
* @last modified on  : 07/04/2024
* @last modified by  : Do Viet Thanh (vthanh3011@gmail.com)
* @history           :    date                    author                      content
**/
@isTest
private class R1_CreateAccount_Test {
    @isTest
    static void testValidRequest() {
        // Create a mock request body
        String requestBody = '[{"ACC_KEY": "001", "ACCOUNT_ID": null, "ACCOUNT_TYPE": "Type1", "NAME": "Test Account", "CUST_ID": "C001", "BUS_TYPE": "Business", "PAY_FULL_ADDRESS": "123 Test Street", "INV_PROVINCE": "Test Province", "INV_STREET_NAME": "Test Street", "ID_NO": "ID001", "POP_ISSUE_PLACE": "Test Place", "CUST_TYPE": "TypeA", "BUSINESS_GROUP": "Group1", "REG_BUSINESS": "Business1", "SEX": "M", "BIRTH_DATE": "2024-01-01", "NATIONALITY": "US", "ID_ISSUE_DATE": "2020-01-01", "ID_ISSUE_PLACE": "Place1", "SUB_INTERESTED": "Interest1", "LANGUAGE": "EN", "EMAIL": "test@example.com", "TEL_FAX": "1234567890", "RES_PROVINCE": "Province1", "RES_STREET_NAME": "Street1", "FOUNDED_DATE": "2010-01-01", "FAX": "123456789", "BUS_PERMIT_NO": "Permit1", "TIN": "TIN001", "CONTACT_NAME": "Contact1", "AUTHOR_SUBNAME": "Author1", "POP_NO": "POP001", "POP_ISSUE_DATE": "2022-01-01", "VIP": "true"}]';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(requestBody);
        req.httpMethod = 'POST';
        req.requestURI = '/createAccount/';
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        R1_CreateAccount.doPost();
        Test.stopTest();
        
        // Verify response
        System.assertEquals(200, res.statusCode);
        
        String responseBody = res.responseBody.toString();
        R1_CreateAccount.wrapperResponseBody responseWrapper = (R1_CreateAccount.wrapperResponseBody) JSON.deserialize(responseBody, R1_CreateAccount.wrapperResponseBody.class);
        System.assertEquals('Success', responseWrapper.Status);
        System.assertNotEquals(0, responseWrapper.lstInsert.size());
        System.assertEquals('001', responseWrapper.lstInsert[0].Account_Id_DB);
    }
    
    @isTest
    static void testPartialSuccess() {
        // Create a mock request body with valid and invalid data
        String requestBody = '[{"ACC_KEY": "003", "NAME": "Valid Account"}, {"ACC_KEY": "004", "BIRTH_DATE": "invalid-date"}]';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(requestBody);
        req.httpMethod = 'POST';
        req.requestURI = '/createAccount/';
        RestContext.request = req;
        
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        R1_CreateAccount.doPost();
        Test.stopTest();
        
        // Verify response
        System.assertEquals(200, res.statusCode);
        
        String responseBody = res.responseBody.toString();
        R1_CreateAccount.wrapperResponseBody responseWrapper = (R1_CreateAccount.wrapperResponseBody) JSON.deserialize(responseBody, R1_CreateAccount.wrapperResponseBody.class);
        System.assertEquals('Success', responseWrapper.Status);
        System.assertEquals(2, responseWrapper.lstInsert.size());
        
        for (R1_CreateAccount.valueSet value : responseWrapper.lstInsert) {
            if (value.Account_Id_DB == '004') {
                System.assertNotEquals(null, value.error_Mess);
            }
        }
    }
}