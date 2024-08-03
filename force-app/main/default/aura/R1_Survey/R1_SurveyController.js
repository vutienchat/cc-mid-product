({
    doInit : function(component, event, helper) {
        var currentUrl = window.location.href;
        
        var encode = currentUrl.split('?')[1].replace('%3D','=');
        
        // check xem có đúng loại base64 không vì đã xảy ra trường hợp thừa dấu = ở cuối
        const base64Regex = /^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/;
        // cover trường hợp thừa dấu =
        if (!base64Regex.test(encode)) encode = encode.replace(/=+$/, '');
        var paramEnc = atob(encode);
        var listString = paramEnc.split('&');
        
        if(listString.length > 0){
            for(var i = 0; i < listString.length; i++){
                let iValue = listString[i].split('=');
                if(listString[i].includes("surveytemplate")){
                    component.set("v.templateName",iValue[1]);
                }else if(listString[i].includes("phone")){
                    component.set("v.phone",iValue[1]);
                }else if(listString[i].includes("recordId")){
                    component.set("v.recordId",iValue[1]);
                }
            }
        }
        
        helper.getInforContact(component, event);   
        helper.getQuestion(component, event);
    },
    
    handleChange : function(component, event, helper) {
        // lấy câu trả lời
        var answer = event.getParam('value');
        
        // lấy số thứ tự của mảng
        var indexvar = event.getSource().get("v.id");
        
        // lấy dữ liệu gốc
        var listItem = component.get("v.listItem");
        
        // gắn kết quả vào đúng giá trị thành phần
        listItem[indexvar].result = answer.toString();
        component.set("v.listItem", listItem);
        
    },
    
    handleSubmit : function(component, event, helper) {
        var isSubmit = component.get("v.isSubmit");
        var surveyData = component.get("v.listItem");
        const action = component.get("c.saveSurvey");
        console.log(component.get("v.phone"));
        action.setParams({
            idata: JSON.stringify(surveyData),
            Phone: component.get("v.phone")
        });
        
        action.setCallback(this, function(response) {
            const state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isSubmited",true);
                component.set("v.process",true);
                component.find("toastCmp").showToastModel("Cảm ơn bạn đã hoàn thành phiếu khảo sát", "success");
                // Optionally, you can clear the form or navigate to another page
            } else {
                console.error('Error saving survey data:', response.getError());
            }
        });
        
        $A.enqueueAction(action);
    }
})