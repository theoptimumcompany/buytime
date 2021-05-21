import 'dart:async';
import 'dart:io';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadToFirebaseStorage(OptimumFileToUpload optimumFileToUpload) async {
  String result = '';
  print("file_upload_service: starting upload");
  final Reference storageReference = FirebaseStorage.instance.ref();
  if(await Permission.storage.request().isGranted) {
    File fileNotBlob = File(optimumFileToUpload.localPath);
    String remotePath = optimumFileToUpload.remoteFolder + "/" + Uuid().v1() + optimumFileToUpload.fileType;
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