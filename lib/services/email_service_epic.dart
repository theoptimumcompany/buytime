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
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/email/email_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/email_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/file_upload_service.dart'
    if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class EmailCreateService implements EpicClass<AppState> {
  //BusinessState businessState;
  StatisticsState statisticsState;
  EmailState emailState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<SendEmail>().asyncMap((event) async {
      emailState = event.emailState;
      await FirebaseFirestore.instance.collection("mail/").add(event.emailState.toJson()).then((value){
        if(value.id != null){
          emailState.sent = true;
        }
      });
      //businessState.id_firestore = docReference.id;

      /*statisticsState = store.state.statistics;
      int reads = statisticsState.businessCreateServiceRead;
      int writes = statisticsState.businessCreateServiceWrite;
      int documents = statisticsState.businessCreateServiceDocuments;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessCreateServiceRead = reads;
      statisticsState.businessCreateServiceWrite = writes;
      statisticsState.businessCreateServiceDocuments = documents;*/

      /*return docReference.set(event.emailState.toJson()).then((value) async{ /// 1 WRITE
        debugPrint("EMAIL_SERVICE_EPIC - EmailCreateService => Has created new Email!");
      }).catchError((error) {
        debugPrint("EMAIL_SERVICE_EPIC - EmailCreateService => ERROR: $error");
      }).then((value) {
        return null;
      });*/

    }).expand((element) => [
      SentEmail(emailState)
    ]);
  }
}
