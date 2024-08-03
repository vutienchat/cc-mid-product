({
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){  
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        var requiredField = component.get("v.requiredField");
        if(component.get('v.result') == null || component.get('v.result') == '' || component.get('v.result') == undefined){
            component.set('v.SearchKeyWord', null);
            if(requiredField == true){
                $A.util.addClass(component.find("checkRequired"), 'chekRequired');
                component.set('v.check', true);
                $A.util.addClass(component.find("block-input"), 'slds-has-error');  
            }
        }else{
            if(requiredField == true){
                $A.util.removeClass(component.find("checkRequired"), 'chekRequired');
                component.set('v.check', false);
                $A.util.removeClass(component.find("block-input"), 'slds-has-error');  
            }
        }
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onblur2 : function(component,event,helper){  
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );  
        component.set("v.result", null);   
        
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        debugger
        // xóa error
        $A.util.removeClass(component.find("checkRequired"), 'chekRequired');
        component.set('v.check', false);
        $A.util.removeClass(component.find("block-input"), 'slds-has-error');
        
        var objectAPIName = component.get("v.objectAPIName");
        var indexFli = component.get("v.indexFli");
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        component.set("v.result" , selectedAccountGetFromEvent.Name);
        /*
        // call the event   
        var compEvent = component.getEvent("oRunFunction");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"runFunciton" : true,"indexFli" : indexFli });  
        // fire the event  
        compEvent.fire();
        */
        
        helper.addTag(component,event);
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
        
        window.location.reload()
    },
    
    handleBackLocation : function(component, event, helper) {
        /*var result = component.get("v.result");
        var objectAPIName = component.get("v.objectAPIName");
        // get the selected Account record from the COMPONETN event 
        var a = component.get("v.selectedRecord");
        console.log(a.Name);
        if(objectAPIName == 'Airport__c'){
            component.set("v.result" , a.IATA__c); 
        }else if ( objectAPIName == 'B2B_Air_Price_List__c'){
            component.set("v.result" , a.Id); 
        }*/
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        /*if(component.find("resCustomLookup").length > 0) component.find("resCustomLookup").forEach(function(f) {
            f.backResult();
        });
        else component.find("resCustomLookup").backResult();*/
    },
    
    handleClick: function (component, event) {
        var action = component.get("c.createTag");
        action.setParams({
            caseId: component.get("v.recordId"),
            nameTag: component.get("v.SearchKeyWord")
        });
        action.setCallback(this, function(response){
            var state = response.getState();        
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                
                window.location.reload()
            }else if (state === "INCOMPLETE"){
                component.set("v.isSpinner", false);
                console.log("User is offline, device doesn't support drafts.")
            }else if (state === "ERROR"){
                component.set("v.isSpinner", false);
                console.log("Problem when load data handleRemove, Error: " + JSON.stringify(response.error));
            }else{
                component.set("v.isSpinner", false);
                console.log("Problem when load data handleRemove, State: " + state +  ", Error: " + JSON.stringify(response.error));
            }
        });
        $A.enqueueAction(action);
    }
})