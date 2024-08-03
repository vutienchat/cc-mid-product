import { LightningElement, api, track } from 'lwc';
import saveFile from '@salesforce/apex/UploadWorkShipController.saveFile';
import deleteWorkShipLine from '@salesforce/apex/UploadWorkShipController.deleteWorkShipLineItem';
import getPicklistValue from '@salesforce/apex/UploadWorkShipController.getGlobalPicklistValues';
import getDefaultValuePartner from '@salesforce/apex/UploadWorkShipController.getDefaulValuePartner';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import handleCreateWorkShip from '@salesforce/apex/UploadWorkShipController.createWorkship';
import handleShowSlotWorkshift from '@salesforce/apex/UploadWorkShipController.showSlotByAgent';
import { NavigationMixin } from 'lightning/navigation';
import showWorkShipDup from '@salesforce/apex/UploadWorkShipController.showDuplicateWorkship';
import checkWorkShipDuplicate from '@salesforce/apex/UploadWorkShipController.checkWorkShipDup';
import getWorkShipline from '@salesforce/apex/UploadWorkShipController.getLstWorkShiftLineDel';


const columns = [
    {
        label: 'Khung giờ',
        fieldName: 'hour',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        },
        sortable: "true",
    },
    {
        label: 'Ngày',
        fieldName: 'day',
        type: 'date',
        sortable: "true",
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

const columnsDuplicate = [
    {
        label: 'Tên tổng đài viên',
        fieldName: 'AgentName',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        },
    },
    {
        label: 'Ca trực',
        fieldName: 'shift',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        },
    },
    {
        label: 'Ngày làm việc',
        fieldName: 'WorkingDate',
        cellAttributes: {
            class: {
                fieldName: 'format'
            },
        }
    }
];


export default class LwcCSVUploader extends NavigationMixin(LightningElement) {
    @api recordid;
    rowOffset = 5;
    @track data;
    @track dataDuplicate;
    @track fileName = '';
    @track errorMonth = '';
    @track errorYear = '';
    @track UploadFile = 'Tạo ca làm';
    @track isLoaded = false;
    @track isTrue = false;
    @track columns = columns;
    @track columnsDuplicate = columnsDuplicate;
    @track selectedValueMonth;
    @track selectedValueYear;
    @track isShowButtonImport = true;
    defaultSortDirection = 'asc';
    @track sortBy;
    @track sortDirection;
    @track errorDuplicate = '';
    @track isShowModal = false;
    @track getListPartner = [];
    @track selectedValuePartner;
    @track valuePartner;
    @track defaultPartner;
    @track workManagerment = [];
    @track dataManagerMent = [];
    selectedRecords;
    roundedNumber;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 1500000;

    get options() {
        return [
            { label: 'Tháng 1', value: '1' },
            { label: 'Tháng 2', value: '2' },
            { label: 'Tháng 3', value: '3' },
            { label: 'Tháng 4', value: '4' },
            { label: 'Tháng 5', value: '5' },
            { label: 'Tháng 6', value: '6' },
            { label: 'Tháng 7', value: '7' },
            { label: 'Tháng 8', value: '8' },
            { label: 'Tháng 9', value: '9' },
            { label: 'Tháng 10', value: '10' },
            { label: 'Tháng 11', value: '11' },
            { label: 'Tháng 12', value: '12' },
        ];
    }

    get optionsYear() {
        return [
            { label: '2024', value: '2024' },
            { label: '2025', value: '2025' },
            { label: '2026', value: '2026' },
            { label: '2027', value: '2027' },
            { label: '2028', value: '2028' },
            { label: '2029', value: '2029' },
            { label: '2030', value: '2030' },
            { label: '2031', value: '2031' },
            { label: '2032', value: '2032' },
            { label: '2033', value: '2033' },
            { label: '2034', value: '2034' },
            { label: '2035', value: '2035' },
            { label: '2036', value: '2036' },
            { label: '2037', value: '2037' },
            { label: '2038', value: '2038' },
            { label: '2039', value: '2039' },
            { label: '2039', value: '2039' },
            { label: '2040', value: '2040' },
        ];
    }

    get optionDefault() {

    }

    connectedCallback() {
        getPicklistValue({})
            .then(result => {
                if (result.length > 0) {
                    this.getListPartner = result;
                    this.valuePartner = result[0].defaultValue;
                    this.defaultPartner = result[0].defaultValue;
                    this.selectedValuePartner = result[0].defaultValue;
                }
            })
            .catch(error => {
                // Handle error
            });
    }

    handleChangePartner(event) {
        this.selectedValuePartner = event.detail.value;

        if (this.selectedValuePartner != this.defaultPartner) {
            alert('Đối tác khu vực bạn chọn đang khác với đối tác khu vực hiện tại của bạn, bạn có chắc chắn muốn thay đổi?');
        }
    }
    handleChangeMonth(event) {
        this.selectedValueMonth = event.detail.value;
        this.errorMonth = '';
        this.errorDuplicate = '';
    }

    handleChangeYear(event) {
        this.selectedValueYear = event.detail.value;
        this.errorYear = '';
    }

