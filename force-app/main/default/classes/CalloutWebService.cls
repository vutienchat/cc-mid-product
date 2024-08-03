public with sharing class CalloutWebService {
    public CalloutWebService() {

    }

    @AuraEnabled
    public static String getCalloutResponseContents() {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
            req.setMethod('GET');
            Http http = new Http();
            HttpResponse res = http.send(req);
            return res.getBody();
       } catch(System.CalloutException e) { throw new AuraHandledException(e.getMessage());}
    }


}