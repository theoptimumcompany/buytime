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

import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:flutter/foundation.dart';

import '../file/optimum_file_to_upload.dart';

class BusinessServiceSnippetList {
  List<ServiceSnippetState> snippetMap;

  List<dynamic> convertToJson(List<ServiceSnippetState> serviceSnippetList) {
    List<dynamic> list = <dynamic>[];
    serviceSnippetList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  BusinessServiceSnippetList({
    @required this.snippetMap,
  });

  BusinessServiceSnippetList toEmpty() {
    return BusinessServiceSnippetList(
      snippetMap: [],
    );
  }

  BusinessServiceSnippetList.fromState(BusinessServiceSnippetList state) {
    this.snippetMap = state.snippetMap;
  }

  companyStateFieldUpdate(
    List<ServiceSnippetState> snippetMap,
  ) {
    BusinessServiceSnippetList(
      snippetMap: snippetMap ?? this.snippetMap,
    );
  }

  BusinessServiceSnippetList copyWith({
    List<ServiceSnippetState> snippetMap,
  }) {
    return BusinessServiceSnippetList(
      snippetMap: snippetMap ?? this.snippetMap,
    );
  }

  // BusinessServiceSnippetList.fromJson(Map<String, dynamic> json)
  //     : snippetMap = List<ServiceSnippet>.from(json["snippetMap"].map((item) {
  //         return new ServiceSnippet(
  //           id: item["id"] != null ? item["id"] : "",
  //           name: item["name"] != null ? item["name"] : "",
  //           timesSold: item["timesSold"] != null ? item["timesSold"] : 0,
  //           image: item["image1"] != null ? item["image1"] : "",
  //           visibility: item["visibility"] != null ? item["visibility"] : "",
  //         );
  //       })
  // );
  //
  // Map<String, dynamic> toJson() => {
  //       'snippetMap': convertToJson(snippetMap),
  //     };
}
