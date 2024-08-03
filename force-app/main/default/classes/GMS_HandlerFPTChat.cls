global without sharing class GMS_HandlerFPTChat {
    private static final String ENDPOINT ='callout:GMS_Lab_FPT__GMS_Named_Credential_FPT_AI';
    /**
* @description 
* @author HTMan | 05-09-2024 
* @param channel 
* @param senderId 
* @return HttpResponse 
**/
    @Future (callout=true)
    public static void acceptChat(String channel, String senderId) {
        try {
            Map<String,Object> mapBody = new Map<String,Object>();
            
            mapBody.put('channel',channel);
            mapBody.put('sender_id',senderId);
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', '*/*');
            request.setEndpoint(ENDPOINT+'/accept');
            
            System.debug('acceptChat JSON.serialize(mapBody): ' + JSON.serialize(mapBody));            
            // Set the body as a JSON object
            request.setBody(JSON.serialize(mapBody));
            
            // Make the callout
            HttpResponse response = http.send(request);
            // mapResult.put('resBody',response.getBody());
            
        } catch (Exception e) {
            // mapResult.put('Exception',e.getMessage());
        }
        // return mapResult;
    }
}