
///Menu Item model
class MenuItemModel{

  ///Variables
  String id, type, mostPopular, itemCount, serviceId; ///Temporary string

  ///Contructure
  MenuItemModel({
    this.id,
    this.type,
    this.mostPopular,
    this.itemCount,
    this.serviceId
  });

  ///Values to Json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rawMap = Map<String, dynamic>();

    rawMap["id"] = id;
    rawMap["type"] = type;
    rawMap["mostPopular"] = mostPopular;
    rawMap["itemCount"] = itemCount;
    rawMap["serviceId"] = serviceId;

    return rawMap;
  }

  ///Values from Json
  factory MenuItemModel.fromJson(Map<String, dynamic> parsedJson) {

    MenuItemModel menuItemModel = MenuItemModel(
      id: parsedJson["id"],
      type: parsedJson["type"],
      mostPopular: parsedJson["mostPopular"],
      itemCount: parsedJson["itemCount"],
      serviceId: parsedJson["serviceId"],
    );

    return menuItemModel;
  }
}

