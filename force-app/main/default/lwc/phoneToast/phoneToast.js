import { LightningElement,api } from 'lwc';

export default class PhoneToast extends LightningElement {
   @api isRinging
    isShow=false
   static message=''

    renderedCallback(){
    }

    static showToast(msg){
        this.isRinging= !this.isRinging
        this.message= msg
        console.log('msg',msg) 
    }

   get getClass(){
        return this.isRinging ? 'toast-wrapper show':'toast-wrapper'
    }



    handleClick(){
        const event = new CustomEvent("actions")
        this.dispatchEvent(event)
    }

    static show(msg){
    this.message= msg
    this.isShow=true
    }
}