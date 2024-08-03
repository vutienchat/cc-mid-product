import { LightningElement, api, track } from 'lwc';
import showSlotAgent from '@salesforce/apex/ShowSlotAgentController.querySlot';
import deleteWorkItem from '@salesforce/apex/ShowSlotAgentController.deleteWorkManagerment';
import {FlowNavigationBackEvent,FlowNavigationNextEvent} from "lightning/flowSupport";
const columns = [
    {
        label: 'Khung giờ',
        fieldName: 'hour',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        }
    },
    {
        label: 'Ngày',
        fieldName: 'day',
        type: 'date',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        },
        typeAttributes: {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric',
        }
    },
    {
        label: 'Số NV dự kiến',
        fieldName: 'userUsing',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        }
    },
    {
        label: 'Số bàn làm việc tối đa',
        fieldName: 'userSystem',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        }
    },
    {
        label: 'Số bàn làm việc khả dụng',
        fieldName: 'userMissing',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        }
    }
];

export default class ShowSlotAgentByHourScreen extends LightningElement {
    rowOffset = 5;
    @track data;
    @track fileName = '';
    @track isLoaded = false;
    @track isTrue = false;
    @track columns = columns;
    @track isShowButtonImport = true;
    @api startDate;
    @api endDate;
    @api shift;
    @api availableActions = [];
    @api key;
    @api partner;

    connectedCallback() {
        this.getSlot();
    }
    getSlot() {
        this.isLoaded = true;
        showSlotAgent({ startDate: this.startDate, endDate: this.endDate , partner : this.partner})
            .then(result => {
                result.forEach(ele => {
                    ele.format = ele.userMissing < 0 ? 'slds-text-color_error background-red' : 'slds-text-color_success';
                    if (ele.userMissing < 0) {
                        this.isShowButtonImport = false; 
                    }
                });
                this.data = result;
                this.isLoaded = false;
            })
            .catch(error => {
                // Handle error
            });
    }
    handleCreateWorkShip() {
        if (this.availableActions.find((action) => action === "NEXT")) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
          }
    }

    handleReupload() {
        this.isLoaded = true;
        deleteWorkItem({ key: this.key })
            .then(result => {
                window.location.reload();
            })
            .catch(error => {
                // Handle error
            });
    }
}