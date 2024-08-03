@isTest
public class GMS_SearchContactInfoController_Test {
    @testSetup
    static void setupTestData() {
        Omni_Gateway__c settings = new Omni_Gateway__c();
        settings.Name = 'Endpoint';
        settings.Value__c = 'Endpoint';
        insert settings;
        
        Omni_Gateway__c settings1 = new Omni_Gateway__c();
        settings1.Name = 'grant_type';
        settings1.Value__c = 'grant_type';
        insert settings1;
        
        Omni_Gateway__c settings3 = new Omni_Gateway__c();
        settings3.Name = 'Content_Type';
        settings3.Value__c = 'Content_Type';
        insert settings3;                
        
        Omni_Gateway__c settings2 = new Omni_Gateway__c();
        settings2.Name = 'Authorization';
        settings2.Value__c = 'Authorization';
        insert settings2;
        
        Omni_Gateway__c settings5 = new Omni_Gateway__c();
        settings5.Name = 'Token';
        settings5.Value__c = 'Token';
        insert settings5;
        
        // Create a test contact
        Contact testContact = new Contact(
            LastName = 'Test Contact',
            Phone = '939198882',
            Sub_Id__c = 'TestSubId'
        );
        insert testContact;
        
        // Create Master Data records
        List<Master_Data__c> masterDataList = new List<Master_Data__c>();
        for (Integer i = 0; i < 5; i++) {
            masterDataList.add(new Master_Data__c(
                Name = 'Unit ' + i,
                Accept_Source_Id__c = 'SourceId' + i,
                RecordTypeId = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByName().get('Unit').getRecordTypeId()
            ));
        }
        insert masterDataList;
    }
    
    @isTest
    static void testGetGlobalPicklistValues() {
        Test.startTest();
        List<GMS_SearchContactInfoController.PicklistValue> picklistValues = GMS_SearchContactInfoController.getGlobalPicklistValues();
        Test.stopTest();   
    }
    
    @isTest
    static void testGetContactInformation() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        Contact result = GMS_SearchContactInfoController.getContactInformation(testContact.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testFetchLookUpValues() {
        Test.startTest();
        List<Master_Data__c> result = GMS_SearchContactInfoController.fetchLookUpValues('Unit', 'Master_Data__c');
        Test.stopTest();
        
    }
    
    @isTest
    static void testSearchReflectingComplaints() {
        Master_Data__c unit = [SELECT Id, Accept_Source_Id__c FROM Master_Data__c LIMIT 1];
        Date fromDate = Date.today().addMonths(-1);
        Date toDate = Date.today();
        
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        List<GMS_SearchContactInfoController.DataReflectingComplaints> result = GMS_SearchContactInfoController.searchReflectingComplaints('1234567890', fromDate, toDate, unit, 'Open');
        Test.stopTest();
    }
    
    @isTest
    static void testSearchHistory() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        List<GMS_SearchContactInfoController.DataHistory> result = GMS_SearchContactInfoController.searchHistory(testContact.Id);
        Test.stopTest();

    }
    
    @isTest
    static void testSearchDataARPU() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        List<GMS_SearchContactInfoController.DataARPU> result = GMS_SearchContactInfoController.searchDataARPU(testContact.Id);
        Test.stopTest();

    }
    
    @isTest
    static void testSearchServicePackage() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        List<GMS_SearchContactInfoController.DataServicePackage> result = GMS_SearchContactInfoController.searchServicePackage(testContact.Id);
        Test.stopTest();

    }
    
    @isTest
    static void testSearchCSDLQG() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        GMS_SearchContactInfoController.ResponseCSDLQG result = GMS_SearchContactInfoController.searchCSDLQG(testContact.Id);
        Test.stopTest();
        
    }
    
    @isTest
    static void testSearchHotLine() {
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, new GMS_MockHttpResponseGenerator());
        Test.startTest();
        GMS_SearchContactInfoController.ResponseHotLine result = GMS_SearchContactInfoController.searchHotLine(testContact.Id);
        Test.stopTest();

    }
}