public with sharing class CarPartsUploaderController {

    /**
     * Method controlling parsing, creating and next returning of newly created records
     * @param  base64 base64 format of JSON file with Car parts
     * @return List<Car_Part__c> newly parsed and created records for table
    */
    @AuraEnabled
    public static List<Car_Part__c>  createCarPartRecordsFromJSON(String base64) {
        CarPartWrapper carPartWrapper = parseCarPartsFromJson(base64);
        List<Database.SaveResult> insertResults = insertCarParts(carPartWrapper);
        Set<Id> insertedRecordsIds = getInsertedRecordsId(insertResults);
        List<Car_Part__c> a =  getCarParts(insertedRecordsIds);
        return getCarParts(insertedRecordsIds);
    }

    /**
     * Method parse Car parts from JSON file to CarPartWrapper class
     * @param  base64 base64 format of JSON file with Car parts
     * @return CarPartWrapper parsed json file in the instance of CarPartWrapper class
    */
    private static CarPartWrapper parseCarPartsFromJson(String base64) {
        Blob decodedFile = EncodingUtil.base64Decode(base64);
        return CarPartWrapper.parse(decodedFile.toString());
    }

    /**
     * Method create records from CarPartWrapper and then insert Car_Part__c records,
     * then it returns Database.SaveResult
     * @param  carPartWrapper CarPartWrapper class represent Car_Part__c record from JSON
     * @return List<Database.SaveResult> result of saving records
    */
    private static List<Database.SaveResult> insertCarParts(CarPartWrapper carPartWrapper) {
        List<Car_Part__c> carParts = CarPartUtil.getCarPartsFromWrapper(carPartWrapper);
        return Database.insert(carParts, true);
    }
    
    /**
     * Method returns ids of just created records
     * @param  insertResults result of insert/saving record to database
     * @return Set<Id> Ids of created recrods of Car_Part__c
    */
    private static Set<Id> getInsertedRecordsId(List<Database.SaveResult> insertResults) {
        Set<Id> insertedRecordsIds = new Set<Id>();
        for(Database.SaveResult sr : insertResults) {
            insertedRecordsIds.add(sr.getId());
        }
        return insertedRecordsIds;
    }
    
    /**
     * Method returns Car_Part__c object records by Id
     * @param  carPartsIds Set of Ids for Car_Part__c
     * @return List<Car_Part__c> 
    */
    private static List<Car_Part__c> getCarParts(Set<Id> carPartsIds) {
        return [
            SELECT Name, Manufacturer__c, Price__c, Code__c, Description__c 
            FROM Car_Part__c
            WHERE Id IN :carPartsIds
            ];
    }
}