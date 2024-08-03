({
    doInit: function(component, event, helper) {
        component.set("v.Spinner", true);
        
        // Fetch Order data
        var action = component.get("c.getOrder");
        var recordId = component.get("v.recordId");
        
        action.setParams({
            'recordId': recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var order = response.getReturnValue();
                component.set("v.order", order);
                
                // Set Contact__r.Phone into Row 2, Col 2
                var rows = component.get("v.rows");
                rows[1].col2 = '84'+order.Contact__r.Phone;
                component.set("v.rows", rows);
                
                // Fetch OrderItem data
                var action2 = component.get("c.getOrderItem");
                action2.setParams({
                    'recordId': recordId
                });
                action2.setCallback(this, function(response2) {
                    var state2 = response2.getState();
                    if (state2 === "SUCCESS") {
                        var orderItem = response2.getReturnValue();
                        
                        // Set Product2.Name into Row 3, Col 2
                        rows[2].col2 = orderItem.Product2.Name;
                        component.set("v.rows", rows);
                        
                        // Fetch current user social name
                        var action3 = component.get("c.getCurrentUserSocialName");
                        action3.setCallback(this, function(response3) {
                            var state3 = response3.getState();
                            if (state3 === "SUCCESS") {
                                var socialUserName = response3.getReturnValue();
                                
                                // Set current user social name into Row 4, Col 2
                                rows[3].col2 = socialUserName;
                                component.set("v.rows", rows);
                                
                                // Fetch current user agency code
                                var action4 = component.get("c.getCurrentUserAgencyCode");
                                action4.setCallback(this, function(response4) {
                                    var state4 = response4.getState();
                                    if (state4 === "SUCCESS") {
                                        var agencyCode = response4.getReturnValue();
                                        
                                        // Set current user agency code into Row 1, Col 2
                                        rows[0].col2 = agencyCode;
                                        component.set("v.rows", rows);
                                        
                                        component.set("v.Spinner", false);
                                    } else {
                                        console.log("Error fetching current user agency code!");
                                    }
                                });
                                $A.enqueueAction(action4);
                                
                            } else {
                                console.log("Error fetching current user social name!");
                            }
                        });
                        $A.enqueueAction(action3);
                        
                    } else {
                        console.log("Error fetching OrderItem!");
                    }
                });
                $A.enqueueAction(action2);
                
            } else {
                console.log("Error fetching Order!");
            }
        });
        $A.enqueueAction(action);
    },
    
    sendData: function(component, event, helper) {
        component.set("v.Spinner", true);
        console.log('saveData function called');
        var rows = component.get("v.rows");
        console.log('Rows to be sent:', JSON.stringify(rows)); // Log dữ liệu trước khi gửi
        var action = component.get("c.saveData");
        var recordId = component.get("v.recordId");
        action.setParams({
            rows: rows,
            'recordId': recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Save data response state:', state); // Log trạng thái của response
            if (state === "SUCCESS") {
                var jsonData = response.getReturnValue();
                console.log('Data saved: ' + jsonData);
                var closeEvent = $A.get("e.force:closeQuickAction");
                closeEvent.fire();
                try {
                    var parsedData = JSON.parse(jsonData);
                    console.log('Data value: ' + parsedData.data); // Log the value of the "data" key
                    // Show popup with the value of the "data" key
                    //var toastEvent = $A.get("e.force:showToast");
                    //toastEvent.setParams({
                    //    "title": "Thành công!",
                    //    "message": "Thao tác đã được thực hiện thành công.",
                    //    "type": "success"
                    //});
                    //toastEvent.fire();
                    component.set("v.Spinner", false);
                    alert(parsedData.data);
                } catch (e) {
                    console.error('Error parsing JSON:', e);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
    
})