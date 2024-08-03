/**
* @description       : The Class for test R1_OmniGatewayTokenSchedule
* @author            : ndmanh - GMS
* @last modified on  : 2024.07.04
* @last modified by  : Nguyen Duc Manh(ndmanh@gimasys.com)
* @history           :    date                    author                      content
**/
@IsTest
public class R1_OmniGatewayTokenSchedule_Test {
    @testSetup static void InitTestData(){
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
    }
     @isTest
    public static void test1(){
        Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        R1_OmniGatewayTokenSchedule.callExecute();
        Test.stopTest();
    }
    public class MockHttpResponse implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('POST', req.getMethod());
            String body = '{"access_token":"eyJ4NXQiOiJNV0l5TkRJNVlqRTJaV1kxT0RNd01XSTNOR1ptTVRZeU5UTTJOVFZoWlRnMU5UTTNaVE5oTldKbVpERTFPVEE0TldFMVlUaGxNak5sTldFellqSXlZUSIsImtpZCI6Ik1XSXlOREk1WWpFMlpXWTFPRE13TVdJM05HWm1NVFl5TlRNMk5UVmhaVGcxTlRNM1pUTmhOV0ptWkRFMU9UQTROV0UxWVRobE1qTmxOV0V6WWpJeVlRX1JTMjU2IiwidHlwIjoiYXQrand0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJlMWIwZWY0MC04N2JkLTQyMzEtODdlOS0wZTQ3MzBhOGQ4OTciLCJhdXQiOiJBUFBMSUNBVElPTiIsImF1ZCI6IlQ1MUpDOEJWM3JodG1qb1ZOUTJ5TGF3dDFaMGEiLCJuYmYiOjE3MjAwODQxMjEsImF6cCI6IlQ1MUpDOEJWM3JodG1qb1ZOUTJ5TGF3dDFaMGEiLCJzY29wZSI6ImRlZmF1bHQiLCJpc3MiOiJodHRwczpcL1wvbG9jYWxob3N0Ojk0NDNcL29hdXRoMlwvdG9rZW4iLCJleHAiOjE3MjAwODgzMjEsImlhdCI6MTcyMDA4NDEyMSwianRpIjoiMTlhYjdmYWItOTViOS00Y2U2LThlZDctMTljZDk0NDRmOTliIiwiY2xpZW50X2lkIjoiVDUxSkM4QlYzcmh0bWpvVk5RMnlMYXd0MVowYSJ9.ACQfEfSZ14b0aygQMwGsKF7s_magK2NJZWNIQ_4JCm7Fua08gVzIVns2VwybFQyV2w5qyO9NwR09m8F_Vq0DM4fJFnmn_5J9JaXFswfWTsUOQxoAr-xR1aZ6EcrdcEb2s3Il7HVeEBz5fPk-8GJX60W5oLPo734aqUxCO_H3nfAn-c3wtmjk5T2qowUHtEmbUJde8gxtMml2DerH5MhkZghLNQi2BtkP7D_Kzcn2e7LKutMdaJp9_hdoaeWM4jHIX5eGdTXU76XO5UpCSeiOgvP2b709r7AqM77QUaobtoQM4aJw69LbARtKgHVdN7Ahn04tivyLMElw1VXCcAJv6Q","scope":"default","token_type":"Bearer","expires_in":4200}';
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            res.setStatusCode(200);
            return res;
        }
    }
}