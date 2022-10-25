/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/


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

