({
    openModelAddProduct : function(component, event, helper) {
        component.set("v.isModelBoxOpen" , true);
        component.set("v.showTable", false);
        var oppId = component.get("v.recordId");
       
        var action = component.get("c.getListRecordTypeInOrder");  
         action.setParams({ 
            'oppId' : oppId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue(); 
                component.set("v.optionsRecordType", result); 
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);
        
    },
    closeModal : function(component, event, helper) {
        component.set("v.isModelBoxOpen", false);
        component.set("v.showTable", false);
    },
    handleChangeRecordType : function(component, event, helper) {
        component.set("v.spinner", true); 
        var selectedOptionValue = event.getParam("value"); 
        component.set("v.recordTypeId", selectedOptionValue); 
        
        var action = component.get("c.getListProductByRecordType");
        action.setParams({ 
            'recordTypeId' : selectedOptionValue,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue();   
                if(result[0].RecordType.DeveloperName == 'B_KIT') {
                    component.set('v.columns', [
                        {label: 'Số thuê bao', fieldName: 'So_thue_bao__c', type: 'text'},
                        {label: 'Gói cước', fieldName: 'Name', type: 'text'},
                        {label: 'Giá tiền', fieldName: 'Price__c', type: 'text'}          
                    ]);
                } else {
                    component.set('v.columns', [
                        {label: 'Tên gói cước', fieldName: 'Name', type: 'text'},
                        {label: 'Mô tả', fieldName: 'Description', type: 'text'},
                        {label: 'Giá tiền', fieldName: 'Price__c', type: 'text'}          
                    ]);
                }
                component.set("v.dataProduct", result); 
                component.set("v.data", result);
                component.set("v.showTable", true);
                
                component.set("v.spinner", false);
            } else if(state === "INCOMPLETE"){   
                component.set("v.spinner", false);
            }else if(state === "ERROR"){    
                component.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);
    },
    selectedRow: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set("v.selectedProduct" , selectedRows)
        if(selectedRows.length > 0) {
            cmp.set("v.disableButton", false);
        } else {
            cmp.set("v.disableButton", true);
        }
    },
    
    searchTable : function(cmp,event,helper) {
        var allRecords = cmp.get("v.dataProduct");
        var data = cmp.get("v.data");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var recordCount = allRecords.length;
        var tempArray = [];
        var i;

        if(searchFilter != null && searchFilter != '') {
            for(i=0; i < recordCount; i++){
                if((allRecords[i].So_thue_bao__c && allRecords[i].So_thue_bao__c.toUpperCase().indexOf(searchFilter) != -1) ||
                   (allRecords[i].Name && allRecords[i].Name.toUpperCase().indexOf(searchFilter) != -1 ))
                {
                    tempArray.push(allRecords[i]);
                }
            }
            cmp.set("v.dataProduct",tempArray);
        } else {
            cmp.set("v.dataProduct",data);
        }
    }, 
    handlerAddProductInOpp : function(cmp, event,helper) {
        var selectProduct = cmp.get("v.selectedProduct");
        var recordTypeId = cmp.get("v.recordTypeId");
        
        cmp.set("v.spinner", true); 
        var oppId = cmp.get("v.recordId");
        
        var action = cmp.get("c.addProductInOpp");  
        action.setParams({ 
            'lstProduct' : selectProduct,
            'oppId' : oppId,
            'recordTypeId' : recordTypeId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){          
                var result = response.getReturnValue(); 
                if(result == 'Success') {
                    cmp.set("v.showTable", false);
                    cmp.set("v.isModelBoxOpen", false);
                    cmp.set("v.spinner", false);
                    $A.get('e.force:refreshView').fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Thành công!",
                        "message": "Bạn đã thêm sản phẩm thành công.",
                        "type": "success"
                    });
                    toastEvent.fire();
                } else {
                    cmp.set("v.spinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result,
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            } else if(state === "INCOMPLETE"){   
                cmp.set("v.spinner", false);
            }else if(state === "ERROR"){    
                cmp.set("v.spinner", false);
            }
        });        
        $A.enqueueAction(action);        
    }
})