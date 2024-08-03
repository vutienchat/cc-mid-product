import getCalloutResponseContents from "@salesforce/apex/CalloutWebService.getCalloutResponseContents";
const handleError = (next) => {
    return (error) => {
        let errMsg = error.body?.message || error.error?.message;
        const changeMsg = "disconnected or canceled";
        errMsg =
            errMsg.toLowerCase().includes(changeMsg) || !window.navigator.onLine
                ? LABELS.noNetwork
                : errMsg;
        next(errMsg);
    };
};
export const CalloutWebService = {
    getCalloutResponseContents: (request) =>{
        return new Promise((resolve, reject) => {
            getCalloutResponseContents({ request }).then(resolve).catch(handleError(reject));
        });
    }
}