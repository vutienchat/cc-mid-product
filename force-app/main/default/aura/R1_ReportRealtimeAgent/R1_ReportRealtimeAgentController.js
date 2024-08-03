({
    doInit : function(component, event, helper) {
        component.set("v.isSpinner", true);
        helper.getAgentInfo(component,event);
        helper.getPicklistManagementUnit(component,event);
        // set lại name cho tab title
        let workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            let focusedTabId = response.tabId;
            workspaceAPI
            .setTabLabel({
                tabId: focusedTabId,
                label: "Báo cáo Realtime Agent"
            })
            .then(function (response) {
                workspaceAPI.setTabIcon({
                    icon: "standard:service_report",
                });
            })
        });
        
        var options = [
            { value: "Pause", label: "Pause" },
            { value: "Logoff", label: "Logoff" },
            { value: "Ready", label: "Ready" },
        ];
            
        let now = new Date();
        let date = now.toISOString().slice(0, 10);
        // Set the default date and time
        component.set("v.defaultDateTime", (date + 'T07:00') );
        component.set("v.defaultDateTimeNow", (date + 'T23:00') );
            
        component.set("v.listOptionsStatus", options);
        //Làm data cho Channel Export
        component.set('v.columnsChannel', [
            {label: 'Đơn vị', fieldName: 'TeamName', type: 'text'},
            {label: 'Đối tác', fieldName: 'GroupName', type: 'text'},
            {label: 'Agent Id', fieldName: 'AgentId', type: 'text', initialWidth: 100},
            {label: 'Agent Name', fieldName: 'AgentName', type: 'text'},
            {label: 'Bàn điện thoại', fieldName: 'Extension', type: 'text'},
            {label: 'Trạng thái bàn', fieldName: 'WorkplaceStatus', type: 'text'},
            {label: 'Cuộc gọi hiện tại', fieldName: 'ActualCall', type: 'text'},
            {label: 'Trạng thái Agent', fieldName: 'StatusName', type: 'text'},
            {label: 'Cuộc gọi gần nhất', fieldName: 'LastCallTimeUtc', type: 'text'},
            {label: 'Tổng số cuộc gọi', fieldName: 'InboundServed', type: 'number'},
            {label: 'Gọi nhỡ', fieldName: 'MissedRing', type: 'number'},
            {label: 'Lần Login đầu tiên trong ngày', fieldName: 'FirstReadyTime', type: 'datetime'},
            {label: 'Tổng thời gian đăng nhập đến hiện tại', fieldName: 'LogonTotal', type: 'number'},
        ]); 
        
        helper.getdata(component,event);
    },
    
    handleSearch: function(component, event, helper) {
        var searchKey = component.get("v.searchKey").toLowerCase();
        var allData = component.get("v.dataChannel");

        var filteredData = allData.filter(function(item) {
            return item.AgentName.toLowerCase().includes(searchKey) || 
                   item.StatusName.toLowerCase().includes(searchKey);
        });

        component.set("v.filteredData", filteredData);
    },
    
    handleChangeStatus: function (cmp, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        console.log("Options selected: '" + selectedOptionsList + "'");
    },
    
    handleRowSelection: function(component, event, helper) {
        let selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRows', selectedRows);
        console.log(selectedRows);
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