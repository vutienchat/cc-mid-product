import { LightningElement, api ,track} from 'lwc';
import wssAS7 from '@salesforce/label/c.wssAS7';
import passwordAS7 from '@salesforce/label/c.passwordAS7';
import usernameAS7 from '@salesforce/label/c.usernameAS7';
import OutboundListId from '@salesforce/label/c.OutboundListId';

import anCti from "@salesforce/resourceUrl/ancti";
import { loadScript } from "lightning/platformResourceLoader";
import ringingInbound from '@salesforce/resourceUrl/ringingInbound';

import getUser from '@salesforce/apex/MBFPhoneController.getUser';
import updateTask from '@salesforce/apex/MBFPhoneController.updateTask';
import getPbxCallId from '@salesforce/apex/MBFPhoneController.getPbxCallId';
import OutboundCall from '@salesforce/apex/MBFPhoneController.OutboundCall';
import getCallLogByCallId from '@salesforce/apex/MBFPhoneController.getCallLog';
import saveTransferCall from '@salesforce/apex/MBFPhoneController.saveTransferCall';
import createCallRecord from '@salesforce/apex/MBFPhoneController.createCallRecord';
import autoCreateCaseByPhone from '@salesforce/apex/MBFPhoneController.autoCreateCase';
import getInfoCallByPhone from '@salesforce/apex/MBFPhoneController.getInfoCallByPhone';
import getAgentStatus from '@salesforce/apex/HandleClockInAndClockOutForAgent.getAgentStatus';

const PHONE_STATUS = {
  DIALPAD: 'dialpad',
  INBOUND: 'Inbound',
  CALLING: 'calling'
};

const PERSONAL_INFO= 'personalInfo'

export default class App extends LightningElement {
  @api device = null;
  audioRinging = new Audio(ringingInbound)
  scriptLoaded = false;
  activeTab
  phoneStatus= PHONE_STATUS.DIALPAD
  connected=false
  isTransferCall=false
  // @track hiddenTabBrowser=false
  @track connecting=true
  @track message=''
  @track pbxCallId = ''
  @track user=null
  @track isOutboundCall=false
  @track isCalculatingCallTime=false
  @api isExpand
  @api isRinging=false
  @api isAcceptedCall=false
  @api isEnableClickToDial
  @api agentStatus=false
  @api phoneNumber=''
  @api callInfo={}
  @api callAccount={}
  @api caseId=''
  @api taskId= ''
  @api penddingOutboundCall= false
  @api agent= null
  @api currentCall= null

  get isDialpad(){
    return this.phoneStatus===PHONE_STATUS.DIALPAD
  }

  get isInbound(){
    return this.phoneStatus===PHONE_STATUS.INBOUND
  }

  get isCalling(){
    return this.phoneStatus===PHONE_STATUS.CALLING
  }

  get getClass(){
    return this.isExpand?'layout-phone-content-wrapper show': 'layout-phone-content-wrapper'
  }

  get showTabInfo(){
    return Boolean(this.callInfo?.Id)
  }

  get isServicesManager(){
    return this.user.profileName === 'Services Manager'
  }

  // connectedCallback(){
  //   window.addEventListener("beforeunload", function (e) {
  //     e.preventDefault();
  //     e.returnValue = "";
  //     alert("abc");
  //     return "";
  //   });
  // }

  renderedCallback(){
    if(this.showTabInfo){
        this.template.querySelector('c-tabs').handleShowTab(PERSONAL_INFO)
    };
    if(!this.scriptLoaded){
      Promise.all([
        loadScript(this, anCti ),
      ])
      .then(() => {
        this.scriptLoaded = true;
        this.initializeAgent();
      })
      .catch(error => {
        console.log('anCti error', error)
      })
    }
  }  

  handleRetry(){
    this.initializeAgent()
  }
	
