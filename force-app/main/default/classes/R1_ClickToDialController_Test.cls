/**
* @description       : The Class for test R1_ClickToDialController
* @author            : nmquang - GMS
* @last modified on  : 07/03/2024
* @last modified by  : Nguyen Minh Quang (nguyenminhquang0325@gmail.com)
* @history           :    date                    author                      content
**/

@isTest
private class R1_ClickToDialController_Test {

    @TestSetup
    static void setup() {
        Task task = new Task(
            Phone__c='1234567890');
    		insert task; 
    }

    @isTest
    static void testGetTaskDB_Success() {
        // Call method
        Task iTask = [SELECT Id FROM Task WHERE Phone__c = '1234567890'];
        Task result = R1_ClickToDialController.getTaskDB(iTask.Id);

        // Assertions
        System.assertNotEquals(null, result);
        System.assertEquals(iTask.Id, result.Id);
        System.assertEquals('1234567890', result.Phone__c);
    }

    @isTest
    static void testGetTaskDB_IdNotFound() {
        try {
            Task iTask = [SELECT id FROM Task WHERE Phone__c='1234567890'];
            R1_ClickToDialController.getTaskDB(iTask.id);             
        } catch(Exception e) {
            System.assert(e.getMessage().contains('No records found'));
        }
    }
}