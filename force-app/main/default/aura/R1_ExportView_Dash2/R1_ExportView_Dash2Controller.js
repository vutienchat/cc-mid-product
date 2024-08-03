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
        
        //helper.getPicklistUnitbyRegion(component,event);
        
        //Làm data cho Time Export
        
        component.set('v.columns', [
            {label: 'groupName', fieldName: 'groupName', type: 'text'},
            {label: 'time_group', fieldName: 'time_group', type: 'text'},
            {label: 'total_call', fieldName: 'total_call', type: 'number'},
            {label: 'total_call_dtv', fieldName: 'total_call_dtv', type: 'number'},
            {label: 'total_call_answered', fieldName: 'total_call_answered', type: 'number'},
            {label: 'total_call_60s', fieldName: 'total_call_60s', type: 'number'},
            {label: 'avg_call_time', fieldName: 'avg_call_time', type: 'number'},
            {label: 'sv_ratio', fieldName: 'sv_ratio', type: 'number'},
            {label: 'sv_ratio_60', fieldName: 'sv_ratio_60', type: 'number'},
        ]); 
            
            var dataExportView = [
            {
            "groupName": "MB",
            "time_group": "",
            "total_call": 3,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "00:00 - 02:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "02:00 - 04:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "04:00 - 06:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "06:00 - 08:00",
            "total_call": 2,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "08:00 - 10:00",
            "total_call": 1,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "10:00 - 12:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "12:00 - 14:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "14:00 - 16:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "16:00 - 18:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "18:00 - 20:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "20:00 - 22:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            },
            {
            "groupName": "",
            "time_group": "22:00 - 24:00",
            "total_call": 0,
            "total_call_dtv": 0,
            "total_call_answered": 0,
            "total_call_60s": 0,
            "avg_call_time": 0,
            "sv_ratio": 0.0,
            "sv_ratio_60": 0.0
            }
            
        ]
                      component.set("v.data", dataExportView);
        
        //Làm data cho Channel Export
        component.set('v.columnsChannel', [
            {label: 'Đơn vị', fieldName: 'groupName', type: 'text'},
            {label: 'Line', fieldName: 'displayName', type: 'text'},
            {label: 'Kênh', fieldName: 'chanel_name', type: 'text'},
            {label: 'Tổng CG đến', fieldName: 'total_call', type: 'number'},
            {label: 'Tổng CG đến ĐTV', fieldName: 'total_call_dtv', type: 'number'},
            {label: 'Tổng CG do ĐTV trả lời', fieldName: 'total_call_answered', type: 'number'},
            {label: 'Tổng CG trả lời 60s', fieldName: 'total_call_60s', type: 'number'},
            {label: 'Độ dài trung bình/1 CG', fieldName: 'avg_call_time', type: 'number'},
            {label: 'Tỉ lệ phục vụ chung', fieldName: 'sv_ratio', type: 'number'},
            {label: 'Tỉ lệ phục vụ 60s', fieldName: 'sv_ratio_60', type: 'number'},
        ]); 
            
        helper.getdata(component,event);
    },
    handleSelectUnitByRegion : function(component, event, helper){
        
        var groupRequestClassType = event.getSource().get("v.value"); 
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