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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/area_list_reducer.dart';
import 'package:Buytime/reblox/reducer/area_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';

class AreaListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ServiceListSnippetState serviceListSnippetState = ServiceListSnippetState();

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("area_service_epic => AreaRequestService => AreaRequestService CATCHED ACTION");
    AreaListState areaListState = AreaListState().toEmpty();
    return actions.whereType<AreaListRequest>().asyncMap((event) async {
      var areaListQuerySnapshot = await FirebaseFirestore.instance.collection("area").get();
      for(int i = 0; i < areaListQuerySnapshot.docs.length; i++) {
        AreaState areaState = AreaState.fromJson(areaListQuerySnapshot.docs[i].data());
        areaListState.areaList.add(areaState);
      }
    }).expand((element) => [
      SetAreaList(areaListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}
