/*
*********************************************************
Apex Class Name    : ShowSlotAgentController
Created Date       : 10/05/2024
@description       : xử lý hiển thị slot agent
@author            : ntluan (GMS)
*********************************************************
*/
public class ShowSlotAgentController {
    @AuraEnabled
    public static List<workShipResultWrapper> querySlot(Date startDate, Date endDate, String partner) {

        system.debug(partner);
        Integer userMax = 0;
        if(!Test.isRunningTest()){
        User_by_company_region__mdt userByCompanyRegion = [SELECT MasterLabel, User_Number__c FROM User_by_company_region__mdt where MasterLabel =: partner]; 
        userMax = integer.valueOf(userByCompanyRegion.User_Number__c);
        } else { 
            userMax = 10;
        }
        List<workShipResultWrapper> lstWorkShipResultWrapper = new List<workShipResultWrapper>();
        List<AggregateResult> lstWorkShipLineItems = [SELECT Count(id) countId, Time__c, Date__c 
                                                      FROM WorkShip_Line_Item__c
                                                      GROUP BY Time__c , Date__c
                                                      HAVING Date__c >=: startDate AND Date__c <=: endDate
                                                     ];
        if(lstWorkShipLineItems.size() > 0) {
            for(AggregateResult ar : lstWorkShipLineItems) {
                workShipResultWrapper wSRW = new workShipResultWrapper();
                wSRW.userUsing = string.ValueOf(ar.get('countId'));
                wSRW.userSystem = string.ValueOf(userMax); 
                wSRW.hour = string.ValueOf(ar.get('Time__c')) + '-' + string.valueOf(integer.valueOf(ar.get('Time__c')) + 1);
                wSRW.day = string.ValueOf(ar.get('Date__c'));
                wSRW.userMissing = string.valueOf(integer.valueOf(wSRW.userSystem) - integer.valueOf(wSRW.userUsing ));
                lstWorkShipResultWrapper.add(wSRW);
            } 
        }
        system.debug(lstWorkShipResultWrapper);
        return lstWorkShipResultWrapper;
    }
    @AuraEnabled
    public static void deleteWorkManagerment(String key) {
        List<WorkShip_Line_Item__c> lst = [SELECT Id FROM WorkShip_Line_Item__c Where KeyFlow__c =: key];
        if(lst.size() > 0) {
            delete lst;
        }
    }
    public class workShipResultWrapper {
        @AuraEnabled
        public String userUsing {get;set;}
        @AuraEnabled
        public String userSystem {get;set;}
        @AuraEnabled
        public String hour {get;set;}
        @AuraEnabled
        public String day {get;set;}
        @AuraEnabled
        public String userMissing {get;set;}
        @AuraEnabled
        public String shift {get;set;}
        @AuraEnabled
        public List<Work_Management__c> lstWorkShip {get;set;}
    }
}