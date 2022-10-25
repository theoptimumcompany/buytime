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

