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
        var action = component.get("c.getData");
        action.setParams({
            startDate: component.get("v.defaultDateTime"),
            endDate: component.get("v.defaultDateTimeNow"),
            agentCode: component.get("v.UnitbyRegion"),
            typeCall: component.get("v.typeCall"),
            unitCode: undefined,
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                component.set("v.dataChannel", result);
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
        var action = component.get("c.getPicklistUnitbyRegionDB");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var result = response.getReturnValue();							
                component.set("v.picklistUnitbyRegion", result);               
                
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
    
    getPicklistTypeCall : function(component, event){
        var action = component.get("c.getTypeCall");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var result = response.getReturnValue();	
                console.log(JSON.stringify(result) + '333');
                component.set("v.PickLisTtypeCall", result);               
                
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