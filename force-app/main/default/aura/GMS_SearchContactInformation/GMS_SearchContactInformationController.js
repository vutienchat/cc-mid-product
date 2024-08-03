({
    doInit : function(component, event, helper) {
        var action = component.get("c.getGlobalPicklistValues"); 

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();     
                component.set("v.valueStatus" , result);
                
            } else if(state === "INCOMPLETE"){   
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.Spinner", false); 
            }
        });        
        $A.enqueueAction(action);
        var getId = component.get("v.recordId");
        var action2 = component.get("c.getContactInformation");  
        action2.setParams({ 
            'contactId' : getId,
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();     
                component.set("v.contactPhone" , result.Phone);
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action2);
        var action3 = component.get("c.checkProfileOfCurrentUser"); 
        action3.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();   
                if(result == true) {
                    component.set("v.checkProfile" , false);
                }
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action3);
    },
    onChangeOption : function(component, event, helper) {
        var value = component.find('select').get('v.value');
        component.set("v.status", value);
    },
    
    openModelChanCat : function(component, event, helper) { 
        var getId = component.get("v.recordId");
        
        var action2 = component.get("c.getContactInformation");  
        action2.setParams({ 
            'contactId' : getId,
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();     
                        component.set("v.contactPhone" , result.contacts.Phone);
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action2);

        component.set("v.spinner", true); 
        var action = component.get("c.searchBlock");  
        action.setParams({ 
            'contactId' : getId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){ 
                var result = response.getReturnValue();
                component.set("v.dataChanCat", result);
                component.set("v.spinner", false); 
                component.set("v.openModelChanCat", true);
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false); 
                component.set("v.openModelChanCat",true);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
                component.set("v.openModelChanCat",true);
            }
        });        
        $A.enqueueAction(action);
    },

    handleSearchChanCat : function(component, event, helper) {
        component.set("v.spinner3", true); 
        
        var phoneInput = component.get("v.contactPhone");
        var action = component.get("c.searchBlockCustom");  
        action.setParams({ 
            'phone' : phoneInput,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){ 
                var result = response.getReturnValue();
                component.set("v.dataChanCat", result);
                component.set("v.spinner3", false); 
                component.set("v.openModelChanCat", true);
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner3", false); 
                component.set("v.openModelChanCat",true);
            }else if(state === "ERROR"){    
                component.set("v.spinner3", false);
                component.set("v.openModelChanCat",true);
            }
        });        
        $A.enqueueAction(action);
        
    },
    
    
    openModel : function(component, event, helper) {
        var getId = component.get("v.recordId");
        component.set("v.spinner", true); 
        var action = component.get("c.searchPersonalContact");  
        action.setParams({ 
            'contactId' : getId,
        });
         action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){ 
                 var result = response.getReturnValue();
                component.set("v.dataContactInformation", result);
                component.set("v.spinner", false); 
                component.set("v.isModelBoxOpen", true);
            } else if(state === "INCOMPLETE"){   
                    component.set("v.spinner", false); 
                component.set("v.isModelBoxOpen",true);
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
                component.set("v.spinner", false);
                component.set("v.isModelBoxOpen",true);
            }
        });        
        $A.enqueueAction(action);
    },
    
    openModelHistory : function(component, event, helper) {
        var getId = component.get("v.recordId");
        component.set("v.spinner", true); 
        var action = component.get("c.searchHistory");  
        action.setParams({ 
            'contactId' : getId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){ 
                 var result = response.getReturnValue();
                console.log(result);
                component.set("v.dataHistory", result);
                component.set("v.isModelBoxOpenHistory", true);
                component.set('v.columns1', [
                    {label: 'Thuê bao', fieldName: 'SUB_ID', type: 'text'},
                    {label: 'Trạng thái dịch vụ', fieldName: 'STATUS', type: 'text'},
                    {label: 'Loại dịch vụ', fieldName: 'SER_TYPE', type: 'text'},
                    {label: 'Ngày dịch vụ hết hiệu lực', fieldName: 'END_DATE', type: 'text'},
                    {label: 'Ngày bắt đầu dịch vụ', fieldName: 'STA_DATE', type: 'text'},            
                ]);
                component.set("v.spinner", false); 
            } else if(state === "INCOMPLETE"){   
                    component.set("v.spinner", false); 
                    component.set("v.isModelBoxOpenHistory", true);
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                    component.set("v.spinner", false);
                    component.set("v.spinner", false);
                    component.set("v.isModelBoxOpenHistory", true);
            }
        });        
        $A.enqueueAction(action);
                    },
                    closeModal : function(component, event, helper) {
                    component.set("v.isModelBoxOpen", false);
                    component.set("v.isModelBoxOpenHistory", false);
                    component.set("v.isModelBoxOpenHotLine", false);
                    component.set("v.isModelBoxOpenARPU", false);
                    component.set("v.openModelServicePackage", false);
                    component.set("v.openModelCSDLQG", false);
                    component.set("v.openModelReflectingComplaints", false);
                    component.set("v.openModelChanCat", false);
                    },
                    
    openModelARPU : function(component, event, helper) { 
        var getId = component.get("v.recordId");
        component.set("v.spinner", true); 
        var action = component.get("c.searchDataARPU");  
        action.setParams({ 
            'contactId' : getId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){ 
                 var result = response.getReturnValue();
                console.log(result);
                component.set("v.dataHistory", result);
                component.set("v.isModelBoxOpenARPU", true);
                component.set('v.columns1', [
                    {label: 'Sub ID', fieldName: 'sub_id', type: 'text'},
                    {label: 'số thuê bao', fieldName: 'phone', type: 'text'},
                    {label: 'ARPU 3 tháng', fieldName: 'arpu_3m', type: 'text'},
                    {label: 'ARPU 6 tháng', fieldName: 'arpu_6m', type: 'text'},
                    {label: 'Current Month', fieldName: 'current_month', type: 'text'},            
                ]);
                component.set("v.spinner", false); 
            } else if(state === "INCOMPLETE"){   
                    component.set("v.spinner", false); 
                component.set("v.Spinner", false);
            }else if(state === "ERROR"){    
                    component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
    isModelBoxOpenHotLine : function(component, event, helper) {
        var getId = component.get("v.recordId");
        component.set("v.spinner", true); 
        var action = component.get("c.searchHotLine");  
        action.setParams({ 
            'contactId' : getId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){  
                var result = response.getReturnValue();
                component.set("v.dataHotLine", result);
                component.set("v.isModelBoxOpenHotLine", true);
                component.set("v.spinner", false); 
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                    component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
    openModelServicePackage : function(component, event, helper) {
        component.set("v.spinner", true); 
         var getId = component.get("v.recordId");
        var action = component.get("c.searchServicePackage");  
        action.setParams({ 
            'contactId' : getId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){   
                var result = response.getReturnValue();
                    console.log(result);
                    component.set("v.dataServicePackage", result);
                    component.set('v.columns2', [
                    {label: 'Thuê bao', fieldName: 'SUB_ID', type: 'text'},
                    {label: 'Tên gói', fieldName: 'PCK_CODE', type: 'text'},
                    {label: 'Ngày bắt đầu sử dụng', fieldName: 'STADATE', type: 'text'},
                    {label: 'Ngày hết hiệu lực', fieldName: 'ENDDATE', type: 'text'},      
                ]);
                component.set("v.spinner", false); 
                component.set("v.openModelServicePackage", true);
            } else if(state === "INCOMPLETE"){   
                                component.set("v.openModelServicePackage", true);

                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                                component.set("v.openModelServicePackage", true);

                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
    openModelCSDLQG : function(component, event, helper) {
        component.set("v.spinner", true); 
        var getId = component.get("v.recordId");
        var action = component.get("c.searchCSDLQG");  
        action.setParams({ 
            'contactId' : getId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){       
                var result = response.getReturnValue();
                component.set("v.dataCSDLQG", result);
                component.set("v.openModelCSDLQG", true);
                component.set("v.spinner", false); 
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
                        
    openModelReflectingComplaints : function(component, event, helper) {
        component.set("v.openModelReflectingComplaints", true);
        let today = new Date();
        let thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(today.getDate() - 90);

        let formattedToday = today.toISOString().slice(0, 10);
        let formattedThirtyDaysAgo = thirtyDaysAgo.toISOString().slice(0, 10);
        
        component.set('v.fromdate', formattedThirtyDaysAgo);
        component.set('v.todate', formattedToday);
                        
        var getId = component.get("v.recordId");
        var action2 = component.get("c.getContactInformation");  
        action2.setParams({ 
            'contactId' : getId,
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();     
                        component.set("v.contactPhone" , result.contacts.Phone);
                        component.set("v.selectedLookUpRecord" , result.unit);
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action2);
        var a = component.get('c.handleClickSearchReflectingComplaints');
        $A.enqueueAction(a);
                        
    },   
    handleClickSearchReflectingComplaints : function(component, event, helper) {
        var contactPhone = component.get("v.contactPhone");
        var fromdate = component.get("v.fromdate");
        var todate = component.get("v.todate");
        var status = component.get("v.status");
        var Unit = component.get("v.selectedLookUpRecord");
        var today = new Date();
        var date = today.getDate();
        
        /*
        if(contactPhone == null || contactPhone == ''){
            component.set('v.missingPhone' , true); 
            return;
        } else {
            component.set('v.missingPhone' , false);
        }
        */
        /*
        if(status == null || status == '') {
            component.set('v.missingStatus' , true);
            return;
        } else {
            component.set('v.missingStatus' , false);
        }
        */
        if(fromdate == null || fromdate == '') {
            component.set('v.missingFromDate' , true);
            return;
        } else {
            component.set('v.missingFromDate' , false);
        }
        if(todate == null || todate == '') {
            component.set('v.missingToDate' , true);
            return;
        } else {
            component.set('v.missingToDate' , false);
        }
        if(fromdate > todate) {
            alert('"Từ ngày" không được nhỏ hơn "Đến ngày"');
            return;
        }
        if(fromdate > date || todate > date) {
            alert('Thời gian tra cứu không được lớn hơn thời gian hiện tại');
            return;
        }

         var startDate = new Date(fromdate);
        var endDate = new Date(todate);
        
        var timeDifference = endDate.getTime() - startDate.getTime();
        var dayDifference = timeDifference / (1000 * 3600 * 24);
        
        if(dayDifference > 90) {
            alert('Giới hạn tra cứu là Từ ngày cách Đến ngày không quá 90 ngày vui lòng nhập lại');
            return;
        }
        
        component.set("v.spinner2", true); 
        var action = component.get("c.searchReflectingComplaints");   
        action.setParams({ 
            'phone' : contactPhone,
            'fromDate' : fromdate, 
            'toDate' : todate,
            'status' : status,
            'unit' : Unit
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){    
                var result = response.getReturnValue();
                component.set("v.dataReflectingComplaints", result);
                component.set("v.spinner2", false); 
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner2", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner2", false); 
            }
        });        
        $A.enqueueAction(action);
        
        
        component.set('v.columns', [
            {label: 'Thông tin tiền xử lý', fieldName: 'TTTIENXUKY', type: 'text'},
            {label: 'Họ tên khách hàng', fieldName: 'HOTEN', type: 'text'},
            {label: 'Mã thuê bao', fieldName: '796114889', type: 'text'},
            {label: 'Mã yêu cầu', fieldName: '35180039', type: 'text'},
            {label: 'Thời gian tiếp nhận', fieldName: 'THOIGIANTIEPNHAN', type: 'text'},            
            {label: 'Loại Nghiệp vụ', fieldName: 'LOAINGIEPVU', type: 'text'},
            {label: 'Loại Yêu cầu', fieldName: 'LOAIYEUCAU', type: 'text'},
            {label: 'Nhóm Yêu cầu', fieldName: 'NHOMYEUCAU', type: 'text'},
            {label: 'Chi tiết Phản ánh', fieldName: 'CHITIETPA', type: 'text'},
            {label: 'Hình thức tiếp nhận', fieldName: 'HINHTHUCTIEPNHAN', type: 'text'},
            {label: 'Nguồn tiếp nhận', fieldName: 'NGUONTIEPNHAN', type: 'text'},
            {label: 'Template', fieldName: 'TEMPLATE', type: 'text'},
            {label: 'Ghi chú cho người xử lý', fieldName: 'GHICHUCHONGUOIXL', type: 'text'},
            {label: 'Khẩn', fieldName: 'KHAN', type: 'boolean'}
        ]);
        
      
        }

})