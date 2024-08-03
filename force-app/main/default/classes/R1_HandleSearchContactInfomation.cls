/**
* @description       : The Controller for Call Api Gateway
* @author            : DTDuong - GMS
* @create time       : 2024.05.28
* @last modified on  : 2024.06.01
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
**/
public class R1_HandleSearchContactInfomation {
    
    // API Tra cứu cước nóng, cước tạm tính, cước chưa thanh toán (TB trả sau)
    public static String CheckCurDebitAndHotBill(String requestBody){
        system.debug(requestBody);
        String responseData = ''; 
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('check-cur-debit-and-hot-bill','sf-api/v1/omni_api_get_cur_debit_and_hot_bill','POST',requestBody,'');
                system.debug(result);
                responseData = result.getBody().toString();
                
            }     
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> CheckCurDebitAndHotBill() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
        
    } 
	
    // API Lịch sử chuyển đổi, đăng ký, hủy dịch vụ 
    public static String CheckSubService(String requestBody){
        String responseData = '';
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('check-sub-service','sf-api/v1/omni_check_sub_service','POST',requestBody,'');
                responseData = result.getBody().toString();
                
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> CheckSubService() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
    }
    
    // API Tra cứu gói cước đang sử dụng
    public static String CheckSubCharge(String requestBody){
        String responseData = '';
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('check-sub-charge','sf-api/v1/omni_check_sub_charge','POST',requestBody,'');
                responseData = result.getBody().toString();
                
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> CheckSubCharge() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
    }
    
    // API Tra cứu thông tin phản ánh
    public static String CheckFeebackRequest(String requestBody){
        String responseData = ''; 
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('check-feedback-request','sf-api/v1/omni_api_fb_request','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> CheckFeebackRequest() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
        
    }
	
    // API Tra cứu thông tin thuê bao 
    public static String CheckInformationContact(String requestBody){
        String responseData = '';
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('check-information-contact','sf-api/v1/omni_api_tracuu_check_qltttb','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> CheckInformationContact() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
        
    }
    
    // API Tra cứu thông tin ARPU
    public static String searchDataARPU(String requestBody){
        String responseData = '';
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('search-information-ARPU','sf-api/v1/omni_check_arpu','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> CheckInformationContact() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData; 
    }
    
    public static String searchBlackListWhiteList(String requestBody){
        String responseData = '';
        try {
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('search-BL-WL','sf-api/v1/omni_list_bw_product','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> searchBlackListWhiteList() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
    }
    
    public static String searchSubscriptionPackage(String requestBody){
        String responseData = '';
        try { 
            if(requestBody != null){
                HttpResponse result = GMS_CallApiGateway.callApi('send-sms','sf-api/v1/msocial/dang_ky_goi_cuoc','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> searchSubscriptionPackage() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
    }
    
    public static String checkPersonalContact(String requestBody){
        String responseData = '';
        try { 
            if(requestBody != null){
                
                HttpResponse result = GMS_CallApiGateway.callApi('check-persional-contact','sf-api/v1/omni/omni_check_personal','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> searchSubscriptionPackage() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
    }
    
    public static String checkBlock(String requestBody){
        String responseData = '';
        try { 
            if(requestBody != null){
                
                HttpResponse result = GMS_CallApiGateway.callApi('check-block','sf-api/v1/omni/omni_check_block','POST',requestBody,'');
                responseData = result.getBody().toString();
            }    
        } catch (System.CalloutException e) {
            System.debug('[R1_HandleSearchContactInfomation] -> searchSubscriptionPackage() -> exception: ' + e.getMessage() + ' Inline : ' + e.getLineNumber());
        }
        return responseData;
    }
}