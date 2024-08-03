({
	updateCurrentTime : function(component) {
        let currentTime = new Date();
        currentTime = currentTime.toLocaleTimeString();
        component.set("v.getCurrentTime", currentTime);
        var result = component.get("v.agent");
        
        console.log(result);
        var dateTimeClockIn = new Date(result.Clock_in);
        var hourClockIn = dateTimeClockIn.getUTCHours();
        var minuteClockIn = dateTimeClockIn.getUTCMinutes();
        
        var dateTimeNow = new Date();
        var hourNow = dateTimeNow.getUTCHours();
        var minuteNow = dateTimeNow.getUTCMinutes();
        
        console.log(222, dateTimeClockIn);
        console.log(333, dateTimeNow);
      
        console.log(3456, hourNow - hourClockIn);
        
        var text = Math.abs(hourNow - hourClockIn) + ' Giờ ' + Math.abs(minuteNow - minuteClockIn) + ' Phút';
        
        component.set("v.totalTimeWorking", text);        
        // Call the same function again after 1 second
        /*setTimeout(function() {
            this.updateCurrentTime(component);
        }.bind(this), 1000);*/
    }, 
    closeWarning : function (component, event) {
        component.set("v.isShowWarning", false);
    },
    closeWarningClockout : function (component, event) {
        component.set("v.isShowLogOut", false);
    },
    closeWarningFull : function (component, event) {
        component.set("v.isFullSlot", false);
    },
})