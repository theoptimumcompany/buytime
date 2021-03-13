import 'package:Buytime/reblox/model/file/web_image_info.dart';

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