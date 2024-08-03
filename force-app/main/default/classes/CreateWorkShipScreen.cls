/**
* @description       : class xử lý tạo ca trực
* @author            : ntluan - GMS
* @last modified on  : 2024.06.19
* @last modified by  : Nguyen Thanh Luan(ntluan@gimasys.com)
* @history           :    date                    author                      content
**/
public class CreateWorkShipScreen {
    @InvocableMethod(label='Create Work Shift Screen')  
    public static void createListWorkShift(List<FlowInputs> request) {
        try{
            system.debug(request[0].idAgent);
            Id idPlan = Schema.SObjectType.Work_Management__c.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
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
                    Work_Management__c w = new Work_Management__c();
                    w.Agent__c = item;
                    w.Shift__c = request[0].fromTime + '-' + request[0].toTime;
                    w.Working_Date__c = fr;
                    w.RecordTypeId = idPlan;
                    lstWorkManagement.add(w);
                    lstWorkingDate.add(fr);
                }  
            }

            Map<String, String> mapOfAgentIdAndUserId = new Map<String,String>();
            List<Work_Management__c> lstInsertWS = new List<Work_Management__c>();
            Set<Id> setUserId = new Set<Id>();
            Id idAgent = Schema.SObjectType.Master_Data__c.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
            
            //user us = [Select Id, Region__c From User Where Id =: userInfo.getUserId()];
            
            
            List<Master_Data__c> agent = [SELECT Id, User_uses__c, User_uses__r.Region__c , User_uses__r.Name
                                          FROM Master_Data__c 
                                          WHERE Id =: request[0].idAgent[0] 
                                          AND RecordTypeId =: idAgent
                                          AND User_uses__c != Null 
                                         ];
            
