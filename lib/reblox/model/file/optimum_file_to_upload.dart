import 'dart:io';
import 'package:flutter/material.dart';
import 'package:BuyTime/reblox/model/file/web_image_info.dart' if (dart.library.html)  'package:flutter_web_image_picker/flutter_web_image_picker.dart';

import 'package:image_picker/image_picker.dart';

class OptimumFileToUpload {
  String localPath;
  String remoteFolder;
  String remoteName;
  String fileType;
  WebImageInfo image;

  OptimumFileToUpload({this.fileType, this.localPath, this.remoteFolder, this.remoteName, this.image});
}