/**
* @description       : The Class for test R1_SurveyResultNoteController
* @author            : nmquang - GMS
* @last modified on  : 07/04/2024
* @last modified by  : Nguyen Minh Quang (nguyenminhquang0325@gmail.com)
* @history           :    date                    author                      content
**/

@isTest
private class R1_SurveyResultNoteController_Test {
    @isTest
    static void testCheckPermission() {
     	
        // Create a user with a specific profile (e.g., not a Service Supervisor)
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(ProfileId = userProfile.Id);
        testUser.Username = 'testNguyen@gmail.com'; 
        testUser.LastName = 'Nguyen'; 
        testUser.Email = 'testNguyen@gmail.com'; 
        testUser.Alias = 'test'; 
        testUser.TimeZoneSidKey = 'America/Los_Angeles'; 
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'UTF-8'; 
        testUser.LanguageLocaleKey = 'en_US'; 
        insert testUser;
        


        // Set the current user context
        System.runAs(testUser) {
            // Call the checkPermission method
            Boolean hasPermission = R1_SurveyResultNoteController.checkPermission();

            // Assert that the result is as expected (e.g., true or false)
            System.assertEquals(true, hasPermission, 'User should have permission');
        }
    }

    @isTest
    static void testCreateTask() {
        // Create a test record for Task
        Task testTask = new Task(Subject = 'Test Task', Type = 'Outbound');
        insert testTask;

        // Call the createTask method
        String newTaskId = R1_SurveyResultNoteController.createTask(testTask.Id, 'Test Reason');

        // Retrieve the newly created task
        Task newTask = [SELECT Id FROM Task WHERE Id = :newTaskId];

        // Assert that the new task was inserted successfully
        System.assertNotEquals(null, newTask, 'New task should be created');
    }
}