/**
* @description       : The Controller for Call Api Gateway
* @author            : DTDuong - GMS
* @last modified on  : 2024.05.13
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

public class GMS_CallApiGateway {
    
    private static Final String baseUrl = Omni_Gateway__c.getInstance('Endpoint').Value__c;
    private static String token;

	public static HttpResponse callAPI(String content, String endpoint, String method, String requestBody, String customeBaseUrl) {
        // String token = R1_OmniGatewayTokenSchedule.GetAccessToken();
        if(!Test.isRunningTest()) {
            token = Omni_Gateway__c.getInstance('Token').Value__c + Omni_Gateway__c.getInstance('Token_2').Value__c + Omni_Gateway__c.getInstance('Token_3').Value__c + Omni_Gateway__c.getInstance('Token_4').Value__c + Omni_Gateway__c.getInstance('Token_5').Value__c;
            
        } else {
            token = '';
        }
        system.debug(token);
        HttpRequest req = new HttpRequest();
        String finalUrl = '';
        if (String.isBlank(customeBaseUrl)) { 
            finalUrl = baseUrl + endpoint;
        } else {
            finalUrl = customeBaseUrl + endpoint;
        }
        system.debug(finalUrl);
        req.setEndpoint(finalUrl);
        req.setMethod(method);
        
        // Set the Authorization header with the Bearer token
        req.setHeader('Authorization', 'Bearer ' + token);
        
        // Set any other necessary headers
        // For example, setting content type to JSON if required
        String contentType = 'application/json';
        req.setHeader('Content-Type', contentType);
        
        // Set the request body if needed
        if (requestBody != null) {
            req.setBody(requestBody);
        }
    
        // Send the request and handle exceptions
        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(req);
            Log_Utils.createLogApi(content, req, endpoint, res);
        } catch(System.CalloutException e) {
            // Handle callout exceptions
            res = new HttpResponse();res.setStatusCode(500); res.setBody('Callout Error: ' + e.getMessage());
            System.debug('[GMS_CallApiGateway] -> callApi() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
            Log_Utils.createLogApi(content, req, endpoint, res);
        }

    	return res;
	}
	
}