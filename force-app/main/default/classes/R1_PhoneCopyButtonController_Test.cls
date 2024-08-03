/**
* @description       : The Class for Button Create Call Out Task
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.02
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@isTest
private class R1_PhoneCopyButtonController_Test {

    @isTest
    static void testGetPhone() {
        // Test data setup
        
        Contact testContact = new Contact(LastName = 'Test Contact', Phone = '9876543210');
        insert testContact;
        
        id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        // Tạo Case để kiểm thử
        // đổi default value của request group trong recordtype về null nếu lỗi deploy
        Case testCase = new Case(
            Subject = 'Test Case',
            Type='21',
            recordtypeId = recordtypeId,
            contactId = testContact.Id
        );
        insert testCase;
        
        Task testTask = new Task(Subject = 'Test Task', Phone__c = '6789012345');
        insert testTask;

        // Test for Contact object
        String contactPhone = R1_PhoneCopyButtonController.getPhone(testContact.Id);
        
        // Test for Case object
        String casePhone = R1_PhoneCopyButtonController.getPhone(testCase.Id);
        
        // Test for Task object
        String taskPhone = R1_PhoneCopyButtonController.getPhone(testTask.Id);
        
    }
}