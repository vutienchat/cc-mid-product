@isTest
global class GMS_MockHttpResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();

        if (endpoint.contains('omni_api_get_cur_debit_and_hot_bill')) {
            res.setBody('{"data":"Hotline Data","http_code":200,"text":"Success","error_code":0}');
        } else if (endpoint.contains('omni_check_sub_service')) {
            res.setBody('{"data":[{"STATUS":"1","SER_TYPE":"Type1","STA_DATE":"2024-01-01","END_DATE":"2024-12-31"}],"http_code":200,"text":"Success","error_code":0}');
        } else if (endpoint.contains('omni_check_sub_charge')) {
            res.setBody('{"data":[{"PCK_CODE":"Pack1","STADATE":"2024-01-01","ENDDATE":"2024-12-31"}],"http_code":200,"text":"Success","error_code":0}');
        } else if (endpoint.contains('omni_api_fb_request')) {
            res.setBody('{"data":[{"THONGTINHOPDONG":"Test","REFERENCE_ID":"123","HINHTHUCTIEPNHAN":"1","CALL_BACK_REQUIRE":"No","PROCESS_USER":"User1","NHOMYEUCAU":"Group1","LOAIYEUCAU":1,"HOTEN":"Test User","URGENT":"No","STATUS":"Open","ACCEPT_USER":"User2","THOIGIANTIEPNHAN":"2024-05-14","COMP_CONTENT":"Content","NGUONTIEPNHAN":"Source","ISDN":"1234567890","NOTE":"Note","COMPLAIN_ID":"456","LOAINGIEPVU":"Service","CHITIETPA":"Detail","PRE_RESULT":"Result","TEMPLATE":"Template","THONGTINKHACHHANG":"Customer Info"}],"http_code":200,"text":"Success","error_code":0}');
        } else if (endpoint.contains('omni_api_tracuu_check_qltttb')) {
            res.setBody('{"data":"TC:Value1;ND13:Value2;CSDLDCQG:Value3;Ngay_doi_soat:2024-06-28;ND49:Value4","http_code":200,"text":"Success","error_code":0}');
        } else if (endpoint.contains('omni_check_arpu')) {
            res.setBody('{"data":{"sub_id":"TestSubId","phone":"1234567890","arpu_3m":"30","arpu_6m":"60","current_month":"6"},"http_code":200,"text":"Success","error_code":0}');
        } else if (endpoint.contains('omni_list_bw_product')) {
            res.setBody('{"data": "BlackListWhiteList Data"}');
        }

        res.setStatusCode(200);
        return res;
    }
}