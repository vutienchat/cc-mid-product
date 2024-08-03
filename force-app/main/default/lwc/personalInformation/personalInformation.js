import { LightningElement,api } from 'lwc';

export default class PersonalInformation extends LightningElement {
    status='account'
    @api callInfo
    @api callAccount
    
    handleChangeStatus(event){
        this.status=event.currentTarget.dataset.key
    }

   get getIsStatus(){
        return this.status==='account'
    }
}