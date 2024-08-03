import { LightningElement ,api} from 'lwc';

export default class PhoneInbound extends LightningElement {
    @api callInfo

    @api
    handleAnswerCall = () => {
    const event = new CustomEvent("answercall")
    this.dispatchEvent(event)
    }

    handleUnCalling = () => {
    const event = new CustomEvent("uncalling")
    this.dispatchEvent(event)
    }

    @api
    handleOpenTransferCall = () => {
      const newEvent = new CustomEvent("toggletransfercall",{detail:true})
      this.dispatchEvent(newEvent)
    }
}