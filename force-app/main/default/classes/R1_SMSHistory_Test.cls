/**
* @description       : The Class for test R1_SMSHistory
* @author            : nmquang - GMS
* @last modified on  : 07/03/2024
* @last modified by  : Nguyen Minh Quang (nguyenminhquang0325@gmail.com)
* @history           :    date                    author                      content
**/

@isTest
private class R1_SMSHistory_Test {

    @isTest
    static void testCreateUpdateSendSMSHistory() {
        
        Contact ct = new Contact();
        ct.Phone = '0393747483';
        ct.LastName = 'test';
        insert ct;
        
        id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        
        Case c = new Case();
         // đổi default value của request group trong recordtype về null nếu lỗi deploy
        c.Subject = 'test';
        c.Type='21';
        c.recordtypeId = recordtypeId;
        insert c;
        
      
        // Set up test data
        String content = 'Test SMS Content';
        String phone = '1234567890';
        String contactId = ct.Id; // Replace with a valid Contact ID
        String targetObjectId = c.Id; // Replace with a valid Object ID
        String typeObject = 'Case'; // Replace with 'Order' if needed

        // Call the method to be tested
        R1_SMSHistory.createUpdateSendSMSHistory(content, phone, contactId, targetObjectId, typeObject);

        // Verify that the SMS history record was created
        List<sms_history__c> smsHistories = [SELECT Id, Contact__c, Is_send__c, Case__c, Order__c, Is_run__c FROM sms_history__c WHERE phone_send__c = :phone];
        System.assertEquals(1, smsHistories.size(), 'Expected one SMS history record to be created');

        // Verify the details of the SMS history record
        sms_history__c smsHistory = smsHistories[0];
        System.assertEquals(contactId, smsHistory.Contact__c, 'Contact ID does not match');
        System.assertEquals(false, smsHistory.Is_send__c, 'Is_send__c should be false');
        System.assertEquals(false, smsHistory.Is_run__c, 'Is_run__c should be false');
        if (typeObject.equals('Case')) {
            System.assertEquals(targetObjectId, smsHistory.Case__c, 'Case ID does not match');
        } else if (typeObject.equals('Order')) {
            System.assertEquals(targetObjectId, smsHistory.Order__c, 'Order ID does not match');
        }
    }
}