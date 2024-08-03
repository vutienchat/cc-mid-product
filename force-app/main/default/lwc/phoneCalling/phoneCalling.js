import { LightningElement, api, track, wire } from 'lwc';

export default class PhoneCalling extends LightningElement {
   @track timeCalling = ''
   @track holdCallTime=''
   @api callInfo
   isMuted = false
   @api isAcceptedCall
   @api isHoldCall
   @api penddingOutboundCall
   @api currentCall
   @track intervalTimeCallId
   @track intervalTimeHoldId

   connectedCallback(){
    console.log('connectedCallback',this.callInfo?.Id)
   }

   get disabledActions(){
    return !this.isAcceptedCall
   }


   get getClassHoldCall(){
    return this.currentCall?.localConnectionInfo === 'hold' ? 'btn-border-radius border active-hold':'btn-border-radius border'
   }
   
   get nameIcon(){
    return this.isMuted ? 'utility:muted': 'utility:unmuted'
   }

   get getClassMutedByStatus(){
    return this.isMuted ? 'btn-border-radius border active-muted': 'btn-border-radius border'
   }

   disconnectedCallback(){
    if(this.intervalTimeCallId){
      clearInterval(this.intervalTimeCallId)
      this.intervalTimeCallId = null
      this.timeCalling=''
    }
    this.endCalculateHoldCallTime()
    this.isMuted=false;
   }


   @api
    handleUnCalling = () => {
      if(!this.penddingOutboundCall){
        const event = new CustomEvent("uncalling")
        this.dispatchEvent(event)
      }
    }

   @api
   startCalculateCallTime(){
    console.log('start')
      let currentTime=0
      this.intervalTimeCallId = setInterval(()=>{
        this.timeCalling=this.formatTime(currentTime++)
      }, 1000);
   }

   startCalculateHoldCallTime = () => {
    let currentTime=0
    this.intervalTimeHoldId = setInterval(()=>{
      this.holdCallTime=this.formatTime(currentTime++)
    }, 1000);
  }

  endCalculateHoldCallTime(){
    if(this.intervalTimeHoldId){
      clearInterval(this.intervalTimeHoldId)
      this.intervalTimeHoldId = null
      this.holdCallTime=''
    }
  }

    formatTime(seconds) {
      const hour = seconds / 60 / 60;
      const minute = seconds / 60 % 60;
      const Second = seconds % 60;
      return [
        parseInt(hour) || null,
        parseInt(minute),
        parseInt(Second)
      ]
      .filter((time)=> time !== null)
      .join(":")
      .replace(/\b(\d)\b/g, "0$1")
    }

   @api
   handleToggleMutedCall = () => {
    // const event = new CustomEvent("togglemutedcall")
    // this.dispatchEvent(event)
    if(!this.currentCall) return 
      this.currentCall.updateCall({ 
        audio: this.isMuted,
        video: true,
      }).then(()=>{
        this.isMuted = !this.isMuted
      });
   }

  @api
  handleOpenTransferCall = () => {
    const newEvent = new CustomEvent("toggletransfercall",{detail:true})
    this.dispatchEvent(newEvent)
  }

  
  handleHoldCall = () => {
    if(!this.currentCall) return 
      if(this.currentCall.localConnectionInfo === 'hold'){
        this.currentCall.retrieveCall()
        this.endCalculateHoldCallTime()
      }else{
        this.currentCall.holdCall()
        this.startCalculateHoldCallTime()
      }
  }
   
}