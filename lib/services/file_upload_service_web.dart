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