            if(agent.size() > 0) {
                for(Work_Management__c item :lstWorkManagement ) {
                    item.User_Using__c = agent[0].User_uses__c;
                    lstInsertWS.add(item);
                }
                if(lstInsertWS.size() > 0) {
                    insert lstInsertWS;
                }
            } else {
                List<Master_Data__c> lstMasterData = [SELECT Id, User_uses__c, User_uses__r.Region__c , User_uses__r.Name
                                                      FROM Master_Data__c 
                                                      WHERE User_uses__c != null 
                                                      AND Unit_by_region__c =: request[0].partner
                                                      AND RecordTypeId =: idAgent
                                                     ];
                
                for(Master_Data__c item : lstMasterData) {
                    mapOfAgentIdAndUserId.put(item.Id, item.User_uses__c);
                    setUserId.add(item.User_uses__c);
                }
                
                
                List<User> lstUser = [Select Id, Name From User Where Partner__c =: request[0].partner And Id != :setUserId];
                
                
                List<Work_Management__c> lstWorkManagementMissingUser = new List<Work_Management__c>();
                List<Work_Management__c> lstWorkManagementInsert = new List<Work_Management__c>();
                List<Id> lstUserUsing = new List<Id>();
                Map<Date, List<Work_Management__c>> mapOfDateAndWorkShip = new Map<Date, List<Work_Management__c>>();
                Map<Date, List<Work_Management__c>> mapOfDateAndWorkShipMissing = new Map<Date, List<Work_Management__c>>();
                Map<String, List<Work_Management__c>> mapOfUserIdAndWorkShip = new Map<String, List<Work_Management__c>>();
                
                List<Work_Management__c> lstWorkManagments = [SELECT Id, Working_Date__c, Shift__c, Agent__c, User_Using__c FROM Work_Management__c WHERE Working_Date__c =:lstWorkingDate ];
                
                if(lstWorkManagments.size() > 0) {
                    for(Work_Management__c item : lstWorkManagments) {
                        lstUserUsing.add(item.User_Using__c);
                        if (mapOfUserIdAndWorkShip.containsKey(item.User_Using__c + '-' + item.Working_Date__c)) {
                            List<Work_Management__c> existingListUser = mapOfUserIdAndWorkShip.get(item.User_Using__c + '-' + item.Working_Date__c);
                            existingListUser.add(item);
                            mapOfUserIdAndWorkShip.put(item.User_Using__c + '-' + item.Working_Date__c, existingListUser);
                        } else {
                            List<Work_Management__c> newList = new List<Work_Management__c>();
                            newList.add(item);
                            mapOfUserIdAndWorkShip.put(item.User_Using__c + '-' + item.Working_Date__c, newList);
                        }
                        if (mapOfDateAndWorkShip.containsKey(item.Working_Date__c)) {
                            List<Work_Management__c> existingList = mapOfDateAndWorkShip.get(item.Working_Date__c);
                            existingList.add(item);
                            mapOfDateAndWorkShip.put(item.Working_Date__c, existingList);
                        } else {
                            List<Work_Management__c> newList = new List<Work_Management__c>();
                            newList.add(item);
                            mapOfDateAndWorkShip.put(item.Working_Date__c, newList);
                        }
                    }
                    
                    for(Work_Management__c item : lstWorkManagement) {
                        system.debug(item);
                        List<String> days = item.Shift__c.split('-');
                        List<String> timeStart = days[0].split(':');
                        List<String> timeEnd = days[1].split(':');
                        integer start = integer.valueOf(timeStart[0]);
                        integer ends = integer.valueOf(timeEnd[0]);
                        boolean check = false;
                        List<Work_Management__c> lstWM = mapOfDateAndWorkShip.get(item.Working_Date__c);
                        if(lstWM != null) {
                            for(Work_Management__c w : lstWM) {
                                system.debug(w);
                                List<String> daysW = w.Shift__c.split('-');
                                List<String> timeStartW = daysW[0].split(':');
                                List<String> timeEndW = daysW[1].split(':');
                                integer startW = integer.valueOf(timeStartW[0]);
                                integer endsW = integer.valueOf(timeEndW[0]);
                                if(start >= endsW || ends <= startW ) { 
                                    system.debug(mapOfUserIdAndWorkShip.get(w.User_Using__c + '-' + w.Working_Date__c).size());
                                    if(mapOfUserIdAndWorkShip.get(w.User_Using__c + '-' + w.Working_Date__c).size() < 2) {
                                        item.User_Using__c = w.User_Using__c;
                                        lstWorkManagementInsert.add(item);
                                        check = true;
                                        break;
                                    } 
                                }
                            }
                        }
                        if(check == false) {
                            lstWorkManagementMissingUser.add(item);
                        }
                    }
                }   
                else {
                    lstWorkManagementMissingUser.addAll(lstWorkManagement);
                }
                //List<User> lstUser = [Select Id, Name From User where Region__c =: us.Region__c And Id != :lstUserUsing];
                system.debug(lstWorkManagementMissingUser);
                
                if(lstWorkManagementMissingUser.size() > 0) {
                    for(Work_Management__c items : lstWorkManagementMissingUser) {
                        if (mapOfDateAndWorkShipMissing.containsKey(items.Working_Date__c)) {
                            List<Work_Management__c> existingList = mapOfDateAndWorkShipMissing.get(items.Working_Date__c);existingList.add(items); mapOfDateAndWorkShipMissing.put(items.Working_Date__c, existingList);
                        } else {
                            List<Work_Management__c> newList = new List<Work_Management__c>();
                            newList.add(items);
                            mapOfDateAndWorkShipMissing.put(items.Working_Date__c, newList);
                        }
                    }
                }
                Map<string, List<Work_Management__c>> mapOfIdUserAndWorkShipMissing = new Map<string, List<Work_Management__c>>();
                for(Date key : mapOfDateAndWorkShipMissing.KeySet()) {
                    system.debug(key);
                    for(User u : lstUser) {
                        integer j = 0;
                        for(Work_Management__c w : mapOfDateAndWorkShipMissing.get(key)) {
                            List<String> days = w.Shift__c.split('-');
                            List<String> timeEnd = days[1].split(':');
                            integer ends = integer.valueOf(timeEnd[0]);
                            integer i = 0;
                            boolean check = false;
                            for(Work_Management__c w2 : mapOfDateAndWorkShipMissing.get(key)) {
                                List<String> days2 = w2.Shift__c.split('-');
                                List<String> timeStart = days2[0].split(':');
                                integer start = integer.valueOf(timeStart[0]);
                                if(ends <= start) {
                                    List<Work_Management__c> lstWM = new List<Work_Management__c>();
                                    lstWM.add(w); lstWM.add(w2);mapOfIdUserAndWorkShipMissing.put(u.Id + '-' + key, lstWM);List<Work_Management__c> existingList = mapOfDateAndWorkShipMissing.get(key);
                                    existingList.remove(i);mapOfDateAndWorkShipMissing.put(key, existingList);check = true;
                                } 
                                i++; 
                            }
                            if(check == true) {
                                List<Work_Management__c> existingList = mapOfDateAndWorkShipMissing.get(key);
                                existingList.remove(j);
                                mapOfDateAndWorkShipMissing.put(key, existingList);
                            }
                            else {
                                List<Work_Management__c> lstWM = new List<Work_Management__c>();
                                lstWM.add(w);
                                mapOfIdUserAndWorkShipMissing.put(u.Id + '-' + key, lstWM);
                                List<Work_Management__c> existingList = mapOfDateAndWorkShipMissing.get(key);
                                existingList.remove(j);
                                mapOfDateAndWorkShipMissing.put(key, existingList);
                                break;
                            }
                            j++;
                        }
                    }
                }
                List<Work_Management__c> lstWorkManagementUpdate = new List<Work_Management__c>();
                for(String Key : mapOfIdUserAndWorkShipMissing.keySet()) {
                    List<Work_Management__c> lstWorkManagerment = mapOfIdUserAndWorkShipMissing.get(key);
                    List<String> lstStr = key.split('-');
                    for(Work_Management__c w : lstWorkManagerment) {
                        w.User_Using__c = lstStr[0];
                        lstWorkManagementInsert.add(w);
                    }
                }  
                insert lstWorkManagementInsert;
            }
        } catch (Exception ex) {        
            System.debug('R1_CallOutCase --> createTask:' + ex.getMessage() + '-' + ex.getStackTraceString());	    
             //return null;
        }
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
        public String partner;   
    }
}