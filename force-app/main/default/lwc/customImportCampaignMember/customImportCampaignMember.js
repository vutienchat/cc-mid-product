import { LightningElement, api, track } from 'lwc';
import saveFile from '@salesforce/apex/R1_UploadCampaignMemberController.saveFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

export default class R1_CustomImportCampaignMember extends NavigationMixin(LightningElement) {
    @track UploadFile = 'Upload CSV File';
    @api recordId;
    @track fileName = '';
   
    @track showLoadingSpinner = false;
    @track isTrue = false;
    selectedRecords;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 1500000;

    handleFilesChange(event) {
        if (event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = this.filesUploaded[0].name;
        }
    }

    handleSave() {
        if (this.filesUploaded.length > 0) {
            this.uploadFile();
        } else {
            this.fileName = 'Please select a CSV file to upload!!';
        }
    }

    uploadFile() {
        if (this.filesUploaded[0].size > this.MAX_FILE_SIZE) {
            console.log('File Size is too large');
            return;
        }
        this.showLoadingSpinner = true;
        this.fileReader = new FileReader();
        this.fileReader.onloadend = () => {
            this.fileContents = this.fileReader.result;
            this.saveFile();
        };
        this.fileReader.readAsText(this.filesUploaded[0]);
    }

    saveFile() {
        try {
            saveFile({ base64Data: JSON.stringify(this.fileContents), cdbId: this.recordid })
                .then(result => {
                    if (result === null) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Warning',
                                message: 'The CSV file does not contain any data',
                                variant: 'warning',
                            }),
                        );
                    }
                    else if(result.status == 'success'){
                        this.fileName = this.fileName + ' – Uploaded Successfully';
                        this.isTrue = false;
                        this.showLoadingSpinner = false;
                        if(result == 'success') {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success!!',
                                    message: this.filesUploaded[0].name + ' – Uploaded Successfully!!!',
                                    variant: 'success',
                                }),
                            );
                        } 
                     
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.recordId,
                                actionName: 'view',
                            }
                            });

                    } else if(result.status == 'warnning'){  
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Cảnh báo',
                                message: result.message,
                                variant: 'warning',
                            }),
                        );

                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.recordId,
                                actionName: 'view',
                            }
                            });
                            
                    } else {
                        this.showLoadingSpinner = false;
                        this.dispatchEvent(new CloseActionScreenEvent());
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Lỗi!',
                                message: result.message,
                                variant: 'error',
                            }),

                        );
                    }
                })
                .catch(error => {
                    console.error(error);
                    this.showLoadingSpinner = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error while uploading File',
                            message: error.message,
                            variant: 'error',
                        }),
                    );
                });
        } catch (error) {
            console.error(error);
            this.showLoadingSpinner = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An unexpected error occurred.',
                    variant: 'error',
                }),
            );
        }
    }
}