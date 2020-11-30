
///Manager model
class ManagerModel{

  ///Variables
  String id, name, surname, employees, menuItems, serviceId; ///Temporary string

  ///Contructure
  ManagerModel({
    this.id,
    this.name,
    this.surname,
    this.employees,
    this.menuItems,
    this.serviceId
  });

  ///Values to Json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rawMap = Map<String, dynamic>();

    rawMap["id"] = id;
    rawMap["name"] = name;
    rawMap["surname"] = surname;
    rawMap["employees"] = employees;
    rawMap["menuItems"] = menuItems;
    rawMap["serviceId"] = serviceId;

    return rawMap;
  }

  ///Values from Json
  factory ManagerModel.fromJson(Map<String, dynamic> parsedJson) {

    ManagerModel managerModel = ManagerModel(
      id: parsedJson["id"],
      name: parsedJson["name"],
      surname: parsedJson["surname"],
      employees: parsedJson["employees"],
      menuItems: parsedJson["menuItems"],
      serviceId: parsedJson["serviceId"],
    );

    return managerModel;
  }
}

