public class R1_UploadCampaignMemberController {
    @AuraEnabled
    public static result saveFile(String base64Data)
    {
        system.debug(base64Data);
        String data = JSON.deserializeUntyped(base64Data).toString();
        list<dataWrapper> lstCCToInsert = new list<dataWrapper>();
        list<CampaignMember> lstCampaignMember = new List<CampaignMember>();
        list<dataWrapper> lstDataError = new List<dataWrapper>();
        list<String> lstCSVLines = data.split('\n');
        String csv = 'CampaignId,Phone,Status,Error\n';
        
        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            dataWrapper campaignMemWrapper = new dataWrapper();
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            
            system.debug(csvLine);
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(','))
            {
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
            campaignMemWrapper.CampaignId = csvRowData[0];
            campaignMemWrapper.phone = csvRowData[1];
            campaignMemWrapper.status = csvRowData[2];
            lstCCToInsert.add(campaignMemWrapper);
        }
        Set<String> setPhone = new Set<String>();
        Map<String, String> mapOfPhoneAndIdContact = new Map<String, String>();
        if (lstCCToInsert.size() > 0) {
            system.debug('lớn hơn 0');
            for(dataWrapper dt : lstCCToInsert) {
                setPhone.add(dt.phone);
            } 
            
            List<Contact> lstContact = [SELECT Id, Name, Phone 
                                        FROM Contact 
                                        WHERE Phone =: setPhone 
                                        AND RecordType.DeveloperName = 'Customer'
                                        AND Status__c =: '1'];
            
            for(Contact lstCon : lstContact) {
                mapOfPhoneAndIdContact.put(lstCon.Phone, lstCon.Id); 
            }
            
            for(dataWrapper item : lstCCToInsert) {
                CampaignMember cpmb = new CampaignMember();
                if(mapOfPhoneAndIdContact.containskey(item.Phone)) {
                    cpmb.ContactId = mapOfPhoneAndIdContact.get(item.Phone);
                    cpmb.CampaignId = item.campaignId;
                    cpmb.Status = item.status;
                    lstCampaignMember.add(cpmb);
                } else { 
                    lstDataError.add(item);
                }
            } 
        }
        result res; 
        if(lstCampaignMember.size() > 0)  { 
            integer count = (lstCampaignMember.size() + lstDataError.size());
            
            try {
                insert lstCampaignMember;
                
                if(lstDataError.size() > 0) {
                    string mess = 'Không tồn tại contact trên hệ thống';
                    for (dataWrapper item : lstDataError) {
                        csv += item.campaignId + ',' + item.phone + ',' + item.status.escapeCsv() + ',' + mess.escapeCsv()  + '\n'; 
                    }
                    
                    User u = [SELECT Id, Name, Email FROM User WHERE Id =: userInfo.getUserId()];
                    
                    Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
                    Blob csvBlob = blob.valueOf(csv);
                    String csvName = 'CampaignMember_Errors.csv';
                    csvAttachment.setFileName(csvName); 
                    csvAttachment.setBody(csvBlob);
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{u.Email};
                        String subject = 'Kết quả import Campaign Member trên hệ thống OmniChannel';
                    String encodedSubject = '=?UTF-8?B?' + EncodingUtil.base64Encode(Blob.valueOf(subject)) + '?=';
                    email.setSubject(encodedSubject);
                    email.setToAddresses(toAddresses);
                     
                    string body = 'Xin chào ' + u.Name + ', Bạn vừa import Campaign Member lên hệ thống, vui lòng kiểm tra các bản ghi lỗi trên file đính kèm.';
                    email.setPlainTextBody(body);
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
                    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                
                    result r2 = new result();
                    r2.status = 'warnning';
                    r2.message = 'Đã import thành công ' + lstCampaignMember.size() + '/' + count + ' campaign member'; 
                    return r2; 
                }
                
                result r = new result();
                r.status = 'success';
                r.message = 'Import thành công';
                return r;
                
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
                result r = new result(); 
                r.status = 'error';
                r.message = e.getMessage();
                return r;
            }
        }    
        return res;
    }
    
    public class result{
        @AuraEnabled
        public string status {get;set;} 
        @AuraEnabled
        public string message {get;set;} 
    }
    public class dataWrapper {
        @AuraEnabled
        public string campaignId {get;set;}
        @AuraEnabled
        public string phone {get;set;}
        @AuraEnabled
        public string status {get;set;}
    }
}