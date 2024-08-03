/**
* @description       : The Class for Log
* @author            : DTDuong - GMS
* @last modified on  : 2024.04.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/

public class Log_Utils {
    private static final Integer MAX_LENGTH = 131072;
    
	
    public static void createLogApi(String origin, HttpRequest httpRequest, String uri, HttpResponse httpResponse) {
        gms_resync__Log_API__c extLog = new gms_resync__Log_API__c();
        extLog.Origin__c = origin;
        extLog.Type__c = 'Outbound';
        extLog.OwnerId = System.UserInfo.getUserId();
        extLog.gms_resync__Request__c = httpRequest.toString();
        extLog.Endpoint__c = httpRequest.getEndpoint();
        extLog.Request_Body__c = httpRequest.getBody();
        extLog.gms_resync__Method__c = httpRequest.getMethod();
        extLog.gms_resync__URL__c = uri;
        extLog.gms_resync__Response__c = httpResponse.toString();
        extLog.Response_Body__c = httpResponse.getBody();
        extLog.Http_Status__c = String.valueOf(httpResponse.getStatusCode());
        try {
            Database.insert(extLog, false);
        } catch (Exception e) {
            System.debug('[Log_Utils] -> createLogApi() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }       
    }
    
    public static void createLogApiInbound(String origin, RestRequest request, String uri, RestResponse response) {
        gms_resync__Log_API__c extLog = new gms_resync__Log_API__c();
        extLog.Origin__c = origin;
        extLog.Type__c = 'Inbound';
        extLog.OwnerId = UserInfo.getUserId();
        extLog.gms_resync__Request__c = request.requestBody.toString();
        extLog.Endpoint__c = uri;
        extLog.Request_Body__c = request.requestBody.toString();
        extLog.gms_resync__Method__c = request.httpMethod;
        extLog.gms_resync__URL__c = request.requestURI;
        extLog.gms_resync__Response__c = response.responseBody.toString();
        extLog.Response_Body__c = response.responseBody.toString();
        extLog.Http_Status__c = String.valueOf(response.statusCode);
        try {
            Database.insert(extLog, false);
        } catch (Exception e) {
            System.debug('[Log_Utils] -> createLogApiInbound() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        } 
    }
}