public without sharing class R1_HandlerCheckShiftForAgentController {
    @AuraEnabled
    public static string getShiftForAgent() {
        String shift;
        try {
            List<User> u = [SELECT Id , Name, Id_Agent_Using__c FROM User WHERE Id =: userInfo.getUserId()];
            if(u.size() > 0) {
                List<Master_Data__c> mtd = [SELECT Id, Name, Shift_inprogress__c FROM Master_Data__c WHERE Id =: u[0].Id_Agent_Using__c];
                if(mtd.size() > 0) {List<Work_Management__c> wm = [SELECT Id, Name, Shift__c FROM Work_Management__c WHERE Id =:mtd[0].Shift_inprogress__c];if(wm.size() > 0) { shift =  wm[0].Shift__c;}
                } 
            } 
        } catch(System.CalloutException e) {
            System.debug('[GMS_CallApiGateway] -> callApi() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        system.debug(shift);
        return shift; 
    }
}