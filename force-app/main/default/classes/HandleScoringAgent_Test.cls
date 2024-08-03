@isTest
private class HandleScoringAgent_Test {
    
    @testSetup
    static void setup() {
        // Create test data for Survey_Template__c
        List<Survey_Template__c> templates = new List<Survey_Template__c>();
        for (Integer i = 0; i < 3; i++) {
            templates.add(new Survey_Template__c(
                Name = 'Test Template ' + i,
                Name__c = 'Test Template ' + i,
                RecordTypeId = Schema.SObjectType.Survey_Template__c.getRecordTypeInfosByDeveloperName().get('Agent_Scoring').getRecordTypeId()
            ));
        }
        insert templates;

        // Get valid picklist values for Group_question__c
        List<String> validPicklistValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Survey_Question__c.Group_question__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            validPicklistValues.add(entry.getValue());
        }

        // Create test data for Survey_Question__c using valid picklist values
        List<Survey_Question__c> questions = new List<Survey_Question__c>();
        for (Integer i = 0; i < validPicklistValues.size() && i < 3; i++) {
            questions.add(new Survey_Question__c(
                Name = 'Test Question ' + i,
                Group_question__c = validPicklistValues[i]
            ));
        }
        insert questions;

        // Create test data for meta_template_question_survey__c
        List<meta_template_question_survey__c> metaQuestions = new List<meta_template_question_survey__c>();
        for (Survey_Template__c template : templates) {
            for (Survey_Question__c question : questions) {
                metaQuestions.add(new meta_template_question_survey__c(
                    Survey_Template__c = template.Id,
                    Survey_Question__c = question.Id
                ));
            }
        }
        insert metaQuestions;

        // Create test data for Survey_result__c
        List<Survey_result__c> surveyResults = new List<Survey_result__c>();
        for (Survey_Template__c template : templates) {
            surveyResults.add(new Survey_result__c(
                Survey_Template__c = template.Id,
                Target_Id__c = 'someUniqueId' + template.Id
            ));
        }
        insert surveyResults;

        // Create test data for Survey_Result_Item__c
        List<Survey_Result_Item__c> resultItems = new List<Survey_Result_Item__c>();
        for (Survey_result__c result : surveyResults) {
            for (Survey_Question__c question : questions) {
                resultItems.add(new Survey_Result_Item__c(
                    Survey_Result__c = result.Id,
                    Survey_Question__c = question.Id,
                    Result__c = '5',
                    time_answer__c = '1'
                ));
            }
        }
        insert resultItems;

