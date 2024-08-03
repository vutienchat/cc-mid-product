import { LightningElement, api, track } from 'lwc';
import getCalls from '@salesforce/apex/MBFPhoneController.getCalls';

export default class CallStatistics extends LightningElement {
  calls =[];
  rowsLoading= Array.from({length: 7}, (_, i) => i + 1)
  @track loading= false
  @track isLastPage = false
  @api agentId
  @api isEnableClickToDial
  filter={
    state:0,
    pageNumber:1,
    pageSize:30
  }

  get options() {
    return [
        { label: 'Tất cả', value: '0' },
        { label: 'Cuộc gọi nhỡ', value: '1' },
        { label: 'Cuộc gọi tiếp nhận', value: '2' },
    ];
  }

  get disabledCall(){
    return !this.isEnableClickToDial;
  }

  get isEmpty() {
    return !this.loading && (!this.calls || this.calls.length === 0);
  }

  connectedCallback(){
    this.handleGetCalls()
  }

  handleGetCalls(noLoading){
    if(this.isLastPage) return 
    if(!noLoading) this.loading=true
    getCalls({...this.filter,agentId:this.agentId}).then((res)=>{
      if(res){
        const oldCalls = noLoading ? [] : this.calls
        const {responseData}= res
        const newCalls= responseData.content||[]
        this.isLastPage = responseData.last
        this.calls= [ ...oldCalls,...newCalls] 
        this.filter={...this.filter,pageNumber: this.filter.pageNumber+1}
      }
    })
    .catch((err)=>{
      console.log(err)
    })
    .finally(()=>{
      if(!noLoading) this.loading=false;
    })
  }

  handleScrollTable(e){
    const { clientHeight, scrollTop, scrollHeight } = e.target
    if(scrollTop + clientHeight >= scrollHeight - 300 && !this.loading){
      this.handleGetCalls()
    }
  }

  handleChangeTypeCall(event){
    this.filter={
      state:event.detail.value,
      pageNumber:1,
      pageSize:30
    }
    this.calls=[]
    this.isLastPage= false
    this.handleGetCalls()
  }

  @api 
  handleRefreshCalls(){
    this.filter={
      state:this.filter.state,
      pageNumber:1,
      pageSize:30
    }
    this.isLastPage= false
    this.handleGetCalls(true)
  }
}