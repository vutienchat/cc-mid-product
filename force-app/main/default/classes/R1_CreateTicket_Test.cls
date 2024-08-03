/**
* @description       : The Class for test R1_CreateTicket
* @author            : nmquang - GMS
* @last modified on  : 07/04/2024
* @last modified by  : Nguyen Minh Quang (nguyenminhquang0325@gmail.com)
* @history           :    date                    author                      content
**/

@isTest
private class R1_CreateTicket_Test {
    @isTest
    static void testDoPost() {
        // Create test data (replace with relevant object names)
        Id customerRT_Id = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        
        Contact testContact = new Contact(Phone = '1234567890', RecordTypeId = customerRT_Id, Status__c = '1', LastName = 'test');
        insert testContact;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{"phone_number": "1234567890", "title": "Test Ticket", "content": "Test content", "ticket_id": "T123", "ticket_type": "21", "ticket_topic": "", "dateTime_Call_Back": "2024-07-04T09:30:00Z"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        R1_CreateTicket.doPost();
        Test.stopTest();
        
        // Add your assertions here based on expected results
        //System.assertEquals(200, res.statusCode, 'Expected status code should be 200');
        // Add more assertions as needed
    }
}