    handleFilesChange(event) {
        if (event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = this.filesUploaded[0].name;
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }

    handleSave() {
        var d = new Date();
        var currentYear = d.getFullYear();
        var currentMonth = d.getMonth();

        if (this.filesUploaded.length <= 0) {
            this.fileName = 'Vui lòng chọn một CSV file để upload!';
        } else if (this.selectedValueMonth < (currentMonth + 1) && this.selectedValueYear == currentYear) {
            this.errorMonth = 'Vui lòng chọn tháng lớn hơn hoặc bằng tháng hiện tại';
        } else if (this.selectedValueYear < currentYear) {
            this.errorYear = 'Vui lòng chọn năm lớn hơn hoặc bằng năm hiện tại';
        } else {
            this.uploadFile();
        }
    }

    uploadFile() {
        if (this.filesUploaded[0].size > this.MAX_FILE_SIZE) {
            console.log('File Size is too large');
            return;
        }
        this.isLoaded = true;
        this.fileReader = new FileReader();
        this.fileReader.onloadend = () => {
            this.fileContents = this.fileReader.result;
            this.handleCheckWorkShip();
        };
        this.fileReader.readAsText(this.filesUploaded[0], "UTF-8");
    }

    handleCheckWorkShip() {
        checkWorkShipDuplicate({ month: this.selectedValueMonth, year: this.selectedValueYear, partner: this.selectedValuePartner })
            .then(result => {
                if (result === true) {
                    this.isLoaded = false;
                    this.isShowModal = true;
                }
                else {
                    this.saveFile();
                }
            })
            .catch(error => {
                // Handle error
            });
    }

    handleConfirmUpload() {
        this.isLoaded = true;
        this.isShowModal = false;
        this.handleGetListWorkshift();
        setTimeout(() => {
            this.saveFile();
        }, 10000);
        

    }
    async handleGetListWorkshift() {
        try {
            const result = await getWorkShipline({ month: this.selectedValueMonth, yearImport: this.selectedValueYear, partner: this.selectedValuePartner });
            if (result.length > 0) {
                this.roundedNumber = Math.ceil(result / 9000);
                const deletePromises = [];
                for (let i = 0; i < 5; i++) {
                    const promise = deleteWorkShipLine({ month: this.selectedValueMonth, yearImport: this.selectedValueYear, partner: this.selectedValuePartner });
                    deletePromises.push(promise);
                }
                await Promise.all(deletePromises);
            }
            return true;
        } catch (error) {
            // Handle error
            console.error('Error:', error);
            return false;
        }
    }

    hideModalBox() {
        this.isShowModal = false;
    }


    saveFile() {
        this.isLoaded = true;
        this.isShowModal = false;

            try {
                const rows = this.fileContents.split('\n');
                const promises = [];

                for (let i = 0; i < rows.length; i++) {
                    const row = rows[i].trim();
                    if (row !== '') {
                        const promise = saveFile({
                            base64Data: row,
                            month: this.selectedValueMonth,
                            yearImport: this.selectedValueYear,
                            partner: this.selectedValuePartner
                        })
                            .then(result => {
                                if (result === null || result.length === 0) {
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Warning',
                                            message: 'The CSV file does not contain any data',
                                            variant: 'warning',
                                        }),
                                    );
                                }
                                else {
                                    this.workManagerment = [...this.workManagerment, ...result];
                                    this.dataManagerMent = this.workManagerment;
                                }
                            })
                            .catch(error => {
                                console.error(error);
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Error while uploading File',
                                        message: error.message,
                                        variant: 'error',
                                    }),
                                );
                            });

                        promises.push(promise);
                    }
                }

                Promise.all(promises)
                    .then(() => {
                        this.handleCheckDuplicateAgent();
                    })
                    .finally(() => {
                        this.isLoaded = false;
                    });
            } catch (error) {
                console.error(error);
                this.isLoaded = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'An unexpected error occurred.',
                        variant: 'error',
                    }),
                );
            }
    }

    handleCheckDuplicateAgent() {
        showWorkShipDup({ lstWorkManagement: this.dataManagerMent })
            .then(result => {
                if (result.length > 0) {
                    this.isLoaded = false;
                    this.isShowModal = false;
                    this.dataDuplicate = result[0].lstWorkShipDup;
                    this.isTrue = true;
                } else {
                    this.handleShowSlotByAgent();
                }
            })
            .catch(error => {
                // Handle error
            });

    }

    handleShowSlotByAgent() {
        this.isLoaded = true;
        handleShowSlotWorkshift({ month: this.selectedValueMonth, yearImport: this.selectedValueYear, partner: this.selectedValuePartner, lstWorkManagement: this.dataManagerMent })
            .then(result => {
                if (result.length > 0) {
                    this.isShowModal = false;
                    result.forEach(ele => {
                        ele.format = ele.userMissing < 0 ? 'slds-text-color_error background-red' : 'slds-text-color_success';
                        if (ele.userMissing < 0) {
                            this.isShowButtonImport = false;
                        }
                    });
                    this.data = result;
                    this.isTrue = true;
                    this.isLoaded = false;
                } else {
                    this.isLoaded = true;
                    this.handleShowSlotByAgent();
                }
            })
            .catch(error => {
                // Handle error
            });
    }
    handleReupload() {


        this.isLoaded = true;
        this.handleGetListWorkshift();

        setTimeout(() => {
            window.location.reload();
        }, 10000);

        this.isLoaded = false;
    }

    handleReuploadShift() {
        this.handleGetListWorkshift();
        setTimeout(() => {
            window.location.reload();
        }, 10000);

    }

    handleCreateWorkShip() {
        this.isLoaded = true;
        handleCreateWorkShip({ lstWorkManagement: this.workManagerment, partner: this.selectedValuePartner })
            .then(result => {
                this.isLoaded = false;
                var url = window.location.href;
                var value = url.substr(0, url.lastIndexOf('/') + 1);
                window.history.back();
                this.fileName = this.fileName + ' – Uploaded Successfully';
                this.isTrue = false;
                this.isLoaded = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: this.filesUploaded[0].name + ' – Uploaded Successfully!!!',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                // Handle error
            });
    }
}