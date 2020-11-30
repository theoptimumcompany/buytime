import 'package:BuyTime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

typedef OnFilePickedCallback = void Function(OptimumFileToUpload fileToUpload);

class OptimumFormMultiPhoto extends StatefulWidget {

  final OnFilePickedCallback onFilePicked;
  final String text;
  final String remotePath;
  final int maxPhoto;
  final int maxWidth;
  final int minWidth;
  final int maxHeight;
  final int minHeight;
  final Image image;

  OptimumFormMultiPhoto(
      {@required this.text,
      @required this.remotePath,
      @required this.maxPhoto,
      @required this.onFilePicked,
      @required this.maxHeight,
      @required this.maxWidth,
      @required this.minHeight,
      @required this.minWidth,
      this.image});

  @override
  State<StatefulWidget> createState() => OptimumFormMultiPhotoState(
      text: text,
      onFilePicked: onFilePicked,
      remotePath: remotePath,
      maxPhoto: maxPhoto,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      minWidth: minWidth,
      minHeight: minHeight,
      image: image
  );
}

class OptimumFormMultiPhotoState extends State<OptimumFormMultiPhoto> {
  final ImagePicker imagePicker = ImagePicker();
  final String text;
  final String remotePath;
  final int maxPhoto;
  final int maxWidth;
  final int minWidth;
  final int maxHeight;
  final int minHeight;
  final OnFilePickedCallback onFilePicked;
  var size;
  Image image;
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');

  OptimumFormMultiPhotoState(
      {this.text, this.onFilePicked, this.remotePath, this.maxPhoto, this.maxWidth, this.minWidth, this.maxHeight, this.minHeight, this.image});

  Future<PickedFile> getImage() async {
    var status = await Permission.camera.status;
    if (!kIsWeb && await Permission.storage.request().isGranted) {
      return getPickedFile();
    } else {
      return getPickedFile();
    }
  }

  Future<PickedFile> getPickedFile() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery, maxWidth: 1500, maxHeight: 1500);
    // ResizeImage object?
    if (kIsWeb) {
      if (pickedFile != null) {
        setState(() {
          image = Image.network(pickedFile.path);
        });
      }

    } else {
      Image imageFromMemory = Image.memory(await pickedFile.readAsBytes());
      if ( imageFromMemory != null) {
        setState(() {
          image = imageFromMemory;
        });
      }

    }
    return pickedFile;
  }

  void manageImage() {
    print("optimum_form_multi_photo: pick image");
    // call the image picker
    getImage().then((result) {
      onFilePicked(OptimumFileToUpload(fileType: path.extension(result.path), localPath: result.path, remoteFolder: remotePath, remoteName: path.basename(result.path)));
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            text == null ? "static placeholder" : text,
          ),
          GestureDetector(
            child: image == null ? Image(width: 200, image: assetImage) : image,
            onTap: () {
              manageImage();
            },
          ),
        ],
      ),
    );
  }
}
