@istest
public class CaseTrigger_Test {
        @testSetup
        static void setupTestData() {
            // Create test Account
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
            
            // Create test Contact
            Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
            insert testContact;
            
            Contact testContact2 = new Contact(LastName = 'Test Contact 2', AccountId = testAccount.Id);
            insert testContact2;
            
            // Create test Entitlement
            Entitlement testEntitlement = new Entitlement(
                Name = 'Test Entitlement', 
                AccountId = testAccount.Id, 
                StartDate = Date.today().addDays(-10), 
                EndDate = Date.today().addDays(10)
            );
            insert testEntitlement;
            
            Entitlement testEntitlement2 = new Entitlement(
                Name = 'Test Entitlement 2', 
                AccountId = testAccount.Id, 
                StartDate = Date.today().addDays(5), 
                EndDate = Date.today().addDays(10)
            );
            insert testEntitlement2;
            
            
            // Create test EntitlementContact
            EntitlementContact testEntitlementContact = new EntitlementContact(
                ContactId = testContact.Id, 
                EntitlementId = testEntitlement.Id
            );
            insert testEntitlementContact;
            
            
            EntitlementContact testEntitlementContact2 = new EntitlementContact(
                ContactId = testContact2.Id,
                EntitlementId = testEntitlement2.Id
                
            );
            insert testEntitlementContact2;
            
            // Create Asset
            Asset testAsset = new Asset(
                Name = 'Test Asset', 
                AccountId = testAccount.Id
            );
            insert testAsset;
            
            // Assign Asset to Entitlement
            testEntitlement.AssetId = testAsset.Id;
            update testEntitlement;
        }
        
        @isTest
        static void testCaseInsert() {
            // Fetch the test data
            Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
            Contact testContact = [SELECT Id FROM Contact WHERE LastName = 'Test Contact' LIMIT 1];
            
            Contact testContact2 = [SELECT Id FROM Contact WHERE LastName = 'Test Contact 2' LIMIT 1];
            
            RecordType testRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'PAKH' LIMIT 1];
            Entitlement testEntitlement = [SELECT Id, AssetId FROM Entitlement WHERE Name = 'Test Entitlement' LIMIT 1];
            Entitlement testEntitlement2 = [SELECT Id, AssetId FROM Entitlement WHERE Name = 'Test Entitlement 2' LIMIT 1];
            
            // Insert Case
            // đổi default value của request group trong recordtype về null nếu lỗi deploy
            Case testCase = new Case(
                AccountId = testAccount.Id, 
                ContactId = testContact.Id, 
                RecordTypeId = testRecordType.Id
            );
            insert testCase;
            
             Case testCase2 = new Case(
                AccountId = testAccount.Id, 
                ContactId = testContact2.Id, 
                RecordTypeId = testRecordType.Id
            );
            insert testCase2;
        }
        
        @isTest
        static void testCaseUpdate() {
            // Fetch the test data
            Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
            Contact testContact = [SELECT Id FROM Contact WHERE LastName = 'Test Contact' LIMIT 1];
            RecordType testRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'PAKH' LIMIT 1];
            
            // Insert a Case with a different RecordType
            Case testCase = new Case(
                AccountId = testAccount.Id, 
                ContactId = testContact.Id, 
                RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName != 'PAKH' LIMIT 1].Id
            );
            insert testCase;
            
            // Update Case to switch to the PAKH RecordType
            testCase.RecordTypeId = testRecordType.Id;
            update testCase;

        }
    }