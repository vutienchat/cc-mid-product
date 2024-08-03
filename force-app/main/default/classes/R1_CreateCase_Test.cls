/**
* @description       : The Class for test R1_CreateCase_Test
* @author            : dvthanh - GMS
* @last modified on  : 07/04/2024
* @last modified by  : Do Viet Thanh (vthanh3011@gmail.com)
* @history           :    date                    author                      content
**/
@isTest
private class R1_CreateCase_Test {
    @isTest
    static void testDoPost() {
        // Create mock data for dataWrapper
        
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
        
        String todayDate = '05/05/2024';
        R1_CreateCase.dataWrapper wrapper = new R1_CreateCase.dataWrapper();
        wrapper.ADDRESS = '123 Main St';
        wrapper.FBTEMP_NOT_UPDATED = 'true';
        wrapper.FBTEMP_IS_USING_NORMALLY_AT_THIS_TIME = 'true';
        wrapper.URGENT = 'false';
        wrapper.CALL_BACK_REQUIRE = 'true';
        wrapper.TEMPORARY_CLOSE = 'false';
        wrapper.FBTEMP_ERROR_DATE = string.valueOf(todayDate);
        wrapper.FBTEMP_CHANGE_DATE = string.valueOf(todayDate);
        wrapper.FBTEMP_DATE_SWITCH_PRE_PAID = string.valueOf(todayDate);
        wrapper.FEEDBACK_DATE = string.valueOf(todayDate);
        wrapper.FBTEMP_DATE_LOST_ACCOUNT = string.valueOf(todayDate);
        wrapper.FBTEMP_RECHARGE_DATE = string.valueOf(todayDate);
        wrapper.FBTEMP_DATETIME = string.valueOf(todayDate);
        wrapper.FBTEMP_TIME_BEGIN = string.valueOf(todayDate);
        wrapper.FBTEMP_EMAIL_ADDRESS = 'example@example.com';
        wrapper.COMP_CONTENT = 'Complaint details';
        wrapper.PRE_RESULT = 'Preliminary result';
        wrapper.ERROR_CAUSE_DETAIL = 'Error cause details';
        wrapper.RESULT_CONTENT = 'Result content';
        wrapper.ACCOUNT_ID = '001xx000003DGb1AAG'; // Set a valid Account ID if required
        wrapper.END_USER = testUser.Id;
        wrapper.ACCEPT_SOURCE_ID = null;
        wrapper.ACCEPT_USER = null;
        wrapper.FBTEMP_ACTIVATION_NUMBER = 123456;
        wrapper.COMPLAIN_LEVEL = 1;
        wrapper.PHONE = '1234567890';
        wrapper.DETAIL_ERROR_ID = 'ErrorID';
        wrapper.FBTEMP_PERMANENT_OR_TEMPORARY = 'Permanent';
        wrapper.ACCEPT_TYPE_ID = 'TypeID';
        wrapper.COMPLAIN_TYPE = 'Complaint';
        wrapper.FBTEMP_COMPLAIN_TYPE = 'Complain Type';
        wrapper.COMP_TYPE_ID = 'TypeID';
        wrapper.FBTEMP_CANCEL_REQUEST_TYPE = 'Cancel Request Type';
        wrapper.FBTEMP_USING_SIM = 'Using SIM';
        wrapper.FBTEMP_BLOCKEDBY_SMSC = 'Blocked by SMSC';
        wrapper.STATUS = 'New';
        wrapper.CEN_CODE = 'CEN Code';
        wrapper.FEEDBACK_STATUS = 'Feedback Status';
        wrapper.RECORD_TYPE = 'Record Type';
        wrapper.NOTE = 'Note';
        wrapper.FBTEMP_DENOMINATION = 'Denomination';
        wrapper.FBTEMP_AMOUNT = 'Amount';
        wrapper.FBTEMP_ACCOUNT_BALANCE = 'Account Balance';
        wrapper.FBTEMP_ACC_AFTER_LOST = 'Account After Lost';
        wrapper.FBTEMP_EVENT = 'Event';
        wrapper.FBTEMP_PACKAGE = 'Package';
        wrapper.FBTEMP_BALANCE_AMOUNT = 'Balance Amount';
        wrapper.FBTEMP_DOCUMENTARY = 'Documentary';
        wrapper.FBTEMP_PHONE_TO = 'Phone To';
        wrapper.RESPOND_TYPE = 'Respond Type';
        wrapper.COMP_FEEDBACK_TYPE_ID = 'Feedback Type ID';
        wrapper.REFERENCE_ID = 'Reference ID';
        wrapper.FBTEMP_TAX_CODE = 'Tax Code';
        wrapper.FBTEMP_RECEIVE_FROM = 'Receive From';
        wrapper.FBTEMP_RECHARGE_METHOD = 'Recharge Method';
        wrapper.FBTEMP_SERIAL = 'Serial';
        wrapper.FBTEMP_IDENTITYCARDNUMBER = 'Identity Card Number';
        wrapper.FBTEMP_HARASSED_PHONE = 'Harassed Phone';
        wrapper.FBTEMP_MISSING_AMOUNT = 'Missing Amount';
        wrapper.FBTEMP_RECEIVED_AMOUNT = 'Received Amount';
        wrapper.FBTEMP_CONTACT_PHONE = 'Contact Phone';
        wrapper.FBTEMP_HARASSED_CONTACT = 'Harassed Contact';
        wrapper.COMPLAIN_ID = 'Complain ID';
        wrapper.FBTEMP_RECEIVE_FROM_CALL_TO = 'Receive From Call To';
        wrapper.FBTEMP_AREA_WHEN_INSPECT = 'Area When Inspect';
        wrapper.FBTEMP_NETWORK_SUBSCRIBER_USING = 'Network Subscriber Using';
        wrapper.FBTEMP_CHOOSE_CORRECT_SIM_NETWORK_ACCES = 'Choose Correct SIM Network Access';
        wrapper.FBTEMP_STORE = 'Store';
        wrapper.FBTEMP_LEFT_STORAGE = 'Left Storage';
        wrapper.FBTEMP_SERVICE = 'Service';
        wrapper.FBTEMP_CURRENT_PLAN = 'Current Plan';
        wrapper.FBTEMP_DATA_PACKAGE_USING = 'Data Package Using';
        wrapper.FBTEMP_ERRORS_AREA = 'Errors Area';
        wrapper.FBTEMP_CHECK_DEVICE_AND_SIM_ERRORS = 'Check Device and SIM Errors';
        wrapper.FBTEMP_DISPLAY_SIGNAL = 'Display Signal';
        wrapper.FBTEMP_REASON = 'Reason';
        wrapper.FBTEMP_USED_PHONE = 'Used Phone';
        wrapper.FBTEMP_TIME_OR_PERIOD_TIME = 'Time or Period Time';
        wrapper.FBTEMP_CONTENT = 'Content';
        wrapper.FBTEMP_NOTI_DISPLAY_WHEN_UNCONTACTABLE = 'Notification Display When Uncontactable';
        wrapper.FBTEMP_OTHER_INFORMATION = 'Other Information';
        wrapper.FBTEMP_ERROR_TIME = 'Error Time';
        wrapper.TITLE = 'Title';
        wrapper.FBTEMP_PROMOTION_PROGRAM = 'Promotion Program';
        wrapper.FBTEMP_ERROR_STATUS = 'Error Status';
        wrapper.FBTEMP_CURRENT_STATUS_QUO = 'Current Status Quo';
        wrapper.FBTEMP_MESSAGE_SHOWN_WHEN_UNCONTACTABLE = 'Message Shown When Uncontactable';
        wrapper.FBTEMP_CUSTOMER_REQUEST = 'Customer Request';
        wrapper.FBTEMP_AREA_USING = 'Area Using';
        wrapper.FBTEMP_STORE_ADDRESS = 'Store Address';
        wrapper.FBTEMP_ADDRESS = 'Address';
        wrapper.FBTEMP_SHIPPING_ADDRESS = 'Shipping Address';
        wrapper.FBTEMP_BILLING_ADDRESS = 'Billing Address';
        wrapper.FBTEMP_NETWORK_INACCESSIBLE_ADDRESS = 'Network Inaccessible Address';
        wrapper.FBTEMP_INACCESSIBLE_WEB_SERVICES = 'Inaccessible Web Services';
        wrapper.FBTEMP_RESULT_CHECK_CONNECTION_BY_PING = 'Result Check Connection By Ping';
        wrapper.FBTEMP_BUSINESS_CONTACT_POINT = 'Business Contact Point';
        wrapper.FBTEMP_AMOUNT_SIM_DISCONNECTED = 'Amount SIM Disconnected';
        wrapper.FBTEMP_ERROR_PHONE = 'Error Phone';
        wrapper.FBTEMP_ERROR_MESSAGE = 'Error Message';
        wrapper.FBTEMP_DEVICE_TYPE = 'Device Type';
        wrapper.FBTEMP_MODEL = 'Model';
        wrapper.FBTEMP_REQUEST = 'Request';
        wrapper.FBTEMP_NEAR = 'Near';
        wrapper.FBTEMP_TYPE_OF_HARASSMENT = 'Type of Harassment';
        wrapper.FBTEMP_SIM_TYPE_USING = 'SIM Type Using';
        wrapper.FBTEMP_TIME = 'Time';
        wrapper.FBTEMP_REGISTER_NUMBER_EZ = 'Register Number EZ';
        wrapper.FBTEMP_AMOUNTEZNUMBER_NOT_RECEIVE_KK = 'Amount EZ Number Not Receive KK';
        wrapper.FBTEMP_RECHARGED_AMOUNT = 'Recharged Amount';
        wrapper.FBTEMP_STAFF = 'Staff';
        wrapper.FBTEMP_FREQUENCY_OF_HARASSMENT = 'Frequency of Harassment';
        wrapper.GROUP_ID = 'Group ID';

        List<R1_CreateCase.dataWrapper> wrapperList = new List<R1_CreateCase.dataWrapper>();
        wrapperList.add(wrapper);

        // Create a JSON string from the wrapper list
        String jsonString = JSON.serialize(wrapperList);

        // Create a mock REST request
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/createCase/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonString);
        RestContext.request = req;

        // Create a mock REST response
        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the method to be tested
        Test.startTest();
        R1_CreateCase.doPost();
        Test.stopTest();

        // Verify the response
        R1_CreateCase.wrapperResponseBody responseBody = (R1_CreateCase.wrapperResponseBody)JSON.deserialize(res.responseBody.toString(), R1_CreateCase.wrapperResponseBody.class);
    }
}