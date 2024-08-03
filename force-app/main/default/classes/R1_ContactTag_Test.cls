/**
* @description       : The Class for test R1_ContactTag_Test
* @author            : dvthanh - GMS
* @last modified on  : 07/02/2024
* @last modified by  : Do Viet Thanh (vthanh3011@gmail.com)
* @history           :    date                    author                      content
**/
@isTest
public class R1_ContactTag_Test {
    @testSetup
    static void setupTestData() {
        // Create a Tag
        Tag__c tag = new Tag__c(Name = 'Test Tag');
        insert tag;
        
        // Create a Case
        id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
         // đổi default value của request group trong recordtype về null nếu lỗi deploy
        Case testCase = new Case(Subject = 'Test Case');
        testCase.Type='21';
        testCase.recordtypeId = recordtypeId;
        insert testCase;
        
        // Create meta_tag__c record
        meta_tag__c metaTag = new meta_tag__c(Case__c = testCase.Id, Tag__c = tag.Id);
        insert metaTag;
    }

    @isTest
    static void testGetTags() {
        // Retrieve the test case and meta_tag__c record
        Case testCase = [SELECT Id FROM Case WHERE Subject = 'Test Case' LIMIT 1];
        
        Test.startTest();
        // Call the method
        List<meta_tag__c> tags = R1_ContactTag.getTags(testCase.Id);
        Test.stopTest();

        // Verify the result
        System.assertNotEquals(0, tags.size(), 'Tags should be retrieved');
        System.assertEquals('Test Tag', tags[0].Tag__r.Name, 'Tag name should match');
    }

    @isTest
    static void testRemoveTag() {
        // Retrieve the test case and meta_tag__c record
        Case testCase = [SELECT Id FROM Case WHERE Subject = 'Test Case' LIMIT 1];
        
        Test.startTest();
        // Call the method
        String result = R1_ContactTag.removeTag(testCase.Id, 'Test Tag');
        Test.stopTest();

        // Verify the result
        System.assertEquals('Success', result, 'Tag should be successfully removed');
        
        // Verify the tag was deleted
        List<meta_tag__c> remainingTags = [SELECT Id FROM meta_tag__c WHERE Case__c = :testCase.Id];
        System.assertEquals(0, remainingTags.size(), 'No tags should remain after deletion');
    }
}