({
    convertArrayOfObjectsToCSV : function(objectRecords, columns) {
        if (!objectRecords || !objectRecords.length) {
            return null;
        }

        // Get the headers from columns
        let csvStringResult = '';
        let headers = columns.map(col => col.label);
        csvStringResult += headers.join(',') + '\n';

        // Add the CSV data
        objectRecords.forEach(record => {
            let values = columns.map(col => record[col.fieldName]);
            csvStringResult += values.join(',') + '\n';
        });

        return csvStringResult;
    },
    convertArrayOfObjectsToCSVChannel : function(objectRecords, columnsChannel) {
        if (!objectRecords || !objectRecords.length) {
            return null;
        }

        // Get the headers from columns
        let csvStringResultChannel = '';
        let headersChannel = columnsChannel.map(col => col.label);
        csvStringResultChannel += headersChannel.join(',') + '\n';

        // Add the CSV data
        objectRecords.forEach(record => {
            let valuesChannel = columnsChannel.map(col => record[col.fieldName]);
            csvStringResultChannel += valuesChannel.join(',') + '\n';
        });

        return csvStringResult;
    },
    
    getdata : function(component, event, helper) {
        component.set("v.isSpinner", true);
        var action = component.get("c.getData");
        action.setParams({
            startDate: component.get("v.defaultDateTime"),
            endDate: component.get("v.defaultDateTimeNow"),
            codeGroup: component.get("v.UnitbyRegion"),
            codeTeam: component.get("v.ManagementUnit"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log(result.length);
                if(result.length > 1){
                    component.set("v.dataChannel", result);
                    component.set("v.isSearch", true);
                }else{
                    component.set("v.dataChannel", undefined);
                    component.set("v.isSearch", true);
                }
                component.set("v.isSpinner", false);
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data createTask, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data createTask, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
    
    getPicklistUnitbyRegion : function(component, event){
        component.set("v.isSpinner", true);
        var action = component.get("c.getPicklistUnitbyRegionDB");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var result = response.getReturnValue();							
                component.set("v.picklistUnitbyRegion", result);               
                component.set("v.isSpinner", false); 
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getGroupTOD, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getGroupTOD, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
    
    getAgentInfo : function(component, event){
        var action = component.get("c.getAgentInfoDB");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var result = response.getReturnValue();							
                component.set("v.ManagementUnit", result.Management_Unit__c);
                component.set("v.UnitbyRegion", result.Partner__c);
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getGroupTOD, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getGroupTOD, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
    
    getPicklistManagementUnit : function(component, event){
        var action = component.get("c.getPicklistManagementUnitDB");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var result = response.getReturnValue();							
                component.set("v.picklistManagementUnit", result);               
                
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data getGroupTOD, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data getGroupTOD, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    },
})