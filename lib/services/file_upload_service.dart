import 'dart:async';
import 'dart:io';
import 'package:BuyTime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadToFirebaseStorage(OptimumFileToUpload optimumFileToUpload) async {
  print("file_upload_service: starting upload");
  final StorageReference storageReference = FirebaseStorage().ref();
  if(await Permission.storage.request().isGranted) {
    File fileNotBlob = File(optimumFileToUpload.localPath);
    String remotePath = optimumFileToUpload.remoteFolder + "/" + Uuid().v1() + optimumFileToUpload.fileType;
    final StorageUploadTask uploadTask = storageReference.child(remotePath).putFile(fileNotBlob);
    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });
    streamSubscription.cancel();
    String result = await (await uploadTask.onComplete).ref.getDownloadURL();
    return result;
  }
  // TODO return notification that permission is not granted
}