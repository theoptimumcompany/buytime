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
import 'package:firebase/firebase.dart' as fb;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

Future<Uri> uploadToFirebaseStorage(OptimumFileToUpload optimumFileToUpload) async {

  print("file_upload_service_web: starting upload");
  PickedFile pickedFile = PickedFile(optimumFileToUpload.localPath);
  print("file_upload_service_web: file " + pickedFile.path);
  String remotePath = optimumFileToUpload.remoteFolder + "/" + Uuid().v1() + optimumFileToUpload.fileType;
  final fb.StorageReference ref = fb.storage().ref(remotePath);
  print("file_upload_service_web: reference to firebase taken for " + remotePath);
  fb.UploadMetadata uploadMetadata = fb.UploadMetadata(contentType: lookupMimeType(optimumFileToUpload.image.fileName));
  var uploadTask =  ref.put(
    optimumFileToUpload.image.data,
      uploadMetadata
  );
  return await (await uploadTask.future).ref.getDownloadURL();

  // TODO add request completed support
  // TODO probably this starts a listener that is not closed


}
