public without sharing class UploadWorkShipController {
    public class PicklistValue {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public String defaultValue { get; set; }
    }

    @AuraEnabled
    public static List<PicklistValue> getGlobalPicklistValues() {
        
        List<PicklistValue> picklistValues = new List<PicklistValue>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Master_Data__c').getDescribe().fields.getMap().get('Unit_by_region__c').getDescribe();
        User u = [SELECT Id , Name FROM User WHERE Id =: userInfo.getUserId()];
        Master_Data__c mt = [SELECT Id, Name, User_uses__c, Unit_by_region__c FROM Master_Data__c WHERE User_uses__c =: u.Id LIMIT 1];
        
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            PicklistValue p = new PicklistValue();
            p.label = entry.getLabel();
            p.value = entry.getValue();
            p.defaultValue = mt.Unit_by_region__c;
            picklistValues.add(p); 

        }
        return picklistValues;
        
    }
    
    @AuraEnabled
    public static String getDefaulValuePartner() {
        User u = [SELECT Id , Name FROM User WHERE Id =: userInfo.getUserId()];
        Master_Data__c mt = [SELECT Id, Name, User_uses__c, Unit_by_region__c FROM Master_Data__c WHERE User_uses__c =: u.Id LIMIT 1];
        system.debug(mt);
        return mt.Unit_by_region__c;
    } 
    
    @AuraEnabled
    public static boolean checkWorkShipDup(String month, String year, String partner) {
        
        //Master_Data__c agent = [Select Id, Unit_by_region__c  From Master_Data__c Where User_uses__c =: UserInfo.getUserId() LIMIT 1];
        String key = month + year;
        boolean isdupWorkShip = false;
        List<WorkShip_Line_Item__c> lstWorkManagementCheck = [SELECT Id, Key__c FROM WorkShip_Line_Item__c WHERE Key__c =: key AND Unit__c =: partner]; 
        
        if(!lstWorkManagementCheck.isEmpty()) {
            isdupWorkShip = true;
        }
        system.debug(isdupWorkShip);
        return isdupWorkShip;
    }
    
    @AuraEnabled
    public static List<Work_Management__c> saveFile(String base64Data, String month, String yearImport, String partner) {
        Integer year = Integer.valueOf(yearImport);
        Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        List<workShipResultWrapper> lstWorkShipResultWrapper = new List<workShipResultWrapper>();
        Set<String> setAgentId = new Set<String>();
        Map<String,String> mapOfAgentNameAndAgentId = new Map<String,String>();
        List<Work_Management__c> lstWorkManagement = new List<Work_Management__c>();
        
        //String data = JSON.deserializeUntyped(base64Data).toString();
        //list<String> lstCSVLines = data.split('\n');
        
        List<workShipWrapper> lstWorkShip = new List<workShipWrapper>();
        
        //for(Integer i = 1; i < lstCSVLines.size(); i++) {
            
            workShipWrapper wSWrapper = new workShipWrapper();
            String csvLine = base64Data;
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;

            List<String> csvRowData = new List<String>();
            system.debug(csvLine);
            for(String column : csvLine.split(',')) {  
                column = column.replaceAll(':quotes:','').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
             wSWrapper.stt = csvRowData[0];
            wSWrapper.agentName = csvRowData[1];
            wSWrapper.DS = csvRowData[2];
            wSWrapper.day1 = csvRowData[3];
            wSWrapper.day2 = csvRowData[4];
            wSWrapper.day3 = csvRowData[5];
            wSWrapper.day4 = csvRowData[6];
            wSWrapper.day5 = csvRowData[7];
            wSWrapper.day6 = csvRowData[8];
            wSWrapper.day7 = csvRowData[9];
            wSWrapper.day8 = csvRowData[10];
            wSWrapper.day9 = csvRowData[11];
            wSWrapper.day10 = csvRowData[12];
            wSWrapper.day11 = csvRowData[13];
            wSWrapper.day12 = csvRowData[14];
            wSWrapper.day13 = csvRowData[15];
            wSWrapper.day14 = csvRowData[16];
            wSWrapper.day15 = csvRowData[17];
            wSWrapper.day16 = csvRowData[18];
            wSWrapper.day17 = csvRowData[19];
            wSWrapper.day18 = csvRowData[20];
            wSWrapper.day19 = csvRowData[21];
            wSWrapper.day20 = csvRowData[22];
            wSWrapper.day21 = csvRowData[23];
            wSWrapper.day22 = csvRowData[24];
            wSWrapper.day23 = csvRowData[25];
            wSWrapper.day24 = csvRowData[26];
            wSWrapper.day25 = csvRowData[27];
            wSWrapper.day26 = csvRowData[28];
            wSWrapper.day27 = csvRowData[29]; 
            wSWrapper.day28 = csvRowData[30];
            wSWrapper.day29 = csvRowData[31]; 
            wSWrapper.day30 = csvRowData[32];
            if(csvRowData.size() > 33) { 
                wSWrapper.day31 = csvRowData[33];
            } 
            lstWorkShip.add(wSWrapper);
        for(workShipWrapper items : lstWorkShip) {
            setAgentId.add(items.DS);
        }
        String key = month + yearImport;
        
        //Master_Data__c agent = [Select Id, Unit_by_region__c  From Master_Data__c Where User_uses__c =: UserInfo.getUserId() LIMIT 1];
        
        
        
        
        List<Master_Data__c> lstAgent = [Select Id, Agent_Name__c, Agent_Id__c, Agent_Code__c, Unit_by_region__c
                                         From Master_Data__c 
                                         Where Agent_Code__c =: setAgentId];
        
        
            
        for(Master_Data__c items : lstAgent) {
            mapOfAgentNameAndAgentId.put(items.Agent_Code__c, items.Id);
        }
        
        List<WorkShip_Line_Item__c> lstWorkshipLineItem = new List<WorkShip_Line_Item__c>();
        for(workShipWrapper items : lstWorkShip) {
            system.debug(items);
            if(items.day1 != null && items.day1 != '' && (!String.isBlank(items.day1))) {
                List<String> days = items.day1.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 01);
                    workshipLineItem.Shift__c = items.day1;
                    workshipLineItem.Unit__c = partner; 
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day1;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 01);
                 
                lstWorkManagement.add(w);
            }
            if(items.day2 != null && items.day2 != '' && (!String.isBlank(items.day2))) {
                List<String> days = items.day2.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 02);
                    workshipLineItem.Shift__c = items.day2;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day2;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 02);
                 
                lstWorkManagement.add(w);
            }
            if(items.day3 != null && items.day3 != '' && (!String.isBlank(items.day3))) {
                List<String> days = items.day3.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 03);
                    workshipLineItem.Shift__c = items.day3;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day3;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 03);
                 
                lstWorkManagement.add(w);
            }
            if(items.day4 != null && items.day4 != '' && (!String.isBlank(items.day4))) {
                List<String> days = items.day4.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 04);
                    workshipLineItem.Shift__c = items.day4;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day4;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 04);
                 
                lstWorkManagement.add(w);
            }
            if(items.day5 != null && items.day5 != '' && (!String.isBlank(items.day5))) {
                List<String> days = items.day5.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 05);
                    workshipLineItem.Shift__c = items.day5;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day5;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 05);
                 
                lstWorkManagement.add(w);
            }
            if(items.day6 != null && items.day6 != '' && (!String.isBlank(items.day6))) {
                List<String> days = items.day6.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 06);
                    workshipLineItem.Shift__c = items.day6;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day6;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 06);
                 
                lstWorkManagement.add(w);
            }
            if(items.day7 != null && items.day7 != '' && (!String.isBlank(items.day7))) {
                List<String> days = items.day7.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 07);
                    workshipLineItem.Shift__c = items.day7;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day7;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 07);
                 
                lstWorkManagement.add(w);
            }
            if(items.day8 != null && items.day8 != '' && (!String.isBlank(items.day8))) {
                List<String> days = items.day8.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 08);
                    workshipLineItem.Shift__c = items.day8;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day8;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 08);
                 
                lstWorkManagement.add(w);
            }
            if(items.day9 != null && items.day9 != '' && (!String.isBlank(items.day9))) {
                List<String> days = items.day9.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 09);
                    workshipLineItem.Shift__c = items.day9;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day9;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 09);
                 
                lstWorkManagement.add(w);
            }
            if(items.day10 != null && items.day10 != '' && (!String.isBlank(items.day10))) {
                List<String> days = items.day10.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 10);
                    workshipLineItem.Shift__c = items.day10;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day10;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 10);
                 
                lstWorkManagement.add(w);
            }
            if(items.day11 != null && items.day11 != '' && (!String.isBlank(items.day11))) {
                List<String> days = items.day11.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 11);
                    workshipLineItem.Shift__c = items.day11;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day11;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 11);
                 
                lstWorkManagement.add(w); 
            }
            if(items.day12 != null && items.day12 != '' && (!String.isBlank(items.day12))) {
                List<String> days = items.day12.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 12);
                    workshipLineItem.Shift__c = items.day12;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day12;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 12);
                 
                lstWorkManagement.add(w);
            }
            if(items.day13 != null && items.day13 != '' && (!String.isBlank(items.day13))) {
                List<String> days = items.day13.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 13);
                    workshipLineItem.Shift__c = items.day13;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day13;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 13);
                 
                lstWorkManagement.add(w);
            }
            if(items.day14 != null && items.day14 != '' && (!String.isBlank(items.day14))) {
                List<String> days = items.day14.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 14);
                    workshipLineItem.Shift__c = items.day14;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day14;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 14);
                 
                lstWorkManagement.add(w);
            }
            if(items.day15 != null && items.day15 != '' && (!String.isBlank(items.day15))) {
                List<String> days = items.day15.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 15);
                    workshipLineItem.Shift__c = items.day15;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day15;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 15);
                 
                lstWorkManagement.add(w);
            }
            if(items.day16 != null && items.day16 != '' && (!String.isBlank(items.day16))) {
                List<String> days = items.day16.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 16);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day16;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day16;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 16);
                 
                lstWorkManagement.add(w);
            }
            if(items.day17 != null && items.day17 != '' && (!String.isBlank(items.day17))) {
                List<String> days = items.day17.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 17);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day17;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day17;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 17);
                 
                lstWorkManagement.add(w);
            }
            if(items.day18 != null && items.day18 != '' && (!String.isBlank(items.day18))) {
                List<String> days = items.day18.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 18);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day18;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day18;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 18);
                 
                lstWorkManagement.add(w);
            }
            if(items.day19 != null && items.day19 != '' && (!String.isBlank(items.day19))) {
                List<String> days = items.day19.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 19);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day19;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day19;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 19);
                 
                lstWorkManagement.add(w);
            }
            if(items.day20 != null && items.day20 != '' && (!String.isBlank(items.day20))) {
                List<String> days = items.day20.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 20);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day20;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day20;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 20);
                 
                lstWorkManagement.add(w);
            }
            if(items.day21 != null && items.day21 != '' && (!String.isBlank(items.day21))) {
                List<String> days = items.day21.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 21);
                   workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day21;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day21;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 21);
                  
                lstWorkManagement.add(w);
            }
            if(items.day22 != null && items.day22 != '' && (!String.isBlank(items.day22))) {
                List<String> days = items.day22.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 22);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day22;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day22;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 22);
                 
                lstWorkManagement.add(w);
            }
            if(items.day23 != null && items.day23 != '' && (!String.isBlank(items.day23))) {
                List<String> days = items.day23.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 23);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day23;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day23;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 23);
                 
                lstWorkManagement.add(w);
            }
            if(items.day24 != null && items.day24 != '' && (!String.isBlank(items.day24))) {
                List<String> days = items.day24.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 24);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day24;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day24;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 24);
                 
                lstWorkManagement.add(w);
            }
            if(items.day25 != null && items.day25 != '' && (!String.isBlank(items.day25))) {
                List<String> days = items.day25.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 25);
                    workshipLineItem.Unit__c = partner;
                    workshipLineItem.Shift__c = items.day25;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day25;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 25);
                 
                lstWorkManagement.add(w);
            }
            if(items.day26 != null && items.day26 != '' && (!String.isBlank(items.day26))) {
                List<String> days = items.day26.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 26);
                    workshipLineItem.Shift__c = items.day26;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day26;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 26);
                  
                lstWorkManagement.add(w);
            }
            if(items.day27 != null && items.day27 != '' && (!String.isBlank(items.day27))) {
                List<String> days = items.day27.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 27);
                    workshipLineItem.Shift__c = items.day27;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day27;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 27);
                 
                lstWorkManagement.add(w);
            }
            if(items.day28 != null && items.day28 != '' && (!String.isBlank(items.day28))) {
                List<String> days = items.day28.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 28);
                    workshipLineItem.Shift__c = items.day28;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day28;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 28);
                 
                lstWorkManagement.add(w);
            }
            if(items.day29 != null && items.day29 != '' && (!String.isBlank(items.day29))) {
                List<String> days = items.day29.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 29);
                    workshipLineItem.Shift__c = items.day29;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day29;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 29);
                 
                lstWorkManagement.add(w);
            }
            if(items.day30 != null && items.day30 != '' && (!String.isBlank(items.day30))) {
                List<String> days = items.day30.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 30);
                    workshipLineItem.Shift__c = items.day30;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day30;
                w.recordTypeId = idPlan;
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 30);
                 
                lstWorkManagement.add(w);
            }
            if(items.day31 != null && items.day31 != '' && (!String.isBlank(items.day31))) {
                List<String> days = items.day31.split('-');
                List<String> timeStart = days[0].split(':');
                List<String> timeEnd = days[1].split(':');
                Integer starts = integer.valueOf(timeStart[0]);
                integer ends = integer.valueOf(timeEnd[0]);
                for(integer i = starts ; i < ends ; i++) {
                    WorkShip_Line_Item__c workshipLineItem = new WorkShip_Line_Item__c();
                    workshipLineItem.Agent_Name__c = items.agentName;
                    workshipLineItem.Groups__c = lstAgent[0].Unit_by_region__c;
                    workshipLineItem.Time__c = String.valueOf(i);
                    workshipLineItem.Time_Number__c = i;
                    workshipLineItem.Agent_Code__c = items.DS;
                    workshipLineItem.Date__c = Date.newInstance(year, integer.valueOf(month), 31);
                    workshipLineItem.Shift__c = items.day31;
                    workshipLineItem.Unit__c = partner;
                    lstWorkshipLineItem.add(workshipLineItem);
                }
                Work_Management__c w = new Work_Management__c();
                w.Agent__c = mapOfAgentNameAndAgentId.get(items.DS);
                w.Shift__c = items.day31;
                w.recordTypeId = idPlan; 
                w.Working_Date__c = Date.newInstance(year, integer.valueOf(month), 31);
                 
                lstWorkManagement.add(w);
            }
        }
        insert lstWorkshipLineItem;
        return lstWorkManagement;
        
    }
    @AuraEnabled
    public static List<workShipResultWrapper> showDuplicateWorkship(List<Work_Management__c> lstWorkManagement) {
        //check duplicate ca trực (duplicate nếu agent có trên 2 ca làm trong cùng 1 ngày)
        
        system.debug(lstWorkManagement.size());
        Map<String, List<Work_Management__c>> mapOfAgentAndWorkShip = new Map<String, List<Work_Management__c>>();
        
        for(Work_Management__c items : lstWorkManagement) {
            if (mapOfAgentAndWorkShip.containsKey(items.Agent__c + '_' + items.Working_Date__c)) {
                List<Work_Management__c> existingList = mapOfAgentAndWorkShip.get(items.Agent__c + '_' + items.Working_Date__c);
                existingList.add(items);
                mapOfAgentAndWorkShip.put(items.Agent__c + '_' + items.Working_Date__c, existingList);
            } else {
                List<Work_Management__c> newList = new List<Work_Management__c>();
                newList.add(items);
                mapOfAgentAndWorkShip.put(items.Agent__c + '_' + items.Working_Date__c, newList);
            }
        }
        List<Work_Management__c> lstWDuplicate = new List<Work_Management__c>();
        List<workShipDuplicateWrapper> lstResultDuplicate = new List<workShipDuplicateWrapper>();
        List<workShipResultWrapper> lstResultDuplicatewrapper = new List<workShipResultWrapper>();
        Set<String> agentIds = new Set<String>();
        for(String keys : mapOfAgentAndWorkShip.keySet()) {
            List<String> lstAgentAndWorkingDate = keys.split('_');
            agentIds.add(lstAgentAndWorkingDate[0]);
            
            List<Work_Management__c> lstWorkManagerMent = mapOfAgentAndWorkShip.get(keys);
            if(lstWorkManagerMent.size() > 1) {
                lstWDuplicate.addAll(lstWorkManagerMent);
            }
        } 
        if(lstWDuplicate.size() > 0) { 
            Map<String,String> mapOfIdAndNameAgent = new Map<String,String>();
            List<Master_Data__c> lstAgentById = [SELECT Id, Name FROM Master_Data__c WHERE Id =: agentIds];
            for(Master_Data__c lst : lstAgentById ) {
                mapOfIdAndNameAgent.put(lst.Id, lst.Name);
            }
            for(Work_Management__c w : lstWDuplicate) {
                workShipDuplicateWrapper duplicateWorkShipResult = new workShipDuplicateWrapper();
                duplicateWorkShipResult.shift = w.Shift__c;
                duplicateWorkShipResult.AgentName = mapOfIdAndNameAgent.get(w.Agent__c);
                duplicateWorkShipResult.WorkingDate = w.Working_Date__c;
                lstResultDuplicate.add(duplicateWorkShipResult);
            }
            workShipResultWrapper workResultDuplicate = new workShipResultWrapper();
            workResultDuplicate.lstWorkShipDup = lstResultDuplicate;
            workResultDuplicate.isDuplicated = true;
            lstResultDuplicatewrapper.add(workResultDuplicate);
        }
        return lstResultDuplicatewrapper;         
    }
    
     @AuraEnabled
    public static List<workShipResultWrapper> showSlotByAgent(String month, String yearImport, String partner, List<Work_Management__c> lstWorkManagement) {
        Integer inMonth = Integer.valueOf(month);
        Integer year = Integer.valueOf(yearImport);
        List<workShipResultWrapper> lstWorkShipResultWrapper = new List<workShipResultWrapper>();

        
        List<AggregateResult> lstWorkShipLineItems = [SELECT Count(id) countId, Time__c, Date__c 
                                                      FROM WorkShip_Line_Item__c 
                                                      WHERE CALENDAR_MONTH(Date__c) =: inMonth 
                                                      AND CALENDAR_YEAR(Date__c) =: year 
                                                      GROUP BY Time__c , Date__c 
                                                      ORDER BY Date__c,Time__c DESC 
                                                     ];
                   
        Integer userMax = 0;
        User_by_company_region__mdt userByCompanyRegion = [SELECT MasterLabel, User_Number__c FROM User_by_company_region__mdt where MasterLabel =: partner];
        
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Master_Data__c').getDescribe().fields.getMap().get('Unit_by_region__c').getDescribe();
        User u = [SELECT Id , Name FROM User WHERE Id =: userInfo.getUserId()];
        

        if(lstWorkShipLineItems.size() > 0) {
            for(AggregateResult ar : lstWorkShipLineItems) {
                workShipResultWrapper wSRW = new workShipResultWrapper();
                wSRW.userUsing = string.ValueOf(ar.get('countId'));
                wSRW.userSystem = string.ValueOf(userByCompanyRegion.User_Number__c); 
                wSRW.hour = string.ValueOf(ar.get('Time__c')) + '-' + string.valueOf(integer.valueOf(ar.get('Time__c')) + 1);
                wSRW.day = string.ValueOf(ar.get('Date__c'));
                wSRW.userMissing = string.valueOf(integer.valueOf(userByCompanyRegion.User_Number__c) - integer.valueOf(wSRW.userUsing ));
                wSRW.lstWorkShip = lstWorkManagement;
                wSRW.isCreated = false;
                lstWorkShipResultWrapper.add(wSRW);
            }  
        }
        system.debug(lstWorkShipResultWrapper); 
         Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
         List<Work_Management__c> lstWorkManagementDelete = [SELECT Id, Working_Date__c, Agent__r.Unit_by_region__c
                                                            FROM Work_Management__c
                                                            WHERE CALENDAR_MONTH(Working_Date__c) =: inMonth 
                                                            AND CALENDAR_YEAR(Working_Date__c) =: year 
                                                            AND RecordTypeId =: idPlan
                                                            AND Agent__r.Unit_by_region__c =: partner
                                                           ];
        if(lstWorkManagementDelete.size() > 0) {      
            delete lstWorkManagementDelete;
        }
        
        return lstWorkShipResultWrapper; 
    }
    
    @AuraEnabled
    public static void deleteWorkShipLineItem(String month, String yearImport, String partner) {
        
        String Key = month + yearImport;
        List<WorkShip_Line_Item__c> lstWorkShipLineDelete = [SELECT Id, Unit__c 
                                                             From WorkShip_Line_Item__c
                                                             Where Key__c =: Key 
                                                             AND Unit__c =: partner Limit 9000];
       delete lstWorkShipLineDelete;
    }
    
    @AuraEnabled
    public static List<WorkShip_Line_Item__c> getLstWorkShiftLineDel(String month, String yearImport, String partner) {
        String Key = month + yearImport;
        List<WorkShip_Line_Item__c> lstWorkShipLineDelete = [SELECT Id, Unit__c From WorkShip_Line_Item__c Where Key__c =: Key AND Unit__c =: partner];
        system.debug(lstWorkShipLineDelete.size());
        return lstWorkShipLineDelete;
    }
    
    @AuraEnabled
    public static void createWorkship(List<Work_Management__c> lstWorkManagement , string partner) {
        
        system.debug(lstWorkManagement.size());
        Map<Date, List<Work_Management__c>> mapOfDateAndWorkShip = new Map<Date, List<Work_Management__c>>();
        Map<Date, List<Work_Management__c>> mapOfDateAndWorkShipCantUpdate = new Map<Date, List<Work_Management__c>>();
        
        Map<String, String> mapOfAgentIdAndUserId = new Map<String,String>();
        Set<Id> setUserId = new Set<Id>();
        Id idAgent = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        
        //query ra agent đã được gắn user cố định
        List<Master_Data__c> lstMasterData = [SELECT Id, User_uses__c, User_uses__r.Region__c , User_uses__r.Name
                                              FROM Master_Data__c 
                                              WHERE User_uses__c != null 
                                              AND RecordTypeId =: idAgent
                                             ];
        
        for(Master_Data__c item : lstMasterData) {
            mapOfAgentIdAndUserId.put(item.Id, item.User_uses__c);
            setUserId.add(item.User_uses__c);
        }
        
        //lấy ra list user đang không được gắn user cố định
        List<User> lstUser = [Select Id, Name From User Where Partner__c =: partner And Id != :setUserId];
        
        //xử lý map user với ca trực và agent tương ứng với agent được gắn với user cố định
        for(Work_Management__c items : lstWorkManagement) {
            if (mapOfDateAndWorkShip.containsKey(items.Working_Date__c)) {
                List<Work_Management__c> existingList = mapOfDateAndWorkShip.get(items.Working_Date__c);
                existingList.add(items);
                mapOfDateAndWorkShip.put(items.Working_Date__c, existingList);
            } else {
                List<Work_Management__c> newList = new List<Work_Management__c>();
                newList.add(items);
                mapOfDateAndWorkShip.put(items.Working_Date__c, newList);
            }
        }
        
        List<Work_Management__c> lstWorkManagerMentCantUpdate = new List<Work_Management__c>();
        
        Map<string, List<Work_Management__c>> mapOfIdUserAndWorkShip = new Map<string, List<Work_Management__c>>();
        Map<string, List<Work_Management__c>> mapOfIdUserAndWorkShipUpdate = new Map<string, List<Work_Management__c>>();
        
        for(Date key : mapOfDateAndWorkShip.KeySet()) {
            for(Work_Management__c w : mapOfDateAndWorkShip.get(key)) {
                if(mapOfAgentIdAndUserId.containsKey(w.Agent__c)) {
                    List<Work_Management__c> lstWM = new List<Work_Management__c>();
                    lstWM.add(w);
                    mapOfIdUserAndWorkShipUpdate.put(mapOfAgentIdAndUserId.get(w.Agent__c) + '-' + key, lstWM);
                } else { 
                    lstWorkManagerMentCantUpdate.add(w);
                }
            }  
        }
        
        
        //xử lý map user với ca trực và agent tương ứng với agent được gắn với user không cố định
        if(lstWorkManagerMentCantUpdate.size() > 0) {
            for(Work_Management__c items : lstWorkManagerMentCantUpdate) {
                if (mapOfDateAndWorkShipCantUpdate.containsKey(items.Working_Date__c)) {
                    List<Work_Management__c> existingList = mapOfDateAndWorkShipCantUpdate.get(items.Working_Date__c);
                    existingList.add(items);
                    mapOfDateAndWorkShipCantUpdate.put(items.Working_Date__c, existingList);
                } else {
                    List<Work_Management__c> newList = new List<Work_Management__c>();
                    newList.add(items);
                    mapOfDateAndWorkShipCantUpdate.put(items.Working_Date__c, newList);
                }
            } 
        }
       
            
        for(Date key : mapOfDateAndWorkShipCantUpdate.KeySet()) {
            for(User u : lstUser) {
                integer j = 0;
                for(Work_Management__c w : mapOfDateAndWorkShipCantUpdate.get(key)) {
                    List<String> days = w.Shift__c.split('-');
                    List<String> timeEnd = days[1].split(':');
                    List<String> timeStart = days[0].split(':');
                    integer ends = integer.valueOf(timeEnd[0]);
                    integer starts = integer.valueOf(timeStart[0]);
                    integer i = 0;
                    boolean check = false;
                    for(Work_Management__c w2 : mapOfDateAndWorkShipCantUpdate.get(key)) {
                        List<String> days2 = w2.Shift__c.split('-');
                        List<String> timeStarts = days2[0].split(':');
                        List<String> timeEnds = days2[1].split(':');
                        integer start = integer.valueOf(timeStarts[0]);
                        integer endss = integer.valueOf(timeEnds[0]);
                        if(ends <= start || starts >= endss) {
                            List<Work_Management__c> lstWM = new List<Work_Management__c>();
                            lstWM.add(w);
                            lstWM.add(w2);
                            mapOfIdUserAndWorkShip.put(u.Id + '-' + key, lstWM);
                            List<Work_Management__c> existingList = mapOfDateAndWorkShipCantUpdate.get(key);
                            existingList.remove(i);
                            mapOfDateAndWorkShipCantUpdate.put(key, existingList);
                            check = true;
                            break;
                        }
                        i++; 
                    }
                    if(check == true) {
                        List<Work_Management__c> existingList = mapOfDateAndWorkShipCantUpdate.get(key);
                        existingList.remove(j);
                        mapOfDateAndWorkShipCantUpdate.put(key, existingList);
                        break;
                        }
                        else {
                            List<Work_Management__c> lstWM = new List<Work_Management__c>();
                            lstWM.add(w);
                            mapOfIdUserAndWorkShip.put(u.Id + '-' + key, lstWM);
                            List<Work_Management__c> existingList = mapOfDateAndWorkShipCantUpdate.get(key);
                            existingList.remove(j);
                            mapOfDateAndWorkShipCantUpdate.put(key, existingList);
                            break;
                        }
                    j++;
                }
            }
        }
        
        //insert thông tin workshift theo user tương ứng
        List<Work_Management__c> lstWorkManagementUpdate = new List<Work_Management__c>();
        List<Work_Management__c> lstWorkManagementUpdate2 = new List<Work_Management__c>();
        
        for(String Key : mapOfIdUserAndWorkShip.keySet()) {
            List<Work_Management__c> lstWorkManagerment = mapOfIdUserAndWorkShip.get(key);
            List<String> lstStr = key.split('-');
            for(Work_Management__c w : lstWorkManagerment) {
                w.User_Using__c = lstStr[0];
                lstWorkManagementUpdate.add(w);
            }
        }
        
         for(String Key : mapOfIdUserAndWorkShipUpdate.keySet()) {
            List<Work_Management__c> lstWorkManagerment = mapOfIdUserAndWorkShipUpdate.get(key);
            List<String> lstStr = key.split('-');
            for(Work_Management__c w : lstWorkManagerment) {
                w.User_Using__c = lstStr[0];
                lstWorkManagementUpdate2.add(w);
            }
        }
        system.debug(lstWorkManagementUpdate.size());
        system.debug(lstWorkManagementUpdate2.size());
        insert lstWorkManagementUpdate;
        insert lstWorkManagementUpdate2;
    }
    
    public class workShipWrapper {
        public String stt {get;set;}
        public String agentName {get;set;}
        public String DS {get;set;}
        public String day1 {get;set;}
        public String day2 {get;set;}
        public String day3 {get;set;}
        public String day4 {get;set;}
        public String day5 {get;set;}
        public String day6 {get;set;}
        public String day7 {get;set;}
        public String day8 {get;set;}
        public String day9 {get;set;}
        public String day10 {get;set;}
        public String day11 {get;set;}
        public String day12 {get;set;}
        public String day13 {get;set;}
        public String day14 {get;set;}
        public String day15 {get;set;}
        public String day16 {get;set;}
        public String day17 {get;set;}
        public String day18 {get;set;}
        public String day19 {get;set;}
        public String day20 {get;set;}
        public String day21 {get;set;}
        public String day22 {get;set;}
        public String day23 {get;set;}
        public String day24 {get;set;}
        public String day25 {get;set;}
        public String day26 {get;set;}
        public String day27 {get;set;}
        public String day28 {get;set;}
        public String day29 {get;set;}
        public String day30 {get;set;}
        public String day31 {get;set;}   
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
        @AuraEnabled
        public List<workShipDuplicateWrapper> lstWorkShipDup {get;set;}
        @AuraEnabled
        public boolean isCreated {get;set;}
        @AuraEnabled
        public boolean isDuplicated {get;set;}
        @AuraEnabled
        public string groups {get;set;}
    }
    
    public class workShipDuplicateWrapper {
        @AuraEnabled
        public String shift {get;set;}
        @AuraEnabled
        public String AgentName {get;set;}
        @AuraEnabled
        public Date WorkingDate {get;set;}
        
    }
}