import { LightningElement,api } from 'lwc';

export default class Dialpad extends LightningElement {
    numberKey = [1, 2, 3, 4, 5, 6, 7, 8, 9, "*", 0, "#"];
    @api phoneNumber
    @api iscollapse
    @api agentStatus

    get nameExtension(){
       return this.agentStatus ?'ON':'OFF'
    }

    get classInputToggle(){
       return this.agentStatus ?'input-toggle':''
    }

    get disabledMakeCall(){
       return this.agentStatus ? false : true
    }

    @api 
    handleMakeCall = () => {
        this.dispatchEvent(new CustomEvent("makecall"))
    }

    @api
    handleChangePhoneNumber = (event) => {
        const value = event.target.value
        const reg = new RegExp('^[0-9*#]+$');
        const isNumber =reg.test(value);
        if(isNumber){
            const newEvent = new CustomEvent("changephonenumber",{detail:value})
            this.dispatchEvent(newEvent)
        }else{
            this.phoneNumber=value ? this.phoneNumber: ''
        }
    }

    @api
    handleKeyPress = (event) => {
        const newEvent = new CustomEvent("changekeypress",{detail:event.currentTarget.dataset.key})
        this.dispatchEvent(newEvent)
    }

    @api
    handleExpand(){
        const event = new CustomEvent("expand")
        this.dispatchEvent(event)
    }

    @api
    handleCollapse(){
        const event = new CustomEvent("collapse")
        this.dispatchEvent(event)
    }
    
    handleExtension(event){
        this.agentStatus=true
    }

    handleDeletePhoneNumber(){
        const newEvent = new CustomEvent("changephonenumber",{detail:this.phoneNumber.slice(0, -1)})
        this.dispatchEvent(newEvent)
    }

}