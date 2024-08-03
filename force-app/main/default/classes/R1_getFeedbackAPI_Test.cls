/**
* @description       : The Class for test R1_getFeedbackAPI
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.04
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@IsTest
public class R1_getFeedbackAPI_Test {
    @isTest 
    static void testPostMethod(){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PAKH').getRecordTypeId();
        
        Contact iCont = new Contact();
        iCont.LastName ='Test get Fb';
        iCont.Phone = '0979377285';
        
        insert iCont;
        
        Case iCase = new Case();
        iCase.ContactId = iCont.Id;
        iCase.recordtypeId = recordTypeId;
        iCase.Status = 'New';
        
        insert iCase;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/accountInterestUpdate/';
        String JSONMsg = '{ "phone": "0979377285" }';
        req.requestBody = Blob.valueof(JSONMsg);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        R1_getFeedbackAPI.doPost();
        Test.stopTest();
        
    }
    
    @isTest 
    static void testPostMethodNullCase(){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PAKH').getRecordTypeId();
        
        Contact iCont = new Contact();
        iCont.LastName ='Test get Fb';
        iCont.Phone = '0979377285';
        
        insert iCont;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/accountInterestUpdate/';
        String JSONMsg = '{ "phone": "0979377285" }';
        req.requestBody = Blob.valueof(JSONMsg);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        R1_getFeedbackAPI.doPost();
        Test.stopTest();
    }
    
    @isTest 
    static void testPostMethodNullContact(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/accountInterestUpdate/';
        String JSONMsg = '{ "phone": "0979377285" }';
        req.requestBody = Blob.valueof(JSONMsg);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        R1_getFeedbackAPI.doPost();
        Test.stopTest();
    }
}