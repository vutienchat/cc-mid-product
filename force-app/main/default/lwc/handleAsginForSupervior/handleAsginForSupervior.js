import { LightningElement, track, wire } from 'lwc';
import getOptionUnits from '@salesforce/apex/HandleAsignSuperviorLWC.getOptionUnits';
import getOptionTeams from '@salesforce/apex/HandleAsignSuperviorLWC.getOptionTeams';
import getTemplate from '@salesforce/apex/HandleAsignSuperviorLWC.getTemplate';
import getOptionAgents from '@salesforce/apex/HandleAsignSuperviorLWC.getOptionAgents';
import getOptionSupervisor from '@salesforce/apex/HandleAsignSuperviorLWC.getOptionSupervisor';
import getDataList from '@salesforce/apex/HandleAsignSuperviorLWC.getDataList';
import asignData from '@salesforce/apex/HandleAsignSuperviorLWC.asignData';
import getOptionTypes from '@salesforce/apex/HandleAsignSuperviorLWC.getOptionTypes';
import getOptionReason from '@salesforce/apex/HandleAsignSuperviorLWC.getOptionReason';
import getRecordTypeOfCase from '@salesforce/apex/HandleAsignSuperviorLWC.getRecordTypeOfCase';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HandleAsignForSupervior extends LightningElement {
    @track isModalOpen = false;
    @track isModalOpen2 = false;
    @track isLoading = false;
    @track isAsign = false;
    @track isTaskChecked = false;
    // @track isAsignTwoChecked = false;
    @track asignTwo = false;
    @track selectedRows = [];
    @track sortedBy;
    @track sortDirection;
    @track columns = [
        { label: 'Số thuê bao', fieldName: 'phone', sortable: "true" },
        { label: 'Kênh tiếp nhận', fieldName: 'type', sortable: "true" },
        { label: 'Loại', fieldName: 'typeTask', sortable: "true" },
        { label: 'Ngày kết thúc', fieldName: 'endDay', sortable: "true", hidden: true },
        { label: 'Ngày tiếp nhận', fieldName: 'startDay', sortable: "true" },
        { label: 'Trạng thái', fieldName: 'status', sortable: "true" },
        { label: 'Thời gian bắt đầu', fieldName: 'startTime', sortable: "true" },
        { label: 'Thời gian kết thúc', fieldName: 'endTime', sortable: "true" },
        { label: 'Thời lượng', fieldName: 'duration', sortable: "true" },
        { label: 'Người tiếp nhận', fieldName: 'owner', sortable: "true" },
        { label: 'ID', fieldName: 'id', sortable: "true", hidden: true  },
        { label: 'ID_Agent', fieldName: 'idAgent', hidden: true }
    ];
    get visibleColumns() {
        let visibleCols = this.columns.filter(column => !column.hidden);
        if (this.asignTwo) {
            const superviorColumn = { label: 'Giám sát viên 1', fieldName: 'supervior_1' };
            visibleCols = this.insertAtIndex(visibleCols, superviorColumn, 8);
        }
        return visibleCols; 
    }
    insertAtIndex(array, element, index) {
        return [...array.slice(0, index), element, ...array.slice(index)];
    }
    @track options = [];
    @track optionTeams = [];
    @track optionsType = [];
    @track optionsAgent = [];
    @track optionSupervior = [];
    @track optionTemplate = [];
    @track optionReason = [];
    @track optionRecordTypeCase = [];
    @track searchQuery = {
        unit: '',
        team: '',
        type: '',
        supervisor: '',
        agent: '',
        zalo: false,
        facebook: false,
        task: false,
        chatbot: false,
        agentLevel: '',
        percentOfData: 100,
        timeCall: null,
        timeStart: null,
        timeEnd: null,
        reason: null,
        numberCall: -1,
        caseType: null
    };
    @track showError = {
        percentOfData: null,
        unit: null,
        channel: null,
        timeStart: null,
        timeEnd: null
    };
    @track asignData = {
        template: '',
        supervior: '',
        timeAsign: '',
        exprieDate: '',
    };
    @track dataList = [];
    totalCount = 0;
    selectedUnitId = '';
    currentDateTime;

    connectedCallback() {
        let now = new Date();
        this.currentDateTime = now.toISOString().slice(0, 16);
        this.searchQuery.timeStart = now.toISOString();
        this.searchQuery.timeEnd = now.toISOString();
        this.asignData.exprieDate = now.toISOString();
    }
    @wire(getDataList)
    wiredDataList(result) {
        if (result.data) {
            this.data = result.data;
            this.totalCount = result.data.length;
            // this.error = undefined;
        } else if (result.error) {
            // this.error = result.error;
            // this.data = undefined;
            console.error('Error fetching data list:', result.error);
        }
    }
    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        this.sortedBy = sortedBy;
        this.sortDirection = sortDirection;
        this.sortData(sortedBy, sortDirection);
        // this.sortBy = event.detail.fieldName;
        // this.sortDirection = event.detail.sortDirection;
        // this.sortData(this.sortBy, this.sortDirection);
        // this.handleGetDataList();
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.dataList));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.dataList = parseData;
    }

    @wire(getOptionAgents, { idUnit: '$selectedUnitId', type: '1' })
    wiredUnitAgents({ error, data }) {
        if (data) {
            this.optionsAgent = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.optionsAgent.unshift({ label: 'Chọn nhân viên', value: '' });
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }
    
    @wire(getOptionUnits)
    wiredOptionsUnits({ error, data }) {
        if (data) {
            this.options = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.options.unshift({ label: 'Chọn đơn vị', value: '' });
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    @wire(getOptionTeams)
    wiredOptionsTeams({ error, data }) {
        if (data) {
            this.optionTeams = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.optionTeams.unshift({ label: 'Chọn tổ', value: '' });
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    @wire(getOptionTypes)
    wiredOptionsTypes({ error, data}) {
        if(data) {
            this.optionsType = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.optionsType.unshift({ label: 'Chọn loại', value: ''});
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    @wire(getTemplate)
    wiredOptionsTemplate({ error, data }) {
        if (data) {
            this.optionTemplate = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            if(this.optionTemplate.length > 0){
                this.asignData.template = this.optionTemplate[0].value;
            } else {
                this.optionTemplate.unshift({ label: 'Chọn template', value: '' });
            }
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    @wire(getOptionSupervisor, { idUnit: '', type: '2' })
    wiredSupervisors({ error, data }) {
        if (data) {
            this.optionSupervior = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.optionSupervior.unshift({ label: 'Chọn giám sát viên', value: '' });
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    @wire(getOptionReason)
    wiredOptionsReason({ error, data }) {
        if (data) {
            this.optionReason = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.optionReason.unshift({ label: 'Chọn mục đích cuộc gọi', value: '' });
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    @wire(getRecordTypeOfCase)
    wiredOptionRecordTypeCase({ error, data }) {
        if (data) {
            this.optionRecordTypeCase = data.map(option => ({
                label: option.Label,
                value: option.Value
            }));
            this.optionRecordTypeCase.unshift({ label: 'Chọn loại yêu cầu', value: '' });
        } else if (error) {
            console.error('Error fetching options:', error);
        }
    }

    
    handleCheckboxChange(event) {
        let attribute = event.target.value;
        // alert(attribute);
        this.searchQuery[attribute] = event.target.checked;
        let { zalo, facebook, task, chatbot } = this.searchQuery;
        if (zalo || facebook || task || chatbot) {
            this.showError.channel = null;
        } else {
            this.showError.channel = 'Kênh tìm kiếm không được để trống';
        }
        if (attribute === 'task') {
            this.isTaskChecked = event.target.checked;
        }
        if (attribute === 'asign-two') {
            this.asignTwo = event.target.checked;
        }
    }

    handleChange(event) {
        const attribute = event.target.dataset.customAttribute;
        const value = event.target.value;
        switch (attribute) {
            case 'unit':
                this.selectedUnitId = value;
                this.showError.unit = value === '' ? 'Đơn vị không được để trống' : null;
                if (!this.showError.unit) {
                    this.searchQuery[attribute] = value;
                }
                break;
    
            case 'percentOfData':
                this.showError.percentOfData = value > 100 ? 'Giá trị phải nhỏ hơn hoặc bằng 100' : null;
                if (!this.showError.percentOfData) {
                    this.searchQuery[attribute] = value;
                }
                break;
    
            case 'supervisor':
                if (this.asignTwo) {
                    this.searchQuery.supervisor = value;
                }
                break;
    
            case 'timeStart':
                console.log('timestart' + value);
                console.log(this.showError.timeStart = value == null);
                this.showError.timeStart = value == null ? 'Thời gian bắt đầu không được bỏ trống' : null;
                if (!this.showError.timeStart) {
                    this.searchQuery[attribute] = value;
                }
                console.log(this.showError.timeStart);
                break;
            case 'timeEnd':
                this.showError.timeEnd = value == null ? 'Thời gian kết thúc không được bỏ trống' : null;
                if (!this.showError.timeEnd) {
                    this.searchQuery[attribute] = value;
                }
                break;
    
            default:
                this.searchQuery[attribute] = value;
                break;
        }
    
        // Check for time validation if both timeStart and timeEnd are set
        // if (this.searchQuery.timeEnd && this.searchQuery.timeStart) {
        //     this.showError.timeStart = null;
        //     this.showError.timeEnd = null;
        //     if (this.searchQuery.timeEnd < this.searchQuery.timeStart) {
        //         this.showError.timeStart = 'Thời gian kết thúc phải lớn hơn thời gian bắt đầu';
        //         this.showError.timeEnd = 'Thời gian kết thúc phải lớn hơn thời gian bắt đầu';
        //     } 
        // }
    
        console.log(this.showError.timeStart);
    }
    
    
    handleChangeAsign(event){
        let attribute = event.target.dataset.customAttribute;
        this.asignData[attribute] = event.target.value;
    }

    handleChangeAsignTime(){
        console.log('changeTime called');
        let letOldData = this.asignTwo;
        this.asignTwo = !letOldData;
        this.dataList = [];
        this.totalCount = 0;
       
    }

    handleGetDataList() {
        console.log('handleGetDataList called');
        console.log(this.searchQuery.numberCall);
        if (this.searchQuery.unit !== '' && (this.searchQuery.zalo || this.searchQuery.facebook || this.searchQuery.task || this.searchQuery.chatbot) && this.searchQuery.timeStart && this.searchQuery.timeEnd) {
            this.isLoading = true;
            getDataList({ request: this.searchQuery, checkTime: this.asignTwo})
                .then(result => {
                    console.log('Data List:', result);  // Kiểm tra dữ liệu trả về
                    this.dataList = result;
                    this.totalCount = result.length;
                })
                .catch(error => {
                    console.error('Error fetching data list:', error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        } else {
            if(this.searchQuery.unit === ''){
                this.showError.unit = 'Đơn vị không được để trống';
            }
            if(!(this.searchQuery.zalo || this.searchQuery.facebook || this.searchQuery.task || this.searchQuery.chatbot)){
                this.showError.channel = 'Kênh tìm kiếm không được để trống';
            }
            this.showNotification('Chưa chọn tiêu chí', 'Vui lòng chọn những tiêu chí cần thiết để thực hiện thao tác', 'error');
            return;
        }
    }

    handleRowSelection(event) {
        let newSelectedRows = event.detail.selectedRows.map(row => ({
            id: row.id,
            typeObject: row.type,
            idAgent: row?.idAgent ? row.idAgent : '' 
        }));
        console.log(newSelectedRows);
        // Update the selectedRows array
        this.selectedRows = this.selectedRows.filter(row => 
            newSelectedRows.some(newRow => newRow.id === row.id)
        );
    
        newSelectedRows.forEach(newRow => {
            if (!this.selectedRows.some(row => row.id === newRow.id)) {
                this.selectedRows.push(newRow);
            }
        });
    }
    

    handleOpenModal() {
        if (this.selectedRows.length === 0) {
            this.showNotification('Chưa chọn bản ghi', 'Vui lòng chọn bản ghi để thực hiện thao tác', 'warning');
        } else {
            this.isModalOpen = true;
        }
    }

    handleCloseModal(){
        this.isModalOpen = false;
    }

    handleOpenModal2() {
        if (this.selectedRows.length === 0) {
            this.showNotification('Chưa chọn bản ghi', 'Vui lòng chọn bản ghi để thực hiện thao tác', 'warning');
        } else {
            this.isModalOpen2 = true;
        }
    }

    handleCloseModal2(){
        this.isModalOpen2 = false;
    }

    async handleAssign() {

        // Validate input fields
        if (this.asignData.template === '') {
            this.showNotification('Chưa chọn biểu mẫu chấm điểm', 'Vui lòng chọn bản ghi để thực hiện thao tác', 'error');
            return;
        }
        if (this.asignData.supervior === '') {
            this.showNotification('Chưa chọn GSV', 'Vui lòng chọn giám sát viên thực hiện thao tác', 'error');
            return;
        }
        // Proceed with the assign action if validations are successful
        if (this.asignData.template !== '' && this.asignData.supervior !== '') {
            this.isAsign = true;
            this.asignData.timeAsign = '1';
        
            // Perform the assignment action
            await asignData({ selectData: this.selectedRows, data: this.asignData })
                .then(result => {
                    if (result) {
                        this.showNotification('Thành công', 'Bạn đã thực hiện thành công', 'success');
                    } else {
                        this.showNotification('Có lỗi', 'Vui lòng thử lại sau', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error fetching data list:', error);
                    this.showNotification('Có lỗi', 'Vui lòng thử lại sau', 'error');
                })
                .finally(() => {
                    // refreshApex(this.dataList);
                    this.removeSelectedRowsAndUpdateList();
                    this.asignData.supervior = null;
                    this.isAsign = false;
                    this.selectedRows = [];
                    this.isModalOpen = false;
                });
        }
    }

    async handleAssign2() {
        // Prevent the default form submission behavior
        if (this.asignData.supervior === '') {
            this.showNotification('Chưa chọn GSV', 'Vui lòng chọn giám sát viên thực hiện thao tác', 'error');
            return;
        }
        if (this.asignData.supervior !== '') {
            this.isAsign = true;
            this.asignData.timeAsign = '2';
            // Perform the assignment action
            await asignData({ selectData: this.selectedRows, data: this.asignData })
                .then(result => {
                    if (result) {
                        this.showNotification('Thành công', 'Bạn đã thực hiện thành công', 'success');
                        this.han
                    } else {
                        this.showNotification('Có lỗi', 'Vui lòng thử lại sau', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error fetching data list:', error);
                    this.showNotification('Có lỗi', 'Vui lòng thử lại sau', 'error');
                })
                .finally(() => {
                    this.removeSelectedRowsAndUpdateList();
                    this.asignData.supervior = null;
                    this.selectedRows = [];
                    this.isAsign = false;
                    this.isModalOpen2 = false;
                });
        }
    }

    showNotification(title, message, variant) {
        let evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    removeSelectedRowsAndUpdateList() {
        this.dataList = this.dataList.filter(dataRow => 
            !this.selectedRows.some(selectedRow => selectedRow.id === dataRow.id)
        );
        this.totalCount = this.dataList.length;
        this.handleGetDataList();
        refreshApex(this.dataList);
    }
}