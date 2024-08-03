import { LightningElement, api, track } from 'lwc';

export default class ButtonClipboard extends LightningElement {
    @api value = ''
    @track copied = false

    handleCopy(){
        let textArea = document.createElement("textarea");
        textArea.value = this.value
        textArea.style.position = "fixed";
        textArea.style.left = "-999999px";
        textArea.style.top = "-999999px";
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        return new Promise((res, rej) => {
          document.execCommand("copy") ? res() : rej();
          textArea.remove();
        })
        .then(()=>{
          this.copied= true 
          setTimeout(() => {
            this.copied= false 
          }, 1500);
        });
      }
}