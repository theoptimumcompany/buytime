import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:flutter/foundation.dart';

import '../file/optimum_file_to_upload.dart';

class BusinessServiceSnippetList {
  List<ServiceSnippet> snippetMap;

  List<dynamic> convertToJson(List<ServiceSnippet> serviceSnippetList) {
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
    List<ServiceSnippet> snippetMap,
  ) {
    BusinessServiceSnippetList(
      snippetMap: snippetMap ?? this.snippetMap,
    );
  }

  BusinessServiceSnippetList copyWith({
    List<ServiceSnippet> snippetMap,
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
