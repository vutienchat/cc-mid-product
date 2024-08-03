global class R1_OmniGatewayTokenSchedule implements Schedulable {
    global void execute(SchedulableContext SC){
        callExecute();
    }
    
    @future(callout = true)
    public static void callExecute(){
        List<Omni_Gateway__c> omniGateway_Setting = [Select Id, Name,Value__c from Omni_Gateway__c where Name LIKE 'Token%'];
        if(!omniGateway_Setting.isEmpty()){
            List<String> lstToken = splitText(GetAccessToken(), 250);
            for(Omni_Gateway__c iToken :omniGateway_Setting){
                system.debug(iToken.Name);
                if(iToken.Name == 'Token') iToken.Value__c = lstToken[0];
                if(iToken.Name == 'Token_2') iToken.Value__c = lstToken[1];
                if(iToken.Name == 'Token_3') iToken.Value__c = lstToken[2];
                if(iToken.Name == 'Token_4') iToken.Value__c = lstToken[3];
                if(iToken.Name == 'Token_5') iToken.Value__c = lstToken[4];
            }
            
            // Cách lấy OmniGatewayToken => String token = Omni_Gateway__c.getInstance('Token').Value__c + Omni_Gateway__c.getInstance('Token_2').Value__c + Omni_Gateway__c.getInstance('Token_3').Value__c + Omni_Gateway__c.getInstance('Token_4').Value__c + Omni_Gateway__c.getInstance('Token_5').Value__c;

            update omniGateway_Setting;
        }
    }
    
    public static String GetAccessToken(){
        String access_token = '';
        try{
            String endpoint = Omni_Gateway__c.getInstance('Endpoint').Value__c;
            endpoint = endpoint + 'oauth2/token';
            String grant_type = Omni_Gateway__c.getInstance('grant_type').Value__c;
            String Content_Type = Omni_Gateway__c.getInstance('Content_Type').Value__c;
            String authorization = Omni_Gateway__c.getInstance('Authorization').Value__c;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setMethod('POST');
            request.setEndpoint(endpoint);
            
            request.setHeader('Authorization',authorization);
            request.setHeader('Content-Type',Content_Type);
            String reqbody = 'grant_type='+grant_type;
            request.setBody(reqbody);            
            response = http.send(request);
        
            system.debug('mapResbody :' + response.getBody());
        
            Map<String,Object> mapResbody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            access_token = (String) mapResbody.get('access_token');
            system.debug('access_token: ' + access_token.length());
        }catch(Exception e){
            System.debug('R1_OmniGatewayTokenSchedule --> GetAccessToken:' + e.getMessage() + ' at line ' + e.getLineNumber());
        }
        return access_token;
    }
    
    public static List<String> splitText(String text, Integer partLength) {
        List<String> parts = new List<String>();
        Integer textLength = text.length();
        for (Integer i = 0; i < textLength; i += partLength) {
            Integer endIndex = Math.min(i + partLength, textLength);
            parts.add(text.substring(i, endIndex));
        }
        return parts;
    }
    
}