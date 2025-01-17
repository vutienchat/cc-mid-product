//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
@IsTest
public class R1_FeedbackAPITest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"isdn\": \"972699511\",'+
		'	\"subId\": 23144298,'+
		'	\"address\": \"N02-1810 Chung cư Ecohome 3 Tân Xuân Phường Đông Ngạc Quận Bắc Từ Liêm TP.Hà Nội\",'+
		'	\"idNo\": \"121692380\",'+
		'	\"contactName\": \"Nguyễn Duy Phương\",'+
		'	\"contactIsdn\": \"972699511\",'+
		'	\"payAreaCode\": \"HNOBTLDNGA\",'+
		'	\"payMethod\": \"01\",'+
		'	\"subType\": \"F\",'+
		'	\"custName\": \"Nguyễn Duy Phương\",'+
		'	\"cenCode\": \"1\",'+
		'	'+
		'	\"businessType\": \"MOBIFIBER\",'+
		'	\"memberName\": \"FPT_HUEPT1\",'+
		'	\"cenCodeUser\": \"904\",'+
		'	\"requestTime\": \"08/12/2023 15:32:31\",'+
		'	\"requestGroup\": \"869\",'+
		'	\"requestForm\": 120,'+
		'	\"requestSource\": null,'+
		'	\"requestType\": \"4979\",'+
		'	\"requestDetail\": null,'+
		'	\"callOut\": 1,'+
		'	\"content\": \"Nội dung tiếp nhận test\",'+
		'	\"urgent\": 1,'+
		'	\"note\": \"Ghi chú cho người xử lý\",'+
		'	\"contractNo\": \"contractNo\",'+
		'	\"custNo\": \"custNo\",'+
		'	\"memberCode\": 647,'+
		'	\"referenceId\": \"referenceId\",'+
		'	\"closeNow\": false'+
		'}';
		R1_FeedbackAPI.inputFbWrapper obj = R1_FeedbackAPI.inputFbWrapper.parse(json);
		System.assert(obj != null);
	}
}