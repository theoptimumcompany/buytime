import 'dart:io';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';
import 'package:flutter/material.dart';
import 'package:Buytime/reblox/model/file/web_image_info.dart' if (dart.library.html)  'package:flutter_web_image_picker/flutter_web_image_picker.dart';

import 'package:image_picker/image_picker.dart';


enum ImageState {
  free,
  picked,
  cropped,
}

class OptimumFileToUpload {
  String localPath;
  String remoteFolder;
  String remoteName;
  String fileType;
  WebImageInfo image;
  ImageState state;

  OptimumFileToUpload({this.fileType, this.localPath, this.remoteFolder, this.remoteName, this.image, this.state});
}