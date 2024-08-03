import { LightningElement, api, wire } from 'lwc';
import searchAgents from '@salesforce/apex/MBFPhoneController.searchAgents';
import getListAgentStatus from '@salesforce/apex/MBFPhoneController.getListAgentStatus';

export default class TransferCall extends LightningElement {
    users=[]
    searchKey=''
    loading= true
    rowsLoading= Array.from({length: 10}, (_, i) => i + 1)
    @api agent

    @wire(searchAgents,{ searchKey: '$searchKey' })
     wiredAgents({ error, data }) {
        if (data && Array.isArray(data)) {
          (async()=>{
            try {
              let convertCheckAgents
              let convertListAgentStatus
              const results = []
              const agentIds =[]
              const promiseAllCheckAgentAS7 =[]
              // const newData=[]
              for (let i = 0; i < data.length; i++) {
                const extensionId = data[i].extensionId
                const agentId = data[i].agentId
                const phone = this.getPhoneNumber(extensionId)
                if(phone){
                  agentIds.push(agentId)
                  promiseAllCheckAgentAS7.push(this.checkAgentOnline(extensionId,agentId))
                  // newData.push(data[i])
                }
              }

              await Promise.all(promiseAllCheckAgentAS7).then(agents=>{
                if(Array.isArray(agents)){
                  convertCheckAgents = agents.reduce((acc,agent)=>{
                    acc[agent.agentId]=agent.status;
                    return acc
                  },{})
                }
              })

              await getListAgentStatus({body:JSON.stringify({agentIds})}).then(data=>{
                if(Array.isArray(data.responseData)){
                  convertListAgentStatus = data.responseData.reduce((acc,agent)=>{
                    acc[agent.agentId]={...agent};
                    return acc
                  },{})
                }
              })
              // Busy,Ring
              for (let i = 0; i < data.length; i++) {
                const extensionId = data[i].extensionId
                const agentId = data[i].agentId
                const phone = this.getPhoneNumber(extensionId)
                if(phone){
                  const isFree = convertListAgentStatus[agentId]?.workplaceState !== 'Busy' && convertListAgentStatus[agentId]?.workplaceState !== 'Ring'
                    const disabled = isFree && convertCheckAgents[agentId] ? false : true
                    results.push({
                      ...data[i],
                      workplaceState: convertListAgentStatus[agentId]?.workplaceState || 'logoff',
                      extensionId:phone,
                      disabled,
                      transferredAgentId:agentId,
                      class: disabled ? '' : 'btn-active'
                    });
                }
              }
              this.users = results;
            } catch (error) {
              console.log('error',error);
            } finally {
              this.loading=false
            }
          })()
        }
    }

    checkAgentOnline(extensionId,agentId){
      return new Promise(resolve=>{
        const device = this.agent.getDevice(extensionId)
        device.getPresenceState().then(({presenceState}) => resolve({agentId,status:presenceState.offline ? false : true}))
        .catch(()=>{
           resolve({agentId,status:false})
        })
      })
    }
    
    @api
    handleCloseTransferCall = () => {
      const newEvent = new CustomEvent("toggletransfercall",{detail:false})
      this.dispatchEvent(newEvent)
    }

    getPhoneNumber(extensionId){
      const regex = /sip:(\d+)@/;
      const match = extensionId?.match(regex);
      return match ? match[1] : null
    }

    @api
    handleTransferCall(event){
      const transferredAgentId = event.currentTarget.dataset.transferredAgentId
      const extensionId = event.currentTarget.dataset.extensionId
      const newEvent = new CustomEvent("transfercall",{detail:{extensionId,transferredAgentId}})
      this.dispatchEvent(newEvent)
    }

    handleSearchAgrent(event) {
      window.clearTimeout(this.delayTimeout);
      const searchKey = event.target.value;

      this.delayTimeout = setTimeout(() => {
          this.searchKey = searchKey;
      }, 300);
  }
}