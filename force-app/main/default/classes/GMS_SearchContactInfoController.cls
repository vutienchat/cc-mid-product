/*****Class Description*******************
* Name                  : GMS_SearchContactInfoController
* Date Created          : 14/05/2024
* Purpose               : Tìm kiếm thông tin contact thông qua API
* Author                : NTLUAN (GMS)
* Modification History  : NA
* Version   Author          DateModified    Description
* 1.0       NTLUAN (GMS)     14/05/2024      Tìm kiếm thông tin contact thông qua API
* *******************************************/
public without sharing class GMS_SearchContactInfoController {
    
    public class dataWrapper {
        @AuraEnabled
        public Contact contacts {get;set;}
        @AuraEnabled
        public Master_Data__c unit {get;set;}
    }
    
    @AuraEnabled
    public static List<PicklistValue> getGlobalPicklistValues() {
        List<PicklistValue> picklistValues = new List<PicklistValue>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('Feedback_Status__c').getDescribe();
        
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            PicklistValue p = new PicklistValue();
            p.label = entry.getLabel();
            p.value = entry.getValue(); 
            picklistValues.add(p);  
        }
        system.debug(picklistValues);  
        return picklistValues; 
    }
    @AuraEnabled
    public static dataWrapper getContactInformation(String contactId) {
        dataWrapper dt = new dataWrapper();
        List<Master_Data__c> lstMasterDataDisplay = new List<Master_Data__c>();
        Contact ct = [SELECT Id, Name, Phone FROM Contact WHERE Id =: contactId];
        dt.contacts = ct;
        
        User u = [SELECT Id, Name, Id_Agent_Using__c 
                  FROM User 
                  WHERE Id =: userInfo.getUserId()];
        
        List<Master_Data__c> lstMasterData = [SELECT Id, Name , Unit__c
                                              FROM Master_Data__c 
                                              WHERE Id =: u.Id_Agent_Using__c];
        if(lstMasterData.size() > 0)  {
            lstMasterDataDisplay = [SELECT Id, Name 
                                    FROM Master_Data__c 
                                    WHERE Id =: lstMasterData[0].Unit__c];
        }
       
        
        if(lstMasterDataDisplay.size() > 0) { 
            dt.unit = lstMasterDataDisplay[0];
        }
        return dt; 
    }
    
    
    @AuraEnabled
    public static Master_Data__c searchUnitByAgent(String searchKeyWord, String ObjectName) {
        Master_Data__c mt = new Master_Data__c();
        List<Master_Data__c> lstMasterDataDisplay = new List<Master_Data__c>();
        
        User u = [SELECT Id, Name, Id_Agent_Using__c 
                  FROM User 
                  WHERE Id =: userInfo.getUserId()];
        
        
        List<Master_Data__c> lstMasterData = [SELECT Id, Name , Unit__c
                                              FROM Master_Data__c 
                                              WHERE Id =: u.Id_Agent_Using__c];
        if(lstMasterData.size() > 0)  {
            lstMasterDataDisplay = [SELECT Id, Name, Accept_Source_Id__c  
                                    FROM Master_Data__c 
                                    WHERE Id =: lstMasterData[0].Unit__c];
        }
        
        
        if(lstMasterDataDisplay.size() > 0) { 
             mt = lstMasterDataDisplay[0];
        } else {
            mt.name = 'không tồn tại';
        }
        system.debug(mt);
        return mt; 
    }
    
    @AuraEnabled
    public static List<Master_Data__c> fetchLookUpValues(String searchKeyWord, String ObjectName, String recordTypeName) {
        String searchKey = searchKeyWord + '%';
        List<Master_Data__c> returnList = new List<Master_Data__c>();
        List<Master_Data__c> lstOfRecords = [SELECT id, name, Accept_Source_Id__c 
                                             FROM Master_Data__c 
                                             WHERE Name LIKE: String.escapeSingleQuotes(searchKey) 
                                             AND RecordType.Name =: recordTypeName 
                                             ORDER BY createdDate 
                                             DESC limit 5];
        system.debug(lstOfRecords);
        for (Master_Data__c obj: lstOfRecords) {
            returnList.add(obj);
        }  
        return returnList;
    }
    
    @AuraEnabled
    public static List<DataReflectingComplaints> searchReflectingComplaints(String phone, Date fromDate, Date toDate, Master_Data__c unit, String status) {
       
        String fromdateFormat = fromDate.day() + '/' + fromDate.month() + '/'  + fromDate.year();
        String toDateFormat = toDate.day() + '/' + toDate.month() + '/'  + toDate.year();
        system.debug(unit.Accept_Source_Id__c);
           
        if(status == null) {
            status = '';  
        }
        List<DataReflectingComplaints> lstData = new List<DataReflectingComplaints>();
        
        String requestBody = JSON.serialize(new Map<String, Object>{
            'isdn' => phone,
                'start_date' => fromdateFormat,
                'end_date' => toDateFormat, 
                'status' => status,
                'dep_id' => unit.Accept_Source_Id__c
                });
         
        String returnData = R1_HandleSearchContactInfomation.CheckFeebackRequest(requestBody);
        
        ResponseReflectingComplaints res = (ResponseReflectingComplaints) System.JSON.deserialize(returnData, ResponseReflectingComplaints.class);

        
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('Request_Form__c').getDescribe();
       
        for(DataReflectingComplaints item : res.data) {
            DataReflectingComplaints data = new DataReflectingComplaints(); 
            for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
                if(entry.getValue() == item.HINHTHUCTIEPNHAN) {
                   data.HINHTHUCTIEPNHAN = entry.getLabel();
                } else {
                    data.HINHTHUCTIEPNHAN = item.HINHTHUCTIEPNHAN;
                }
            }
            data.THONGTINHOPDONG = item.THONGTINHOPDONG;
            data.REFERENCE_ID = item.REFERENCE_ID;
            data.CALL_BACK_REQUIRE = item.CALL_BACK_REQUIRE;
            data.PROCESS_USER = item.PROCESS_USER;
            data.NHOMYEUCAU = item.NHOMYEUCAU;
            data.LOAIYEUCAU  = item.LOAIYEUCAU;
            data.HOTEN  = item.HOTEN;
            data.URGENT  = item.URGENT;
            data.STATUS  = item.STATUS;
            data.ACCEPT_USER  = item.ACCEPT_USER;          
            data.THOIGIANTIEPNHAN  = item.THOIGIANTIEPNHAN;
            data.COMP_CONTENT  = item.COMP_CONTENT;
            data.NGUONTIEPNHAN  = item.NGUONTIEPNHAN;
            data.ISDN  = item.ISDN;
            data.NOTE  = item.NOTE;
            data.COMPLAIN_ID  = item.COMPLAIN_ID;
            data.LOAINGIEPVU  = item.LOAINGIEPVU;
            data.CHITIETPA  = item.CHITIETPA;
            data.PRE_RESULT  = item.PRE_RESULT; 
            data.TEMPLATE  = item.TEMPLATE;
            data.THONGTINKHACHHANG  = item.THONGTINKHACHHANG;
            lstData.add(data);
        }  
        system.debug(lstData);
        return lstData;  
        
    } 
    
     @AuraEnabled
    public static List<DataHistory> searchHistory(String contactId) {
        Contact ct = [SELECT Id, Name, Sub_Id__c FROM Contact WHERE Id =: contactId];
        List<DataHistory> lstDataHistory = new List<DataHistory>();
        String requestBody = JSON.serialize(new Map<String, Object>{
            'sub_id' => ct.Sub_Id__c,
                'type' => 'G'
                }); 
        
        String returnData = R1_HandleSearchContactInfomation.CheckSubService(requestBody);
        ResponseHistory res = (ResponseHistory) System.JSON.deserialize(returnData, ResponseHistory.class);
        
        
        if(res.data.size() > 0) {
            for(DataHistory item : res.data) {
                DataHistory dt = new DataHistory();
                dt.SUB_ID = ct.Name;
                dt.SER_TYPE = item.SER_TYPE; 
                dt.STA_DATE = item.STA_DATE;
                dt.END_DATE = item.END_DATE;
                if(integer.valueOf(item.STATUS) > 0) {
                    dt.STATUS = 'Dịch vụ đang hiệu lực';
                } else {
                    dt.STATUS = 'Dịch vụ hết hiệu lực';
                }
                lstDataHistory.add(dt);
            }  
        }
        return lstDataHistory; 
    } 
	
    @AuraEnabled
    public static List<DataARPU> searchDataARPU(String contactId) {
        List<DataARPU> result = new List<DataARPU>();
        
        Date currentDate = Date.today();
        Integer currentMonth = currentDate.month();
        
        Contact ct = [SELECT Id, Name, Sub_Id__c, Phone FROM Contact WHERE Id =: contactId];
        
        String requestBody = JSON.serialize(new Map<String, Object>{
            'isdn' => ct.phone
                }); 
         
        String returnData = R1_HandleSearchContactInfomation.searchDataARPU(requestBody);
        system.debug(returnData);
        ResponseARPU res = (ResponseARPU) System.JSON.deserialize(returnData, ResponseARPU.class);
        if(res != null) {
            res.data.current_month = string.valueOf(currentMonth);
            result.add(res.data); 
        }
        return result;
        
        /*
        Contact ct = [SELECT Id, Name, Sub_Id__c FROM Contact WHERE Id =: contactId];
        List<ARPU__c> lstDataARPU = [SELECT id, Sub_ID__c, ARPU_3__c, ARPU_6__c, Current_Month__c, Phone__c FROM ARPU__c WHERE Sub_ID__c =: ct.Sub_Id__c];
        
        if(lstDataARPU.size() > 0) {
            for(ARPU__c item : lstDataARPU) {
                DataARPU dt = new DataARPU();
                dt.SUB_ID = item.Sub_ID__c;
                dt.PHONE = item.Phone__c; 
                dt.ARPU_3 = item.ARPU_3__c;
                dt.ARPU_6 = item.ARPU_6__c;
                dt.CURRENT_MONTH = item.Current_Month__c;
                result.add(dt);
            }  
        }
        return result; 
*/
    } 
    
    @AuraEnabled
    public static List<DataServicePackage> searchServicePackage(String contactId) {
        
        Contact ct = [SELECT Id, Name, Sub_Id__c FROM Contact WHERE Id =: contactId];
        List<DataServicePackage> lstData = new List<DataServicePackage>();
        String requestBody = JSON.serialize(new Map<String, Object>{
            'sub_id' => ct.Sub_Id__c,
                'type' => 'G'
                }); 
        
        String returnData = R1_HandleSearchContactInfomation.CheckSubCharge(requestBody);
        ResponseServicePackage res = (ResponseServicePackage) System.JSON.deserialize(returnData, ResponseServicePackage.class);
        if(res.data.size() > 0) {
            for(DataServicePackage item : res.data) {
                DataServicePackage dt = new DataServicePackage();
                dt.PCK_CODE = item.PCK_CODE;
                dt.STADATE = item.STADATE;
                dt.ENDDATE = item.ENDDATE;
                dt.SUB_ID = ct.Name;
                lstData.add(dt);
            }
        }
        return lstData;  
        
    } 

    @AuraEnabled
    public static ResponseCSDLQG searchCSDLQG(String contactId) {
        Contact ct = [SELECT Id, Name, Phone FROM Contact WHERE Id =: contactId];
        String requestBody = JSON.serialize(new Map<String, Object>{
            'isdn' => ct.Phone
              });
        
        String returnData = R1_HandleSearchContactInfomation.CheckInformationContact(requestBody);
        ResponseHotLine res = (ResponseHotLine) System.JSON.deserialize(returnData, ResponseHotLine.class);

        List<String> lstString = res.data.split(';');
        ResponseCSDLQG data = new ResponseCSDLQG();
        
        system.debug(res.data);
        system.debug(lstString); 
        
        if(lstString.size() > 0 && res.data != '') {
            data.TC = lstString[0].split(':')[1]; 
            data.ND13 = lstString[1].split(':')[1];
            data.CSDLDCQG = lstString[2].split(':')[1];
            data.Ngay_doi_soat = lstString[3].split(':')[1];
            data.ND49 = lstString[4].split(':')[1];
        }
        
        data.Thuebao = ct.Name;
        return data;  
        
    } 
    
    @AuraEnabled
    public static boolean checkProfileOfCurrentUser() {
        boolean checkProfile;
        Id profileId = userinfo.getProfileId();
        system.debug(profileId);
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        system.debug(profileName);
        if(profileName == 'HDQ'.trim() || profileName == 'Region' || profileName == 'Salesman') {
            checkProfile = true;
        } else {
            checkProfile = false;
        }
        return checkProfile;
    } 
    
     
    @AuraEnabled
    public static ResponseHotLine searchHotLine(String contactId) {
        Contact ct = [SELECT Id, Name, Phone FROM Contact WHERE Id =: contactId];
        Date todayDate = date.today();
        String fromdateFormat = todayDate.day() + '/' + todayDate.month() + '/'  + todayDate.year();
        String requestBody = JSON.serialize(new Map<String, Object>{
            'isdn' => ct.Phone,
            'datetime'=> fromdateFormat});
        String returnData = R1_HandleSearchContactInfomation.CheckCurDebitAndHotBill(requestBody);
        ResponseHotLine res = (ResponseHotLine) System.JSON.deserialize(returnData, ResponseHotLine.class);
        ResponseHotLine responseData = new ResponseHotLine();
        responseData.data = res.data;
        responseData.thuebao = ct.Name;
        responseData.thoigian = string.valueOf(todayDate);
        system.debug(res);
        return responseData; 
    } 
    
    @AuraEnabled
    public static dataContactInfomation searchPersonalContact(String contactId) {
        
        List<dataContactInfomation> lstData = new List<dataContactInfomation>();
        Contact ct = [SELECT Id, Name, Phone, Sub_Id__c, Mc_Sub__c, Account.Acc_Key__c, Account.Bus_Permit_No__c 
                      FROM Contact 
                      WHERE Id =: contactId];
        
        String requestBody = JSON.serialize(new Map<String, Object>{
            'sub_id' => ct.Sub_Id__c,
                'acc_key' => ct.Account.Acc_Key__c,
                'bus_permit_no' => ct.Account.Bus_Permit_No__c , 
                'mc_sub' => ct.Mc_Sub__c
                });
        
        /*
         String requestBody = JSON.serialize(new Map<String, Object>{
            'sub_id' => '10004204',
                'acc_key' => '0309226997',
                'bus_permit_no' => '5700379618',  
                'mc_sub' => '1'
                });
        */
        
        String returnData = R1_HandleSearchContactInfomation.checkPersonalContact(requestBody);
        system.debug(returnData);
        responseContactInfomation res = (responseContactInfomation) System.JSON.deserialize(returnData, responseContactInfomation.class);
        return res.data;
    } 
    
    @AuraEnabled
    public static dataBlock searchBlock(String contactId) {
        Contact ct = [SELECT Id, Name, Phone FROM Contact WHERE Id =: contactId];
     
        String requestBody = JSON.serialize(new Map<String, Object>{
            'isdn' => ct.Phone
                });
        String returnData = R1_HandleSearchContactInfomation.checkBlock(requestBody);
        wrapperClassBlock res = (wrapperClassBlock) System.JSON.deserialize(returnData, wrapperClassBlock.class);
        return res.data;
    } 
    
    @AuraEnabled
    public static dataBlock searchBlockCustom(String phone) {
          
        system.debug(phone);
        String requestBody = JSON.serialize(new Map<String, Object>{
            'isdn' => phone
                });
        
        String returnData = R1_HandleSearchContactInfomation.checkBlock(requestBody);
        wrapperClassBlock res = (wrapperClassBlock) System.JSON.deserialize(returnData, wrapperClassBlock.class);
        return res.data;
    } 

    public class PicklistValue {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
    }
    //tra cứu lịch sử chuyển đổi dịch vụ
    public class ResponseHistory {
         @AuraEnabled
        public List<DataHistory> data;
         @AuraEnabled
        public Integer http_code;
         @AuraEnabled
        public String text;
         @AuraEnabled
        public Integer error_code;
        
    }
    public class DataHistory {
         @AuraEnabled
        public String STATUS;
         @AuraEnabled
        public String SUB_ID;
         @AuraEnabled
        public String SER_TYPE;
         @AuraEnabled
        public String END_DATE;
         @AuraEnabled
        public String STA_DATE;
    }
    /*
    public class DataARPU {
         @AuraEnabled
        public String SUB_ID;
         @AuraEnabled
        public String PHONE;
         @AuraEnabled
        public Decimal ARPU_3;
         @AuraEnabled
        public Decimal ARPU_6;
         @AuraEnabled
        public Decimal CURRENT_MONTH;
    }
    */
    //tra cứu gói cước đang sử dụng
    public class ResponseServicePackage {
         @AuraEnabled
        public List<DataServicePackage> data;
         @AuraEnabled
        public Integer http_code;
         @AuraEnabled
        public String text;
         @AuraEnabled
        public Integer error_code;
        
    }
    public class DataServicePackage {
         @AuraEnabled
        public String PCK_CODE;
         @AuraEnabled
        public String SUB_ID;
         @AuraEnabled
        public String STADATE;
         @AuraEnabled
        public String ENDDATE;
    }
    
    //tra cứu phản ánh khiếu nại
    public class ResponseReflectingComplaints {
        @AuraEnabled
        public List<DataReflectingComplaints> data;
        @AuraEnabled
        public Integer http_code;
        @AuraEnabled
        public String text;
        @AuraEnabled
        public Integer error_code;
    }
    public class DataReflectingComplaints {
         @AuraEnabled
        public String THONGTINHOPDONG;
         @AuraEnabled
        public String REFERENCE_ID;
         @AuraEnabled
        public String HINHTHUCTIEPNHAN;
         @AuraEnabled
        public String CALL_BACK_REQUIRE;
         @AuraEnabled
        public String PROCESS_USER;
         @AuraEnabled
        public String NHOMYEUCAU;
         @AuraEnabled
        public Integer LOAIYEUCAU;
         @AuraEnabled
        public String HOTEN;
         @AuraEnabled
        public String URGENT;
         @AuraEnabled
        public String STATUS;
         @AuraEnabled
        public String ACCEPT_USER;
         @AuraEnabled
        public String THOIGIANTIEPNHAN;
         @AuraEnabled
        public String COMP_CONTENT;
         @AuraEnabled
        public String NGUONTIEPNHAN;
         @AuraEnabled
        public String ISDN;
         @AuraEnabled
        public String NOTE;
         @AuraEnabled
        public String COMPLAIN_ID;
         @AuraEnabled
        public String LOAINGIEPVU;
         @AuraEnabled
        public String CHITIETPA;
         @AuraEnabled
        public String PRE_RESULT;
         @AuraEnabled
        public String TEMPLATE;
         @AuraEnabled
        public String THONGTINKHACHHANG;
    }
    
    //tra cứu cước nóng
    public class ResponseHotLine {
        @AuraEnabled
        public String data;
        @AuraEnabled
        public String thuebao;
        @AuraEnabled
        public String thoigian;
        @AuraEnabled
        public Integer http_code;
        @AuraEnabled
        public String text;
        @AuraEnabled
        public Integer error_code;
    }
    
    public class ResponseCSDLQG {
        @AuraEnabled
        public String TC; 
        @AuraEnabled
        public String ND13;
        @AuraEnabled
        public String CSDLDCQG;
        @AuraEnabled
        public String Ngay_doi_soat;
        @AuraEnabled
        public String ND49;
        @AuraEnabled
        public String Thuebao;
    }
     //tra cứu dữ liệu ARPU
    public class ResponseARPU {
         @AuraEnabled
        public DataARPU data;
         @AuraEnabled
        public Integer http_code;
         @AuraEnabled
        public String text;
         @AuraEnabled
        public Integer error_code;
    }
    
    public class DataARPU {
         @AuraEnabled
        public String sub_id;
         @AuraEnabled
        public String phone;
         @AuraEnabled
        public String arpu_3m;
         @AuraEnabled
        public String arpu_6m;
        @AuraEnabled
        public String current_month;
    }
    
    public class responseContactInfomation {
        @AuraEnabled
        public dataContactInfomation data { get; set; }
        @AuraEnabled
        public String http_code { get; set; }
        @AuraEnabled
        public String text { get; set; }
        @AuraEnabled
        public String error_code { get; set; } 
        
    }

  public class dataContactInfomation {
      @AuraEnabled
      public String do_tin_cay_thue_bao { get; set; }
      @AuraEnabled
      public String cam_ket { get; set; }
      @AuraEnabled
      public String thong_tin_xac_minh { get; set; }
      @AuraEnabled
      public String tinh_trang_ho_so { get; set; }
      @AuraEnabled
      public List<String> khdntq { get; set; }
      @AuraEnabled
      public String email { get; set; }
      @AuraEnabled
      public String ngay_cap_cccd { get; set; }
      @AuraEnabled
      public String noi_cap_cccd { get; set; }
      @AuraEnabled
      public String ho_khau { get; set; }
      @AuraEnabled
      public String noi_dk_ho_khau { get; set; }
      @AuraEnabled
      public String ngay_dk_ho_khau { get; set; }
    }
    
    public class wrapperClassBlock {
        @AuraEnabled
        public dataBlock data { get; set; }
        @AuraEnabled
        public String http_code { get; set; }
        @AuraEnabled
        public String text { get; set; }
        @AuraEnabled
        public String error_code { get; set; }
    }
    public class dataBlock {
        @AuraEnabled
        public String so_thue_bao { get; set; }
        @AuraEnabled
        public String loai_thue_bao { get; set; }
        @AuraEnabled
        public String trang_thai_chan_cat { get; set; }
        @AuraEnabled
        public String ngay_het_han { get; set; }
    }
}