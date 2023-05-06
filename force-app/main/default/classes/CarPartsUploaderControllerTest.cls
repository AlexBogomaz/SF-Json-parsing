@isTest
private class CarPartsUploaderControllerTest{
	private static final Integer carPartsJsonSize = 4;

	@TestSetup
	static void setup(){
		String base64 = EncodingUtil.Base64Encode(Blob.valueOf(TestConstUtil.carPartsJSON));
		CarPartsUploaderController.createCarPartRecordsFromJSON(base64);
	}
	
	@isTest static void createCarPartRecordsFromJSON_FieldsTest() {
		List<Car_Part__c> carParts = [SELECT Name, Manufacturer__c, Price__c, Code__c, Description__c FROM Car_Part__c];

		for(Car_Part__c carPart : carParts) {
			System.assert(carPart.Name != null, 'Name must not be empty');
			System.assert(carPart.Description__c != null, 'Description__c must not be empty');
			System.assert(carPart.Price__c != null, 'Price__c must not be empty');
			System.assert(carPart.Code__c != null, 'Code__c must not be empty');
			System.assert(carPart.Manufacturer__c != null, 'Manufacturer__c must not be empty');
		}
	}

	@isTest static void createCarPartRecordsFromJSON_SizeTest() {
		List<Car_Part__c> carParts = [SELECT Name, Manufacturer__c, Price__c, Code__c, Description__c FROM Car_Part__c];

		System.assertEquals(carPartsJsonSize, carParts.size());
	}

}