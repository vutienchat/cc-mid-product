@isTest
public class R1_CallOutCase_Test {
    @testSetup
    static void setupTestData() {
        // Create test users
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
        
        // Create test leads
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 3; i++) {
            leads.add(new Lead(LastName = 'Lead ' + i, Phone = '123456789' + i, OwnerId = testUser.Id, company = 'test'));
        }
        insert leads;
        
        // Create test cases
        id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        List<Case> cases = new List<Case>();
         // đổi default value của request group trong recordtype về null nếu lỗi deploy
        for (Integer i = 0; i < 3; i++) {
            cases.add(new Case(Subject = 'Case ' + i, OwnerId = testUser.Id, Type='21',recordtypeId = recordtypeId));
        }
        insert cases;
    }
    
    @isTest
    static void testCreateTaskForLead() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        Test.startTest();
        String result = R1_CallOutCase.createTask(testLead.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testCreateTaskForCase() {
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        String result = R1_CallOutCase.createTask(testCase.Id);
        Test.stopTest();
    }
}