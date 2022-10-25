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

import 'dart:async';
import 'dart:io';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadToFirebaseStorage(OptimumFileToUpload optimumFileToUpload) async {
  String result = '';
  debugPrint("file_upload_service: starting upload");
  final Reference storageReference = FirebaseStorage.instance.ref();
  if(await Permission.storage.request().isGranted) {
    debugPrint("file_upload_service: Storage permission garanted");
    File fileNotBlob = File(optimumFileToUpload.localPath);
    debugPrint("file_upload_service: FILE PATH: ${fileNotBlob.path}");
    String remotePath = optimumFileToUpload.remoteFolder + "/" + Uuid().v1() + optimumFileToUpload.fileType;
    debugPrint("file_upload_service: REMOTE PATH: $remotePath");
    final UploadTask uploadTask = storageReference.child(remotePath).putFile(fileNotBlob);
    final StreamSubscription<TaskSnapshot> streamSubscription = uploadTask.snapshotEvents.listen((event) {
      print('EVENT ${event.runtimeType}');
    });
    streamSubscription.cancel();
    result = await (await uploadTask).ref.getDownloadURL();
    return result;
  }
  return result;
}