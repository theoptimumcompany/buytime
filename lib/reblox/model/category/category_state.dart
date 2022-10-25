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

import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_state.g.dart';

enum CustomTag {
  showcase,
  external,
  other,
}

@JsonSerializable(explicitToJson: true)
class CategoryState {
  String name;
  String id;
  int level;
  Parent parent;
  List<Manager> manager;
  List<String> managerMailList;
  String businessId;
  List<Worker> worker;
  List<String> workerMailList;
  @JsonKey(ignore: true)
  OptimumFileToUpload fileToUpload;
  String categoryImage;
  String customTag;
  @JsonKey(defaultValue: false)
  bool showcase;

  CategoryState({this.name, this.id, this.level, this.parent, this.manager, this.managerMailList, this.businessId, this.worker, this.workerMailList, this.fileToUpload, this.categoryImage, this.customTag, this.showcase});

  CategoryState toEmpty() {
    return CategoryState(
        name: "", id: "", level: 0, parent: Parent(name: "No Parent", id: "no_parent"), manager: [], managerMailList: [], businessId: "", worker: [], workerMailList: [], fileToUpload: null, categoryImage: '', customTag: '', showcase: false);
  }

  CategoryState.fromState(CategoryState category) {
    this.name = category.name;
    this.id = category.id;
    this.level = category.level;
    this.parent = category.parent;
    this.manager = category.manager;
    this.managerMailList = category.managerMailList;
    this.businessId = category.businessId;
    this.worker = category.worker;
    this.workerMailList = category.workerMailList;
    this.fileToUpload = category.fileToUpload;
    this.categoryImage = category.categoryImage;
    this.customTag = category.customTag;
    this.showcase = category.showcase;
  }

  CategoryState copyWith(
      {String name,
      String id,
      int level,
      Parent parent,
      List<Manager> manager,
      List<String> managerMailList,
      String businessId,
      List<Worker> worker,
      List<String> workerMailList,
      OptimumFileToUpload fileToUpload,
      String categoryImage,
      String customTag,
      String showcase}) {
    return CategoryState(
        name: name ?? this.name,
        id: id ?? this.id,
        level: level ?? this.level,
        parent: parent ?? this.parent,
        manager: manager ?? this.manager,
        managerMailList: managerMailList ?? this.managerMailList,
        businessId: businessId ?? this.businessId,
        worker: worker ?? this.worker,
        workerMailList: workerMailList ?? this.workerMailList,
        fileToUpload: fileToUpload ?? this.fileToUpload,
        categoryImage: categoryImage ?? this.categoryImage,
        customTag: customTag ?? this.customTag,
        showcase: showcase ?? this.showcase);
  }

  List<dynamic> convertManagerToJson(List<Manager> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  List<dynamic> convertWorkerToJson(List<Worker> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  factory CategoryState.fromJson(Map<String, dynamic> json) => _$CategoryStateFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryStateToJson(this);
}
