
///Service model
class ServiceModel{

  ///Variables
  String id, name, phonenumber, image; ///Temporary string

  ///Contructure
  ServiceModel({
    this.id,
    this.name,
    this.phonenumber,
    this.image
  });

  ///Values to Json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rawMap = Map<String, dynamic>();

    rawMap["id"] = id;
    rawMap["name"] = name;
    rawMap["phonenumber"] = phonenumber;
    rawMap["image"] = image;

    return rawMap;
  }

  ///Values from Json
  factory ServiceModel.fromJson(Map<String, dynamic> parsedJson) {

    ServiceModel serviceModel = ServiceModel(
      id: parsedJson["id"],
      name: parsedJson["name"],
      phonenumber: parsedJson["phonenumber"],
      image: parsedJson["image"],
    );

    return serviceModel;
  }
}

