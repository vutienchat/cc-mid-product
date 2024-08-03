public without sharing class GMS_CustomCreateWorkShipController {
    @AuraEnabled
    public static List<PicklistValue> getGlobalPicklistValues() {
        
        List<PicklistValue> picklistValues = new List<PicklistValue>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Master_Data__c').getDescribe().fields.getMap().get('Unit_by_region__c').getDescribe();
        
        User u = [SELECT Id , Name FROM User WHERE Id =: userInfo.getUserId()];
        List<Master_Data__c> mt = [SELECT Id, Name, User_uses__c, Unit_by_region__c FROM Master_Data__c WHERE User_uses__c =: u.Id LIMIT 1];
        

        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            PicklistValue p = new PicklistValue();
            p.label = entry.getLabel();
            p.value = entry.getValue();
            if(mt.size() > 0) {
                p.defaultValue = mt[0].Unit_by_region__c;
            }
            picklistValues.add(p); 
            
        }
        return picklistValues;
        
    }
    
    @AuraEnabled
    public static List<PicklistValue> getAgentByPartner(String partner) {
        
        List<PicklistValue> picklistValues = new List<PicklistValue>();
        List<Master_Data__c> lstMasterData = [SELECT Id, Name, Unit_by_region__c 
                                              FROM Master_Data__c 
                                              WHERE RecordType.Name = 'Agent' 
                                              AND Unit_by_region__c =: partner];
        for(Master_Data__c item : lstMasterData) {
            PicklistValue p = new PicklistValue();
            p.label = item.Name;
            p.value = item.Id;
            picklistValues.add(p);
        }
        return picklistValues;
        
    }
    
    public class PicklistValue {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public String defaultValue { get; set; }
    }
}