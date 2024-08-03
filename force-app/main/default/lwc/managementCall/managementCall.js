import { LightningElement, api, track, wire } from 'lwc';
import getAgentByRegion from '@salesforce/apex/MBFPhoneController.getAgentByRegion';
import getListAgentStatus from '@salesforce/apex/MBFPhoneController.getListAgentStatus';

export default class ManagementCall extends LightningElement {
    @api device
    @track loading= false
    listAgentByRegion=[]

    get isEmpty() {
        return !this.loading &&  this.listAgentByRegion.length===0;
    }

    getPhoneNumber(extensionId){
        const regex = /sip:(\d+)@/;
        const match = extensionId?.match(regex);
        return match ? match[1] : null
      }

    async getList(){
        try {
            this.loading= true
            const data=  await getAgentByRegion()
            if(Array.isArray(data)){
                const newList =[]
                const agentIds =[]
                let convertListAgentStatus
                const results = []
                for (let i = 0; i < data.length; i++) {
                    const extensionId = data[i].extensionId
                    const agentId = data[i].agentId
                    const phone = this.getPhoneNumber(extensionId)
                    if(phone){
                        // promiseAllCheckAgentAS7.push(this.checkAgentOnline(extensionId,agentId))
                        newList.push({...data[i],phone})
                        agentIds.push(agentId)
                    }
                }
                
                await getListAgentStatus({body:JSON.stringify({agentIds})}).then(data=>{
                    if(Array.isArray(data.responseData)){
                        convertListAgentStatus = data.responseData.reduce((acc,agent)=>{
                            acc[agent.agentId]={...agent};
                            return acc
                        },{})
                    }
                })

                for (let i = 0; i < data.length; i++) {
                    const extensionId = data[i].extensionId
                    const agentId = data[i].agentId
                    const agentStatus= convertListAgentStatus[agentId]?.agentStatus
                    const workplaceState =  convertListAgentStatus[agentId]?.workplaceState
                    const phone = this.getPhoneNumber(extensionId)
                    if(phone){ 
                        results.push({
                        ...data[i],
                        phone,
                        workplaceState: workplaceState || 'logoff',
                        agentStatus:workplaceState ==='Busy'?'Đang trong cuộc gọi': agentStatus==='$Cmn_Ready'? 'Sẵn sàng': 'Không sẵn sàng',
                        disabled: convertListAgentStatus[agentId]?.workplaceState !== 'Busy'
                    });
                    }
                  }
                this.listAgentByRegion=results
            }
        } catch (error) {
            console.log(error)
        }
        finally{
            this.loading= false
        }
      }

      startGetAgentByRegionInterval(){
        return setInterval(() => {
            this.getList()  
        }, 10000);
      }

    connectedCallback(){
        this.getList()
        document.addEventListener('visibilitychange',()=>{
            if(document.hidden){
              window.clearInterval(this.delayTimeout);
            }else{
              this.delayTimeout= this.startGetAgentByRegionInterval()
            }
          })
          this.delayTimeout= this.startGetAgentByRegionInterval()
    }

    handleMakeCall(event){
        const phoneNumber = event.currentTarget.dataset.phoneNumber
        const agentName = event.currentTarget.dataset.agentName
        const options={
            autoOriginate: "doNotPrompt",
            subjectOfCall: event.detail.value,
            audio: true,
            video: false
        }
        const newEvent = new CustomEvent("supervisormakecall",{detail:{phoneNumber,agentName,options}})
        this.dispatchEvent(newEvent)
    }
}