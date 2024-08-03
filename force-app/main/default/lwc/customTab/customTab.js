import { LightningElement, api } from 'lwc';

export default class CustomTab extends LightningElement {
    iconName=''
    label=''
    @api value=''

    connectedCallback(){
    this.setAttribute('class', 'slds-tabs_default__content slds-hide');
    this.setAttribute('id', this.value);
    }
}