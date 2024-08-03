({
    doInit : function(component, event, helper) {
        
        let now = new Date();
        let thirtyMinutesAgo = new Date(now.getTime() - 30 * 60000 + 7 *60 *60000 );
        let present = new Date(now.getTime()+ 7 *60 *60000 );
        
        // Format the date and time to a string suitable for <lightning:input type="datetime">
        let formattedDateTime = thirtyMinutesAgo.toISOString().slice(0, 16);
        let formattedDateTimeNow = present.toISOString().slice(0, 16);
        // Set the default date and time
        component.set("v.defaultDateTime", formattedDateTime);
        component.set("v.defaultDateTimeNow", formattedDateTimeNow);
        helper.getPicklistTypeCall(component,event);
        //helper.getPicklistUnitbyRegion(component,event);
        
        //Làm data cho Time Export
        
        component.set('v.columns', [
            {label: 'CallType', fieldName: 'CallType', type: 'text'},
            {label: 'State', fieldName: 'State', type: 'text'},
            {label: 'Phase', fieldName: 'Phase', type: 'text'},
            /*{label: 'total_call_dtv', fieldName: 'total_call_dtv', type: 'number'},
            {label: 'total_call_answered', fieldName: 'total_call_answered', type: 'number'},
            {label: 'total_call_60s', fieldName: 'total_call_60s', type: 'number'},
            {label: 'avg_call_time', fieldName: 'avg_call_time', type: 'number'},
            {label: 'sv_ratio', fieldName: 'sv_ratio', type: 'number'},
            {label: 'sv_ratio_60', fieldName: 'sv_ratio_60', type: 'number'},*/
        ]); 

        helper.getdata(component,event);
    },
    handleSelectUnitByRegion : function(component, event, helper){
        var groupRequestClassType = event.getSource().get("v.value"); 
    },
            
    handleSelectTypeCall : function(component, event, helper){
        var a = event.getSource().get("v.value"); 
    },
            
    // Nút Search
    btnSearch : function(component,event,helper){
        component.set("v.isSearch", true);
        
        helper.getdata(component,event);
    },
    downloadCSV : function(component, event, helper) {
        let data = component.get("v.data");
        let columns = component.get("v.columns");
        let fileName = component.get("v.fileName");
        
        if (!data || !data.length || !columns || !columns.length) {
            return;
        }
        
        // Convert table data to CSV string
        let csvContent = helper.convertArrayOfObjectsToCSV(data, columns);
        
        if (csvContent) {
            // Create a data URL from the CSV content
            let dataUrl = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent);
            let downloadLink = document.getElementById('downloadLink');
            
            // Set the download link attributes
            downloadLink.setAttribute('href', dataUrl);
            downloadLink.setAttribute('download', fileName);
            
            // Simulate a click on the link
            downloadLink.click();
        }
    },
    downloadCSVChannel : function(component, event, helper) {
        let dataChannel = component.get("v.dataChannel");
        let columnsChannel = component.get("v.columnsChannel");
        let fileName = component.get("v.fileName");
        
        if (!dataChannel || !dataChannel.length || !columnsChannel || !columnsChannel.length) {
            return;
        }
        
        // Convert table data to CSV string
        let csvContent = helper.convertArrayOfObjectsToCSV(dataChannel, columnsChannel);
        
    if (csvContent) {
            // Create a data URL from the CSV content
            let dataUrl = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent);
            let downloadLink = document.getElementById('downloadLink');
            
            // Set the download link attributes
            downloadLink.setAttribute('href', dataUrl);
            downloadLink.setAttribute('download', fileName);
            
            // Simulate a click on the link
            downloadLink.click();
        }
    }
})