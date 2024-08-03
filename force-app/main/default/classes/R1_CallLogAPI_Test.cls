/**
* @description       : The Class for test R1_CallLogAPI
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.04
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@IsTest
public class R1_CallLogAPI_Test {
    @testSetup static void InitTestData(){
        Soft_Phone__c settings = new Soft_Phone__c();
        settings.Name = 'endpoint_middleware';
        settings.Value__c = 'endpoint_middleware';
        insert settings;
        
        Soft_Phone__c settings1 = new Soft_Phone__c();
        settings1.Name = 'userAuthSpx';
        settings1.Value__c = 'userAuthSpx';
        insert settings1;
        
        Soft_Phone__c settings3 = new Soft_Phone__c();
        settings3.Name = 'passwordAuthSpx';
        settings3.Value__c = 'passwordAuthSpx';
        insert settings3;                
    }
    @isTest
    static void testcallAPI(){
        String callRecordTypeID = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Call').getRecordTypeId();
        String agentRecordTypeID = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
		Master_Data__c iAgent = new Master_Data__c();
        iAgent.RecordtypeId = agentRecordTypeID;
        iAgent.Name = 'Agent';
        iAgent.Agent_Id__c = 'be527727-416b-424d-8aad-6bf537877b52';
        insert iAgent;
        
        Task iTask = new Task();
        iTask.RecordTypeId = callRecordTypeID;
        iTask.Subject = 'Test Call Log';
        iTask.Agent__c = iAgent.Id;
        
        insert iTask;
        
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        R1_CallLogAPI.getCallLogAPI(iTask.Id);
        System.Test.stopTest();
    }
    public class MockHttpResponse implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('GET', req.getMethod());
            String body = '{ "responseCode": "200", "responseMessage": "Thành công", "responseData": { "callID": null, "agentId": "be527727-416b-424d-8aad-6bf537877b52", "transferedAgentId": null, "line": "02871079983", "numberDial": "DV Di Dong", "startDate": "2024-07-04T02:08:43.13", "endDate": "2024-07-04T02:19:21.97", "duration": "638", "extension": "2003", "customerNumber": "0793042678", "dialedNumber": null, "state": 2, "callPhase": 9, "agentTalkTimeSeconds": 586, "linkRecord": "https://frontstage.apac-ancontact.com/ccaastri2/pages/calleditor.html?Id=ec2acf7e-b91c-ef11-96f5-00224858a4c3", "callType": 1, "isAnsweredIntime": true } }';
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            res.setStatusCode(200);
            return res;
        }
    }
}