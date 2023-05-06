public with sharing class CarPartsUploaderController {

    @AuraEnabled
    public static List<Car_Part__c>  createCarPartRecordsFromJSON(String base64) {
        CarPartWrapper carPartWrapper = parseCarPartsFromJson(base64);
        List<Database.SaveResult> insertResults = insertCarParts(carPartWrapper);
        Set<Id> insertedRecordsIds = getInsertedRecordsId(insertResults);
        List<Car_Part__c> a =  getCarParts(insertedRecordsIds);
        return getCarParts(insertedRecordsIds);
    }

    private static CarPartWrapper parseCarPartsFromJson(String base64) {
        Blob decodedFile = EncodingUtil.base64Decode(base64);
        return CarPartWrapper.parse(decodedFile.toString());
    }

    private static List<Database.SaveResult> insertCarParts(CarPartWrapper carPartWrapper) {
        List<Car_Part__c> carParts = CarPartUtil.getCarPartsFromWrapper(carPartWrapper);
        return Database.insert(carParts, true);
    }
    
    private static Set<Id> getInsertedRecordsId(List<Database.SaveResult> insertResults) {
       
        Set<Id> insertedRecordsIds = new Set<Id>();
        for(Database.SaveResult sr : insertResults) {
            insertedRecordsIds.add(sr.getId());
        }
        return insertedRecordsIds;
    }
    
    private static List<Car_Part__c> getCarParts(Set<Id> carPartsIds) {
        return [
            SELECT Name, Manufacturer__c, Price__c, Code__c, Description__c 
            FROM Car_Part__c
            WHERE Id IN :carPartsIds
            ];
    }
}