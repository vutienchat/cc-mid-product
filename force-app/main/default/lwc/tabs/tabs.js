import { LightningElement, api, track } from 'lwc';

export default class Tabs extends LightningElement {
    @api activeTab = '';
    @track tabs = [];

    renderedCallback() {
      const tabsElement= this.querySelectorAll("c-custom-tab");
      if (this.tabs.length !== tabsElement.length) {
        const tabs = [];
        tabsElement.forEach((tab,index) => {
          const {label,iconName,value}= tab
          tabs.push({
            id: index++,
            label: label,
            iconName: iconName,
            value: value,
            linkClass: 'slds-tabs_default__item' + (index === 1 ? ' slds-is-active' : '') 
          })
        });
        if(tabs.length > 0){
          tabsElement[0].setAttribute('class', 'slds-tabs_default__content slds-show')
        }
        this.tabs = tabs;
      }
    }

    handleTabClick(event) {
      const tabId = event.currentTarget.dataset.tabId
      this.handleShowTab(tabId)
    }
    
    @api
    handleShowTab(tabId){
      const tabsElement= this.querySelectorAll("c-custom-tab");
      tabsElement.forEach((tab) => {
          if(tab.id===tabId){
              tab.classList.remove('slds-hide')
              tab.classList.add('slds-show')
          }else{
            tab.classList.remove('slds-show')
            tab.classList.add('slds-hide')
          }
      })

      this.tabs = this.tabs.map(tab => {
          const isActive= tab.value === tabId;
          tab.linkClass = 'slds-tabs_default__item' + (isActive ? ' slds-is-active' : '');
          return tab;
      });
    }
}