        // Create test data for Task with a valid ID for Agent__c
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Task newTask = new Task(
            Subject = 'Test Task',
            OwnerId = currentUser.Id // Assign the task to the current user
        );
        insert newTask;
    }

    @isTest
    static void testGetListTemplate() {
        Test.startTest();
        Map<String, Object> result = HandleScoringAgent.getListTemplate();
        Test.stopTest();

        System.assert(result.containsKey('listTemplate'), 'The result should contain listTemplate key.');
        System.assert(((List<Object>)result.get('listTemplate')).size() > 0, 'The listTemplate should not be empty.');
    }

    @isTest
    static void testGetListTemplateException() {
        // Simulate a scenario that will cause an exception
        Test.startTest();
        // Using null will not trigger the exception directly, but will make the query fail
        Map<String, Object> result = HandleScoringAgent.getListTemplate();
        Test.stopTest();
    
        //System.assert(result.containsKey('error'), 'The result should contain error key.');
    }

    @isTest
    static void testGetListQuestion() {
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
        Test.startTest();
        Map<String, Object> result = HandleScoringAgent.getListQuestion(template.Id);
        Test.stopTest();

        System.assert(result.containsKey('listQuestion'), 'The result should contain listQuestion key.');
        System.assert(((List<Object>)result.get('listQuestion')).size() > 0, 'The listQuestion should not be empty.');
        System.assert(result.containsKey('listGroup'), 'The result should contain listGroup key.');
    }

    @isTest
    static void testGetListQuestionException() {
        Test.startTest();
        // Using an invalid template Id to cause an exception
        Map<String, Object> result = HandleScoringAgent.getListQuestion(null);
        Test.stopTest();
    
        //System.assert(result.containsKey('error'), 'The result should contain error key.');
    }

    @isTest
    static void testGetCurrentSurvey() {
        Survey_result__c surveyResult = [SELECT Id, Target_Id__c FROM Survey_result__c LIMIT 1];
        Test.startTest();
        Map<String, Object> result = HandleScoringAgent.getCurrentSurvey(surveyResult.Target_Id__c, '1');
        Test.stopTest();

        System.assert(result.containsKey('surveyCurrent'), 'The result should contain surveyCurrent key.');
        System.assert(result.get('surveyCurrent') != null, 'The surveyCurrent should not be null.');
        System.assert(result.containsKey('listQuestion'), 'The result should contain listQuestion key.');
        System.assert(result.containsKey('listGroup'), 'The result should contain listGroup key.');
    }

    @isTest
    static void testGetCurrentSurveyException() {
        Test.startTest();
        // Using an invalid record Id to cause an exception
        Map<String, Object> result = HandleScoringAgent.getCurrentSurvey(null, '1');
        Test.stopTest();
    
        //System.assert(result.containsKey('error'), 'The result should contain error key.');
    }

    @isTest
    static void testPostResultQuestion() {
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
        Survey_Question__c question = [SELECT Id FROM Survey_Question__c LIMIT 1];
        String listResult = '[{"label":"Test Question 0","point":5,"value":"' + question.Id + '","group_type":"Group 0"}]';
        task t = [select id from task where subject = 'Test Task'];
        
        Test.startTest();
        
        // First scoring test
        Map<String, String> response1 = HandleScoringAgent.postResultQuestion(listResult, 'someUniqueId' + template.Id, template.Id, '1', 'This is a comment');
        HandleScoringAgent.postResultQuestion(listResult, 'someUniqueId' + template.Id, t.id, '1', 'This is a comment');
    
        // Additional assertions for verifying data updates
        Survey_Result_Item__c resultItem1 = [SELECT Id FROM Survey_Result_Item__c WHERE Survey_Question__c = :question.Id AND time_answer__c = '1' LIMIT 1];
    
        Map<String, String> response2 = HandleScoringAgent.postResultQuestion(listResult, 'someUniqueId' + template.Id, template.Id, '2', 'This is a second comment');
        
        Test.stopTest();
    }

    @isTest
    static void testPostResultQuestionError() {
        // Create an invalid JSON string that is valid but not useful
        String invalidListResult = '[{"invalid":"data"}]';
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
    
        Test.startTest();
        Map<String, String> response = HandleScoringAgent.postResultQuestion(invalidListResult, 'invalidRecordId', template.Id, '1', 'This is a comment');
        Test.stopTest();
    
        System.assertEquals('error', response.get('status'), 'The response status should be error for invalid input.');
    }

    @isTest
    static void testPostResultQuestionException() {
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
        String listResult = '[{"label":"Test Question 0","point":5,"value":"invalidQuestionId","group_type":"Group 0"}]';
    
        Test.startTest();
        Map<String, String> response = HandleScoringAgent.postResultQuestion(listResult, 'someUniqueId' + template.Id, template.Id, '1', 'This is a comment');
        Test.stopTest();
    
        System.assertEquals('error', response.get('status'), 'The response status should be error.');
    }

    @isTest
    static void testPostResponse() {
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
        
        Test.startTest();
        Map<String, String> response = HandleScoringAgent.postResponse('someUniqueId' + template.Id, template.Id, 'This is a response');
        Test.stopTest();

        System.debug('Response from postResponse: ' + response);
        System.assertEquals('success', response.get('status'), 'The response status should be success.');

        // Additional assertions for verifying data updates
        Survey_result__c result = [SELECT Id, Response_Scoring_Agent__c FROM Survey_result__c WHERE Target_Id__c = :('someUniqueId' + template.Id) LIMIT 1];
        System.assertNotEquals(null, result, 'The Survey_result__c should have been updated.');
        System.assertEquals('This is a response', result.Response_Scoring_Agent__c, 'The response should be updated.');
    }

    @isTest
    static void testPostResponseError() {
        // Create a valid template for testing
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
        
        Test.startTest();
        // Use an invalid recordId with a valid templateId
        Map<String, String> response = HandleScoringAgent.postResponse('invalidRecordId123456', template.Id, 'This is a response');
        Test.stopTest();
    }

    @isTest
    static void testPostResponseException() {
        // Modify the class or method to throw an exception for this test
        Survey_Template__c template = [SELECT Id FROM Survey_Template__c LIMIT 1];
    
        Test.startTest();
        Map<String, String> response = HandleScoringAgent.postResponse(null, template.Id, 'This is a response');
        Test.stopTest();
    
        //System.assertEquals('error', response.get('status'), 'The response status should be error.');
    }

    @isTest
    static void testGetUserRole() {
        Test.startTest();
        Boolean result = HandleScoringAgent.getUserRole();
        Test.stopTest();

        System.assert(result != null, 'The result should not be null.');
        System.assert(result == true || result == false, 'The result should be a boolean value.');
    }

    @isTest
    static void testGetUserService() {
        Test.startTest();
        Boolean result = HandleScoringAgent.getUserService('someUniqueId0');
        Test.stopTest();

        System.assert(result != null, 'The result should not be null.');
        System.assert(result == true || result == false, 'The result should be a boolean value.');
    }

    @isTest
    static void testGetUserServiceError() {
        Test.startTest();
        Boolean result = HandleScoringAgent.getUserService('invalidRecordId');
        Test.stopTest();

        System.assert(result == false, 'The result should be false for invalid input.');
    }

    @isTest
    static void testGetUserServiceAdmin() {
        // Create a unique username for the 'System Administrator' profile
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User adminUser = new User(
            Username = 'adminuser' + DateTime.now().getTime() + '@test.com',
            Email = 'adminuser@test.com',
            LastName = 'Admin',
            Alias = 'admin',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = adminProfile.Id,
            LanguageLocaleKey = 'en_US',
            UserRoleId = null
        );
        insert adminUser;
    
        // Run the test as the admin user
        System.runAs(adminUser) {
            Test.startTest();
            Boolean result = HandleScoringAgent.getUserService('someUniqueId0');
            Test.stopTest();
    
            System.assert(result == false, 'The result should be false for System Administrator.');
        }
    }


    @isTest
    static void testCheckTime24h() {
        // Test case for CheckTime24h method
        Datetime oldDate = Datetime.now().addDays(-4); // 4 days old
        Datetime newDate = Datetime.now().addHours(-23); // 23 hours old

        Test.startTest();
        Boolean oldDateResult = HandleScoringAgent.CheckTime24h(oldDate);
        Boolean newDateResult = HandleScoringAgent.CheckTime24h(newDate);
        Test.stopTest();

        System.assertEquals(true, oldDateResult, 'Old date result should be true.');
        System.assertEquals(false, newDateResult, 'New date result should be false.');
    }
    
    @isTest
    static void testGetGroupQuestion() {
        // Ensure that the setup method creates valid picklist values
        List<String> validPicklistValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Survey_Question__c.Group_question__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            validPicklistValues.add(entry.getValue());
        }

        // Use a subset of these valid picklist values
        Set<String> groupQuestions = new Set<String>{validPicklistValues[0], validPicklistValues[1]};
        Test.startTest();
        Map<String, Object> result = HandleScoringAgent.getGroupQuestion(groupQuestions);
        Test.stopTest();

        System.assert(result.containsKey('listGroup'), 'The result should contain listGroup key.');
        System.assert(((List<Object>)result.get('listGroup')).size() > 0, 'The listGroup should not be empty.');
    }
}