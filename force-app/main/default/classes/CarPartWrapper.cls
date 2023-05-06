public class CarPartWrapper {
    public class Car_part {
		public String Name;
		public String Description;
		public String Manufacturer;
		public String Code;
		public Double Price;
	}

	public List<Car_part> car_parts;

	
	public static CarPartWrapper parse(String json) {
		return (CarPartWrapper) System.JSON.deserialize(json, CarPartWrapper.class);
	}

}