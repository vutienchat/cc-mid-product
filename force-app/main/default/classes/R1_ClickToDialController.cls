public class R1_ClickToDialController {
	@AuraEnabled
    public static Task getTaskDB(String recordId){
        Task result = new Task();
        try{
            result = [SELECT id, Phone__c FROM Task WHERE id=: recordId];
        }catch (Exception ex) {throw new AuraHandledException(ex.getMessage());		

            // return null;
        }
        return result;
    }
}