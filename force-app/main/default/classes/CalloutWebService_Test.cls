@istest
public class CalloutWebService_Test {
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"animals":["majestic badger","fluffy bunny","scary bear","chicken"]}');
        res.setStatusCode(200);
        return res;
    }
    }        
    @isTest
    public static void testGetCalloutResponseContents() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to test
        Test.startTest();
        String response = CalloutWebService.getCalloutResponseContents();
        Test.stopTest();
    }
}