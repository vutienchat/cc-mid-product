public class CreateRecordInWorkShift {
    @InvocableMethod(label='Create Work Shift')  
    public static void insertListWorkShift(List<FlowInputs> request) {
        system.debug(request[0].idAgent);
        //ID jobID = System.enqueueJob(new InsertListWorkShift_BatchJob(request[0].idAgent, request[0].shift, request[0].fromDate, request[0].toDate));
        List<Work_Management__c> lstWorkManagement = new List<Work_Management__c>();
        List<WorkShip_Line_Item__c> lstWorkshipLineItem = new List<WorkShip_Line_Item__c>();
        List<Date> lstWorkingDate = new List<Date>();
        for(String item : request[0].idAgent) {
            Date fr = request[0].fromDate;
            for(integer i = 0 ; i <= Math.abs(request[0].toDate.daysBetween(request[0].fromDate)) ; i++) {
                //List<String> days = request[0].shift.split('-');
                List<String> timeStart = request[0].fromTime.split(':');
                List<String> timeEnd = request[0].toTime.split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]); 
                fr = request[0].fromDate.addDays(i);
                for(integer j = starts ; j < ends ; j++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = item; 
                    workshipLineItem.Time__c = String.valueOf(j);
                    workshipLineItem.Date__c = fr;
                    workshipLineItem.Shift__c = request[0].fromTime + '-' + request[0].toTime;
                    workshipLineItem.KeyFlow__c = request[0].key;
                    workshipLineItem.Unit__c = request[0].partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = item;
                w.Shift__c = request[0].fromTime + '-' + request[0].toTime;
                w.Working_Date__c = fr;
                lstWorkManagement.add(w);
                lstWorkingDate.add(fr);
            }  
        }
        insert lstWorkshipLineItem;
    }
    public class FlowInputs{
        @InvocableVariable
        public List<Id> idAgent;
        @InvocableVariable
        public String fromTime;  
        @InvocableVariable
        public String toTime;  
        @InvocableVariable
        public Date fromDate;  
        @InvocableVariable
        public Date toDate;   
        @InvocableVariable
        public String key;  
        @InvocableVariable
        public String partner; 
    }
}