  initializeAgent(){
    this.connecting=true
    const anCti = window.AnCti;
    const agent = anCti.newAgent();
    if(!wssAS7 || !usernameAS7 || !passwordAS7){
      this.connecting=false
      this.connected=false
      this.message= 'Không tìm thấy wssAS7 hoặc usernameAS7 hoặc passwordAS7'
      return;
    }
    let audio = new Audio();
    audio.autoplay = true;
    agent.startApplicationSession({
      url:wssAS7,
      username: usernameAS7,
      password: passwordAS7
  });

    agent.on("applicationsessionterminated", (event) => { 
      if (event.reason=="invalidApplicationInfo") {
      console.log("Please check your credentials and try again");
      this.connecting=false
      this.connected=false
      this.message= 'Kiểm tra lại user name và password AS7'
      }
    });
    
    agent.on("applicationsessionstarted", (event) => {
      (async()=>{
        try {
          const user = await getUser()
          if(user){
            this.user=user;
            const agentStatus = await getAgentStatus({idAgent:user.agentId})
            this.agentStatus = agentStatus.responseData.agentStatus === '$Cmn_Ready' || 'Outbound'
            const device = agent.getDevice(user.extensionId)
            await device.monitorStart({ rtc: true})
            .then(() =>{
              this.handleEnableClickToDial()
              this.connected=true
            })
            .catch(error => {
              console.log("monitoring failed")
              this.message= `Không thể đăng ký "${user.extensionId}" trên ancti`
              this.connected=false
            })
            this.device = device;
          }else{
            this.message= 'Không tìm thấy extensionId hoặc agentId'
            this.connected=false
          }
        } catch (error) {
          this.message= 'Đã xảy ra lỗi'
          console.log(error)
        }
        finally {
          this.connecting=false
        }
      })()
    });

    agent.on('localstream', (event) => {
      //accept call Outbound
      if(this.isOutboundCall && event.stream && !this.isCalculatingCallTime){
        getPbxCallId({agentId:this.user.agentId}).then(res=>{
        if(res){
          const respose = JSON.parse(res)
          const  pbxCallId = respose?.responseData
          this.pbxCallId = pbxCallId
          updateTask({taskId:this.taskId,pbxCallId})
          const linkage = this.getCall()?.globallyUniqueCallLinkageID
          this.handleCreateCallRecord(pbxCallId,linkage)
        }
        })
        .catch(err=>{
          console.log('getPbxCallId', err)
        })
        this.handleAcceptCall()
      }
    });

    agent.on("remotestream", (event) => {
      this.template.querySelector(".remoteView").srcObject = event.stream;
      audio.srcObject = event.stream;
    });

    agent.on("call",(event) => {
      let call = event.call;
      this.currentCall=call
      switch (call.localConnectionInfo) {
        case 'alerting': 
          if(!event.call.autoAnswer){
            console.log('alerting',call.name)
            // this.getInfoCall(call.number)
            this.getInfoCall(this.normalizePhoneNumber(call.number))
            this.phoneStatus = PHONE_STATUS.INBOUND;
            this.playRingingInbound()
            this.handleOpenPhoneBar()
            this.handleDisableClickToDial()
          }
          break;
        case 'connected':
          // accept call Outbound
          this.closeRingingInbound()
          this.phoneStatus = PHONE_STATUS.CALLING;
          if(event.call.autoAnswer){
            console.log(`connected outBound ${call.number}`,call.callID,call.globallyUniqueCallLinkageID)
            this.isOutboundCall=true
            this.penddingOutboundCall= false
          }
          // accept call inbound
          if(!event.call.autoAnswer && !this.isCalculatingCallTime){
              console.log(`connected inbound ${call.number}`,call.callID)
              this.handleAcceptCall()
          }
          break;
        case 'fail':
          console.log(`call failed, cause is ${event.content.cause}`);
          break;
        case 'hold':
          console.log(`holding call to ${call.number}`);
          break;
        case 'null':
          console.log(`call to ${call.number} is gone`);
          if(!event.call.autoAnswer == true){
          this.handleNavigatetoCase()
          }
          this.phoneStatus = PHONE_STATUS.DIALPAD;
          if(this.taskId){
            this.getCallLog(this.taskId);
          }
          this.callInfo={};
          this.isOutboundCall=false;
          this.isTransferCall=false;
          this.isCalculatingCallTime= false;
          this.currentCall= null
          //this.pbxCallId = null
          this.closeRingingInbound();
          this.handleEnableClickToDial();
          this.handleUpdateStatisticCalls();
          break;
      }
    });
    this.agent= agent
  }

