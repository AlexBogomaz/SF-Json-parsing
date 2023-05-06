public class CarPartUtil {
    public static List<Car_Part__c> getCarPartsFromWrapper(CarPartWrapper carPartWrapper) {
        List<Car_Part__c> carParts = new List<Car_Part__c>();
        
        for(CarPartWrapper.Car_part carPart : carPartWrapper.car_parts) {
           Car_Part__c carPartRecord = new Car_Part__c();
           carPartRecord.Name = carPart.Name;
           carPartRecord.Code__c = carPart.Code;
           carPartRecord.Description__c = carPart.Description;
           carPartRecord.Manufacturer__c = carPart.Manufacturer;
           carPartRecord.Price__c = carPart.Price;
           
           carParts.add(carPartRecord);
        }

        return carParts;
    }
}