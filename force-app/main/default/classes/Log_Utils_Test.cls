@isTest
private class Log_Utils_Test {
    @isTest
    static void testCreateLogApi() {
        // Create mock HTTP request and response objects
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://example.com/api');
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setBody('{"key": "value"}');

        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        httpResponse.setBody('{"responseKey": "responseValue"}');

        // Call the utility method
        Log_Utils.createLogApi('Outbound', httpRequest, 'https://example.com/api', httpResponse);

        // Add assertions or additional tests as needed
        // For example, query the inserted Log records and verify their values
    }

    @isTest
    static void testCreateLogApiInbound() {
        // Create mock RestRequest and RestResponse objects
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/myEndpoint';
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueOf('{"param": "value"}');

        RestResponse response = new RestResponse();
        response.statusCode = 200;
        response.responseBody = Blob.valueOf('{"result": "success"}');

        // Call the utility method
        Log_Utils.createLogApiInbound('Inbound', request, '/services/apexrest/myEndpoint', response);

        // Add assertions or additional tests as needed
        // For example, query the inserted Log records and verify their values
    }
}