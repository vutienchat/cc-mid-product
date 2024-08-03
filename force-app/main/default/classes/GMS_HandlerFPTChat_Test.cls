@isTest
public class GMS_HandlerFPTChat_Test {
@isTest
    static void testAcceptChat() {
        // Set up the mock response
        HttpResponseMock mockResponse = new HttpResponseMock();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"status":"success"}');
        
        // Set the mock callout
        Test.setMock(HttpCalloutMock.class, mockResponse);
        
        // Test data
        String testChannel = 'testChannel';
        String testSenderId = 'testSenderId';
        
        Test.startTest();
        GMS_HandlerFPTChat.acceptChat(testChannel, testSenderId);
        Test.stopTest();
    }
    
    private class HttpResponseMock implements HttpCalloutMock {
        private Integer statusCode;
        private String body;
        
        public void setStatusCode(Integer statusCode) {
            this.statusCode = statusCode;
        }
        
        public void setBody(String body) {
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(this.statusCode);
            res.setBody(this.body);
            return res;
        }
    }
}