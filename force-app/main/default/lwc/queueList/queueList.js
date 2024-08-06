import { LightningElement, api } from 'lwc';
import getListAgentQueue from '@salesforce/apex/MBFPhoneController.getListAgentQueue';

export default class QueueList extends LightningElement {
  listAgentQueue=[]
  @api agentId
  @api activeTab 

  getListQueue(){
    getListAgentQueue({agentId:this.agentId}).then((res)=>{
      this.listAgentQueue = res?.responseData ||[]
    }).catch((err)=>{
      console.log(err)
    }).finally(()=>{
      // return setTimeout(()=>{
      //     console.log('CALL')
      // },1000)
    })
  }

  startGetListQueueInterval(){
    return setInterval(()=>{
      if(this.activeTab ==='queueList'){
        this.getListQueue()
      }
    },5000)
  }

  connectedCallback(){
    this.getListQueue()
    document.addEventListener('visibilitychange',()=>{
      if(document.hidden){
        window.clearInterval(this.delayTimeout);
      }else{
        this.delayTimeout= this.startGetListQueueInterval()
      }
    })
    this.delayTimeout= this.startGetListQueueInterval()
  }
}