  getInfoCall(Phone){
    getInfoCallByPhone({Phone}).then((data)=>{
      this.callInfo= data.contact
      this.callAccount = data.contact?.Account ||{}
      this.handleNavigateto()
    })
    .catch((err)=>{
      console.log(err)
      this.callInfo={ Name:'No name', Phone}
    })
  }

  normalizePhoneNumber(phoneNumber) {
    return phoneNumber.replace(/^(?:\+84|84|0)/, '');
  }

  handleCreateCallRecord(callId,globallyUniqueCallLinkageID){
    if(!globallyUniqueCallLinkageID || ! callId) return
    createCallRecord({callId,linkage:globallyUniqueCallLinkageID}).then((res)=>{
      console.log('createCallRecord success',res)
    })
    .catch(err=>{
      console.log(err)
    })
  }

  handleAcceptCall(){
      this.template.querySelector('c-phone-calling').startCalculateCallTime()
      this.isCalculatingCallTime = true
      this.isAcceptedCall=true
  }
	
	autoCreateCase(contactId, Phone, callId){
		autoCreateCaseByPhone({contactId, Phone, callId}).then((data)=>{
		  this.caseId = data.caseId
		  this.taskId = data.taskId
		  this.handleNavigatetoCase()
		})
		.catch((err)=>{
		  console.log(err)
		})
	}
  
  getCallLog(taskId){
		getCallLogByCallId({taskId}).then((data)=>{
		  
		})
		.catch((err)=>{
		  console.log(err)
		})
	}
	
  playRingingInbound(){ 
    if(!this.audioRinging) return

    this.audioRinging.loop = true
    const promise =this.audioRinging.play()
    if (promise !== undefined) {
      promise.then(_ => {
        // Autoplay started!
      }).catch(error => {
        this.isRinging=true
      });
    }
  }

  @api handleOpenMuted(){
    this.isRinging=false
    this.audioRinging?.play()
  }

  closeRingingInbound(){
    if(this.audioRinging){
      this.audioRinging.pause()
      this.audioRinging.currentTime=0
    }
    this.isRinging=false
  }
	
	showToast() {
        const message = {
            title: 'Toast Message from LWC',
            message: 'This is a toast message.',
            variant: 'success'
        };
        publish(this.messageContext, TOAST_MESSAGE_CHANNEL, message);
    }
						
  getCall(){
   return this.device.calls[0]
  }
	
  @api
  handleToggleTransferCall = (event) => {
    this.isTransferCall= event.detail
  }

  handleUpdateStatisticCalls(){
    this.template.querySelector('c-call-statistics').handleRefreshCalls();
  }

  @api 
  handleChangePhoneNumber(value){
      this.phoneNumber = value.detail
  }

  @api 
  handleChangeKeyPress(event){
    // ToastComponent.showToast(event.detail)
    this.phoneNumber = this.phoneNumber + event.detail
  }
  
  @api
  handleExpand(){
    const event = new CustomEvent("expand")
    this.dispatchEvent(event)
  }

  @api
  handleCollapse(){
    const event = new CustomEvent("collapse")
    this.dispatchEvent(event)
  }

  @api
  handleNavigateto(){
    const event = new CustomEvent("navigateto",{detail:{
      id:this.callInfo.Id
    }})
    this.dispatchEvent(event)
  }
	
