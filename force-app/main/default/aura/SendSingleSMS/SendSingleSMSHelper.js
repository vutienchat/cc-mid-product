/* * @description       : The Class for Log
* @author            : DTDuong - GMS
* @last modified on  : 2024.04.03
* @last modified by  : Dinh Tung Duong(dtduong@gimasys.com)
* @history           :    date                    author                      content
* */
({
    getTemp : function(component, event, helper) {
        var action = component.get("c.getListTemplate");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse.listEmailTemplate != null){
                    var listSMSTemplate = [];
                    storeResponse.listEmailTemplate.forEach(function(item,idx) {
                        listSMSTemplate.push({
                            label:item.Name,
                            value:item.Id })
                    });
                    console.log('listSMSTemplate:',listSMSTemplate);
                    component.set("v.listEmailTemplate", listSMSTemplate);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    sendSmsHelper : function(component, event, helper) {
        component.set("v.Spinner", true); 
        var content = component.get("v.smsContent");
        console.log(3333 + content);
        if(component.get("v.SMS_Opt_Out") === false){
            if(content != null && content != ''){               
                var recordId = component.get("v.recordId");
                var typeObject = component.get("v.sObjectName");
                var action = component.get("c.sendSms");
                console.log(typeObject);
                action.setParams({
                    'recordId' : recordId,
                    'smscontent': content,
                    'typeObject': typeObject
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var storeResponse = response.getReturnValue();	
                        console.log(storeResponse);
                        component.set("v.Spinner", false);
                        if(storeResponse.code == 200){
                            component.find("toastCmp").showToastModel(storeResponse.status, "success");
                        } else if(storeResponse.code == 500){
                            component.find("toastCmp").showToastModel(storeResponse.status, "error");
                        } else {
                            component.find("toastCmp").showToastModel("unknow", "error");
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        } else {
            component.find("toastCmp").showToastModel('Bản ghi không được gửi tin nhắn', "info");
            component.set("v.Spinner", false); 
        }
        
    },
    
    change_alias : function(alias) {
        var str ='';
        if(alias != null){
            str  = alias;
            str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g,"a"); 
            str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g,"e"); 
            str = str.replace(/ì|í|ị|ỉ|ĩ/g,"i"); 
            str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g,"o"); 
            str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g,"u"); 
            str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g,"y"); 
            str = str.replace(/đ/g,"d");
            
            str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g,"A"); 
            str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g,"E"); 
            str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g,"I"); 
            str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g,"O"); 
            str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g,"U"); 
            str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g,"Y"); 
            str = str.replace(/Đ/g,"D");
            //str = str.replace(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'|\"|\&|\#|\[|\]|~|\$|_|`|-|{|}|\||\\/g," ");
            str = str.replace(/ + /g," ");
        }
        
        return str;
        
    },
    
    changeContent : function(component, event, helper) {
        var content = component.get("v.smsContent");
        if(content != null && content != ''){
            var strContentTemp = content.length >= 0 ? content : '' ;   
            var textContent = helper.change_alias(strContentTemp);
            component.set("v.smsContent", textContent);
        }
    }
    
})