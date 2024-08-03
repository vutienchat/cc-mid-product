({
    doInit : function(component, event, helper) {
        // set lại name cho tab title
        let workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            let focusedTabId = response.tabId;
            workspaceAPI
            .setTabLabel({
                tabId: focusedTabId,
                label: "Báo cáo chấm công thời gian làm việc"
            })
            .then(function (response) {
                workspaceAPI.setTabIcon({
                    icon: "standard:service_report",
                });
            })
        });
        
        let now = new Date();
        let date = now.toISOString().slice(0, 10);
        // Set the default date and time
        component.set("v.defaultDateTime", (date + 'T07:00') );
        component.set("v.defaultDateTimeNow", (date + 'T23:00') );
        
        helper.getAgentInfo(component,event);
        helper.getPicklistManagementUnit(component,event);
        //Làm data cho Channel Export
        component.set('v.columnsChannel', [
            {label: 'Agent', fieldName: 'DisplayName', type: 'text', initialWidth: 100},
            {label: 'Tổng thời gian làm việc', fieldName: 'total_time_working', type: 'number', initialWidth: 200},
            {label: 'Thời gian (số giây) đăng nhập (login)', fieldName: 'total_time_login', type: 'number', initialWidth: 300},
            {label: 'Thời gian (số giây) không sẵn sàng (not ready)', fieldName: 'total_time_not_ready', type: 'number', initialWidth: 350},
            {label: 'Thời gian (số giây) sẵn sàng (ready)', fieldName: 'total_time_ready', type: 'number', initialWidth: 300},
            {label: 'Thời gian (số giây) giữ máy (hold máy)', fieldName: 'total_time_hold', type: 'number', initialWidth: 300},
            {label: 'Thời gian (số giây) chờ bắt máy', fieldName: 'total_time_ring', type: 'number', initialWidth: 300},
            {label: 'Thời gian trả lời (số giây)', fieldName: 'total_time_reply', type: 'number', initialWidth: 200},
            {label: 'Cuộc gọi đến ĐTV', fieldName: 'total_call_dtv', type: 'number', initialWidth: 200},
            {label: 'Cuộc gọi ĐTV trả lời', fieldName: 'total_call_dtv_reply', type: 'number', initialWidth: 200},
            {label: 'Cuộc gọi ĐTV từ chối', fieldName: 'total_call_dtv_reject', type: 'number', initialWidth: 200},
            {label: 'Cuộc gọi ĐTV để rớt', fieldName: 'total_call_dtv_fall', type: 'number', initialWidth: 200},
            {label: 'Cuộc gọi ĐTV gác máy trước', fieldName: 'total_call_dtv_hungup', type: 'number', initialWidth: 200}
        ]); 
            
        helper.getdata(component,event);
    },
    handleSelectUnitByRegion : function(component, event, helper){
        
        var UnitByRegion = event.getSource().get("v.value"); 
    },
    
    handleSelectManagementUnit : function(component, event, helper){
        
        var ManagementUnit = event.getSource().get("v.value"); 
    },
            
    // Nút Search
    btnSearch : function(component,event,helper){
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
            let dataUrl = 'data:text/csv;charset=UTF-8,' + encodeURIComponent(csvContent);
            let downloadLink = document.getElementById('downloadLink');
            
            // Set the download link attributes
            downloadLink.setAttribute('href', dataUrl);
            downloadLink.setAttribute('download', fileName);
            
            // Simulate a click on the link
            downloadLink.click();
        }
    }
})