	@api
  handleNavigatetoCase(){
	  if(this.caseId != undefined && this.caseId != ''){
			const event = new CustomEvent("navigateto",{detail:{
			  id:this.caseId
			}})
			this.dispatchEvent(event)
	  }
  }

  @api
  handleDisableClickToDial(){
    const event = new CustomEvent("disableclicktodial")
    this.dispatchEvent(event)
  }

  @api
  handleEnableClickToDial(){
    if(this.agentStatus){
      const event = new CustomEvent("enableclicktodial")
      this.dispatchEvent(event)
    }
  }

  @api
  handleOpenPhoneBar(){
    const event = new CustomEvent("openphonebar")
    this.dispatchEvent(event)
    this.handleExpand()
  }
	
  @api
  handleMakeCall(event){
    if(this.agentStatus){
      if(event.detail) this.phoneNumber = event.detail;
      if(event.number){
        //ClicktoCall
        this.phoneNumber = event.number;
        this.taskId = event.recordId;
      }
	  
      if(this.phoneNumber && this.user.agentId && !this.penddingOutboundCall){
        this.phoneStatus = PHONE_STATUS.CALLING;
        this.penddingOutboundCall= true
        this.handleOpenPhoneBar()
        this.handleDisableClickToDial()
        // this.getInfoCall(this.phoneNumber)
        this.getInfoCall(this.normalizePhoneNumber(this.phoneNumber))
        this.isAcceptedCall=false
        const body = {
          Number:this.phoneNumber,
          AgentId:this.user.agentId,
          OutboundListId
        }
        OutboundCall({body:JSON.stringify(body),OutboundListId})
        .catch((err)=>{
          this.phoneStatus = PHONE_STATUS.DIALPAD;
          this.penddingOutboundCall= false
          this.handleEnableClickToDial()
          this.callInfo={}
          console.log(err)
        })
      }
    }
  }

  handleSupervisorMakeCall(event){
    const {phoneNumber,agentName,options}= event.detail
    if(phoneNumber){
      this.phoneStatus = PHONE_STATUS.CALLING;
      this.device.makeCall(phoneNumber, options);
      this.callInfo={Name:agentName,Phone:phoneNumber}
    }
  }


  @api
  handleAnswerCall(){
   const call= this.getCall()
   if(call?.localConnectionInfo ==='alerting'){
      call.answerCall({audio:true,video:false}).then(()=>{
        this.phoneStatus = PHONE_STATUS.CALLING;
        let pbxCallId = null
         getPbxCallId({agentId:this.user.agentId}).then(res=>{
          if(res){
            const respose = JSON.parse(res)
            pbxCallId = respose?.responseData
            const linkage = call.globallyUniqueCallLinkageID
            this.pbxCallId = pbxCallId
            this.handleCreateCallRecord(pbxCallId,linkage)
            console.log('handleAnswerCall',pbxCallId,linkage)
          }
          this.autoCreateCase(this.callInfo.Id, call.number, pbxCallId)
        })
        .catch(err=>{
          console.log('getPbxCallId', err)
        })
      })
      this.phoneStatus=PHONE_STATUS.CALLING
   }
  }

  @api
  handleUnCalling(){
   const call= this.getCall()
   call?.clearConnection();
   this.phoneStatus=PHONE_STATUS.DIALPAD
  }

  @api
  handleTransferCall(event){
    const call= this.getCall()
    const {transferredAgentId,extensionId}= event.detail
    call.singleStepTransferCall(extensionId).then((res)=>{
      const body = {
        firstAgentId: this.user.agentId,
        transferredAgentId,
        linkageCallId: call.globallyUniqueCallLinkageID,
        callerNumber: extensionId,
        pbxCallId: this.pbxCallId
      }
      saveTransferCall({body:JSON.stringify(body)}).then(res=>{
        console.log('saveTransferCall success',body)
		this.pbxCallId = null
      })
      .catch(err=>{
        console.log('saveTransferCall err',err)
      })
    }).catch(()=>{
      console.log('errr')
    });
  }
}