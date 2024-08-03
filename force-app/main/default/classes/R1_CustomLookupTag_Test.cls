/**
* @description       : The Class for test R1_CustomLookupTag
* @author            : nmquang - GMS
* @last modified on  : 07/04/2024
* @last modified by  : Nguyen Minh Quang (nguyenminhquang0325@gmail.com)
* @history           :    date                    author                      content
**/

@isTest
private class R1_CustomLookupTag_Test {
    @isTest
    static void testFetchLookUpValues() {
        // Create test data (replace with relevant object names)
        List<meta_tag__c> testTags = new List<meta_tag__c>();
        // Populate testTags with relevant data
        
        // Call the method
        List<sObject> result = R1_CustomLookupTag.fetchLookUpValues('searchKeyword', 'ObjectName', 'caseId', testTags);
        
        // Add your assertions here based on expected results
        System.assertEquals(0, result.size(), 'Expected result size should be 0');
    }
    
    @isTest
    static void testCreateTag() {
        // Create test data (replace with relevant object names)
        Tag__c testTag = new Tag__c(Name = 'Test Tag');
        insert testTag;
        
        Tag__c testTag_2 = new Tag__c(Name = 'Test Tag 2');
        insert testTag_2;
        
        Contact ct = new Contact();
        ct.Phone = '0982241317';
        ct.LastName = 'test';
        insert ct;
        
        id recordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Support').getRecordTypeId();
        
        Case testCase = new Case(ContactId = ct.Id); // Replace with actual ContactId
         // đổi default value của request group trong recordtype về null nếu lỗi deploy
        testCase.Subject = 'test';
        testCase.Type='21';
        testCase.recordtypeId = recordtypeId;
        insert testCase;
        
        // Call the method
        String result = R1_CustomLookupTag.createTag(testTag.Name, testCase.Id);
        R1_CustomLookupTag.addTag(testTag_2.Name, testCase.Id); 
        
        // Add your assertions here based on expected results
        System.assertEquals('Success', result, 'Expected result should be "Success"');
    }
}