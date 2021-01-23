import 'package:BuyTime/reusable/snippet/generic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../file/optimum_file_to_upload.dart';

class ServiceState {
  String id;
  String id_business;
  String name;
  String thumbnail;
  String image;
  String description;
  bool availability;
  List<GenericState> actionList;
  List<GenericState> categoryList;
  List<GenericState> externalCategoryList;
  List<GenericState> positionList;
  String visibility;
  List<GenericState> constraintList;
  List<GenericState> tagList;
  double price;
  List<GenericState> write_permission;
  List<GenericState> pipelineList;
  List<OptimumFileToUpload> fileToUploadList;

  ServiceState({
    this.id,
    this.id_business,
    this.name,
    this.thumbnail,
    this.image,
    this.description,
    this.availability,
    this.actionList,
    this.categoryList,
    this.externalCategoryList,
    this.positionList,
    this.visibility,
    this.constraintList,
    this.tagList,
    this.price,
    this.write_permission,
    this.pipelineList,
    this.fileToUploadList,
  });

  ServiceState toEmpty() {
    return ServiceState(
      id: "",
      id_business: "",
      name: "",
      thumbnail: "",
      image: "",
      description: "",
      availability: false,
      actionList: [],
      categoryList: [],
      externalCategoryList: [],
      positionList: [],
      visibility: "Visible",
      constraintList: [],
      tagList: [],
      price: 0.00,
      write_permission: [],
      pipelineList: [],
      fileToUploadList: null,
    );
  }

  ServiceState.fromState(ServiceState service) {
    this.id = service.id;
    this.id_business = service.id_business;
    this.name = service.name;
    this.thumbnail = service.thumbnail;
    this.image = service.image;
    this.description = service.description;
    this.availability = service.availability;
    this.actionList = service.actionList;
    this.categoryList = service.categoryList;
    this.externalCategoryList = service.externalCategoryList;
    this.positionList = service.positionList;
    this.visibility = service.visibility;
    this.constraintList = service.constraintList;
    this.tagList = service.tagList;
    this.price = service.price;
    this.write_permission = service.write_permission;
    this.pipelineList = service.pipelineList;
    this.fileToUploadList = service.fileToUploadList;
  }

  serviceStateFieldUpdate(
      String id,
      String id_business,
      String name,
      String thumbnail,
      String description,
      bool availability,
      List<GenericState> actionList,
      List<GenericState> categoryList,
      List<GenericState> externalCategoryList,
      List<GenericState> positionList,
      String visibility,
      List<GenericState> constraintList,
      List<GenericState> tagList,
      double price,
      List<GenericState> write_permission,
      List<GenericState> pipelineList,
      List<OptimumFileToUpload> fileToUploadList,) {
    ServiceState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      availability: availability ?? this.availability,
      actionList: actionList ?? this.actionList,
      categoryList: categoryList ?? this.categoryList,
      externalCategoryList: externalCategoryList ?? this.externalCategoryList,
      positionList: positionList ?? this.positionList,
      visibility: visibility ?? this.visibility,
      constraintList: constraintList ?? this.constraintList,
      tagList: tagList ?? this.tagList,
      price: price ?? this.price,
      write_permission: write_permission ?? this.write_permission,
      pipelineList: pipelineList ?? this.pipelineList,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
    );
  }

  ServiceState copyWith(
      {
        String id,
        String id_business,
      String name,
      String thumbnail,
      String description,
      bool availability,
      List<GenericState> actionList,
      List<GenericState> categoryList,
      List<GenericState> externalCategoryList,
      List<GenericState> positionList,
      String visibility,
      List<GenericState> constraintList,
      List<GenericState> tagList,
      double price,
      List<GenericState> write_permission,
      List<GenericState> pipelineList,
      List<OptimumFileToUpload> fileToUploadList}) {
    return ServiceState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      availability: availability ?? this.availability,
      actionList: actionList ?? this.actionList,
      categoryList: categoryList ?? this.categoryList,
      externalCategoryList: externalCategoryList ?? this.externalCategoryList,
      positionList: positionList ?? this.positionList,
      visibility: visibility ?? this.visibility,
      constraintList: constraintList ?? this.constraintList,
      tagList: tagList ?? this.tagList,
      price: price ?? this.price,
      write_permission: write_permission ?? this.write_permission,
      pipelineList: pipelineList ?? this.pipelineList,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
    );
  }

  List<dynamic> convertToJson(List<GenericState> objectStateList) {
    List<dynamic> list = List<dynamic>();
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  ServiceState.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        id_business = json['id_business'],
        name = json['name'],
        thumbnail = json['thumbnail'],
        description = json['description'],
        availability = json['availability'],
        actionList = List<GenericState>.from(json["actionList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        categoryList = List<GenericState>.from(json["categoryList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        externalCategoryList = List<GenericState>.from(json["externalCategoryList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        positionList = List<GenericState>.from(json["positionList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        visibility = json['visibility'],
        constraintList = List<GenericState>.from(json["constraintList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        tagList = List<GenericState>.from(json["tagList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        price = json['price'],
        write_permission = List<GenericState>.from(json["write_permission"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        })),
        pipelineList = List<GenericState>.from(json["pipelineList"].map((item) {
          return new GenericState(
            name: item["name"],
            id: item["id"],
          );
        }));

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_business': id_business,
        'name': name,
        'thumbnail': thumbnail,
        'description': description,
        'availability': availability,
        'actionList': convertToJson(actionList),
        'categoryList': convertToJson(categoryList),
        'externalCategoryList': convertToJson(externalCategoryList),
        'positionList': convertToJson(positionList),
        'visibility': visibility,
        'constraintList': convertToJson(constraintList),
        'tagList': convertToJson(tagList),
        'price': price,
        'write_permission': convertToJson(write_permission),
        'pipelineList': convertToJson(pipelineList),
      };
}

