/**
* @description       : The Class for R1_Survey
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.04
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@isTest
public class R1_Survey_Test {
    // Tạo dữ liệu kiểm thử
    private static void createTestData() {
        // Tạo Campaign để kiểm thử
        Campaign testCampaign = new Campaign(Name = 'Test Campaign');
        insert testCampaign;

        // Tạo Template để kiểm thử
        Survey_Template__c testTemplate = new Survey_Template__c(Name = 'CSAT - CSKH - CL DV TƯƠNG TÁC');
        insert testTemplate;
        id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        // Tạo Case để kiểm thử - đổi default value của request group trong recordtype về null nếu lỗi deploy
        Case testCase = new Case(
            Subject = 'Test Case',
            Type='21',
            recordtypeId = recordtypeId
        );
        insert testCase;

        // Tạo Contact để kiểm thử
        RecordType customerRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' AND SObjectType = 'Contact' LIMIT 1];
        Contact testContact = new Contact(LastName = 'Test Contact', Phone = '1234567890', RecordTypeId = customerRT.Id, Status__c = '1');
        insert testContact;

        // Tạo Survey_Question cho Campaign
        Survey_Question__c testCampaignQuestion = new Survey_Question__c(
            Name = 'Test Question for Campaign',
            Multiple_answers__c = false,
            Answers__c = 'Answer1;Answer2',
            Campaign__c = testCampaign.Id,
            Group_question__c = 'Service_attitude'
        );
        insert testCampaignQuestion;

        // Tạo meta_template_question_survey cho Template
        meta_template_question_survey__c testMetaQuestion = new meta_template_question_survey__c(
            Name = 'Test Template',
            Survey_Question__c = testCampaignQuestion.Id,
            Survey_Template__c = testTemplate.Id
        );
        insert testMetaQuestion;
    }

    @isTest
    static void testGetQuestion_Campaign() {
        createTestData();
        Campaign testCampaign = [SELECT Id FROM Campaign WHERE Name = 'Test Campaign' LIMIT 1];

        Test.startTest();
        List<R1_Survey.wrapperQuestion> questions = R1_Survey.getQuestion(testCampaign.Id);
        Test.stopTest();

        System.assertNotEquals(0, questions.size(), 'Questions should not be empty');
        System.assertEquals('Test Question for Campaign', questions[0].Question, 'Question should match the expected value');
    }

    @isTest
    static void testGetQuestion_Template() {
        createTestData();
        meta_template_question_survey__c testTemplate = [SELECT Id, Survey_Template__c FROM meta_template_question_survey__c WHERE Name = 'Test Template' LIMIT 1];

        Test.startTest();
        List<R1_Survey.wrapperQuestion> questions = R1_Survey.getQuestion(testTemplate.Survey_Template__c);
        Test.stopTest();

        System.assertEquals('Test Question for Campaign', questions[0].Question, 'Question should match the expected value');
    }

    @isTest
    static void testGetQuestion_Case() {
        createTestData();
        Case testCase = [SELECT Id FROM Case WHERE Subject = 'Test Case' LIMIT 1];

        Test.startTest();
        List<R1_Survey.wrapperQuestion> questions = R1_Survey.getQuestion(testCase.Id);
        Test.stopTest();

        System.assertEquals('Test Question for Campaign', questions[0].Question, 'Question should match the expected value');
    }

    @isTest
    static void testGetInforContactDB() {
        createTestData();

        Test.startTest();
        Contact result = R1_Survey.getInforContactDB('1234567890');
        Test.stopTest();

        System.assertNotEquals(null, result, 'Contact should not be null');
        System.assertEquals('Test Contact', result.Name, 'Name Contact should match the expected value');
    }

    @isTest
    static void testSaveSurvey() {
        createTestData();

        List<R1_Survey.wrapperQuestion> questions = new List<R1_Survey.wrapperQuestion>();
        R1_Survey.wrapperQuestion question = new R1_Survey.wrapperQuestion();
        question.Question = 'Test Question';
        question.result = 'Test Answer';
        question.templateName = 'Test Template';
        questions.add(question);

        String idata = JSON.serialize(questions);

        Test.startTest();
        String result = R1_Survey.saveSurvey(idata, '1234567890');
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }
}