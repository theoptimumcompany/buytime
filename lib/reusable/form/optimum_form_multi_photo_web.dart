import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      image: image);
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

  Future<WebImageInfo> getImage() async {
      return getPickedFile();

  }

  Future<WebImageInfo> getPickedFile() async {
    WebImageInfo pickedFile = await FlutterWebImagePicker.getImageInfo;
    // TODO when flutter is good at it we will resize the image here

      Image imageFromMemory = Image.memory(pickedFile.data);
      setState(() {
        image = imageFromMemory;
      });
    return pickedFile;
  }

  void manageImage() {
    print("optimum_form_multi_photo: pick image, path, result, remotePath");
    // call the image picker
    getImage().then((dynamic result) {
      print("optimum_form_multi_photo: result");
      onFilePicked(
          OptimumFileToUpload(
              fileType: path.extension(result.fileName),
              localPath: result.fileName,
              remoteFolder: remotePath,
              remoteName: path.basename(result.fileName),
              image: result,
          )
      );
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
            text == null ? AppLocalizations.of(context).staticPlaceholder : text,
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
