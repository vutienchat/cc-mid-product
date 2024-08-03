({
	checkTimeWithShift : function(cmp, result) {
		var timeShift = result.split("-");
        var endTime = timeShift[1].split(":");
        var timeInteger = Number(endTime[0] + endTime[1]);
        
        var dateTimeNow = new Date();
        var hourNow = dateTimeNow.getHours();
        var minuteNow = dateTimeNow.getMinutes();
        var timeNowInteger = Number(hourNow.toString() + minuteNow.toString());
        if((timeInteger - timeNowInteger) == 10 || (timeInteger - timeNowInteger) == 9 || (timeInteger - timeNowInteger) == 8) {
            cmp.set("v.isShowModal" , true);
        } else if((timeInteger - timeNowInteger) == -30 || (timeInteger - timeNowInteger) == -31 || (timeInteger - timeNowInteger) == -32) {
            var action = component.get("c.createNotificationForManager");
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){      
                    component.set("v.Spinner", false);
                    console.log("SUCCESS");
                } else if(state === "INCOMPLETE"){   
                    component.set("v.Spinner", false);
                }else if(state === "ERROR"){    
                    component.set("v.Spinner", false);
                }
        });        
            $A.enqueueAction(action);
        } 
        setTimeout(function() {
            this.checkTimeWithShift(cmp, result);
        }.bind(this), 60000); 
	}
})