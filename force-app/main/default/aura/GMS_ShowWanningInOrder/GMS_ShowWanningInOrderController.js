({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.checkPriceInOrderItem");
         action.setParams({ 
             'recordId' : recordId 
         });
         action.setCallback(this, function(response){
             var state = response.getState();
             if(state === "SUCCESS"){   
                 var a = component.get('c.showWanningPirice');
                 var b = component.get('c.showWanningSaleChannel');
                 var result = response.getReturnValue();      
                 if(result == '0') {
                     $A.enqueueAction(a);
                     $A.enqueueAction(b);
                 } else if(result == '1') {
                      $A.enqueueAction(a);
                 } else if(result == '2') {
                     $A.enqueueAction(b);
                 } else if(result == '3') {
                     
                 }
             } else if(state === "INCOMPLETE"){   
             }else if(state === "ERROR"){    
             }
         });        
         $A.enqueueAction(action);  
    },
    showWanningPirice : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Cảnh báo',
            message : 'Giá sản phẩm trên đơn hàng khác với giá đã được khai báo',
            type : 'warning',
            duration : '5000',
            key : 'Info_alt',
            mode: 'sticky'
        });
        toastEvent.fire();
    },
    showWanningSaleChannel : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Cảnh báo',
            message : 'Nguồn của đơn hàng khác với Kênh bán của sản phẩm',
            type : 'warning',
            duration : '5000',
            key : 'Info_alt',
            mode: 'sticky'
        });
        toastEvent.fire();
    },
})