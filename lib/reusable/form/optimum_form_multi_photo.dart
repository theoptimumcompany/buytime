import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final CropAspectRatioPreset cropAspectRatioPreset;

  OptimumFormMultiPhoto(
      {@required this.text,
      @required this.remotePath,
      @required this.maxPhoto,
      @required this.onFilePicked,
      @required this.maxHeight,
      @required this.maxWidth,
      @required this.minHeight,
      @required this.minWidth,
      @required this.cropAspectRatioPreset,
      this.image
      });

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
      cropAspectRatioPreset: cropAspectRatioPreset,
      image: image
  );
}

enum ImageState {
  free,
  picked,
  cropped,
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
  final CropAspectRatioPreset cropAspectRatioPreset;
  final OnFilePickedCallback onFilePicked;
  var size;
  Image image;
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');

  PickedFile imageFile;
  ImageState state;
  Completer<ui.Image> completer;
  bool underReqSize = false;

  OptimumFormMultiPhotoState(
      {this.text, this.onFilePicked, this.remotePath, this.maxPhoto, this.maxWidth, this.minWidth, this.maxHeight, this.minHeight, this.cropAspectRatioPreset,  this.image});

  Future<PickedFile> getImage() async {
    var status = await Permission.camera.status;
    if (!kIsWeb && await Permission.storage.request().isGranted) {
      return cropImage();
    } else {
      return cropImage();
    }
  }

  Future<PickedFile> pickImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      Image.file(new File(pickedFile.path)).image
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener(
            (ImageInfo image, bool synchronousCall){
          completer.complete(image.image);
          debugPrint('optimum_from_multi_photo: image -> width: ${image.image.width} - height: ${image.image.height}');
          if(image.image.height < 1000 && image.image.width < 1000){
            debugPrint('optimum_from_multi_photo: no crop');
            setState(() {
              underReqSize = true;
            });
          }
        },
      ),
      );
    }

    return pickedFile;
  }


  Future<PickedFile> cropImage() async {

    File croppedFile;

    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

   if(pickedFile != null){
     var decodedImage = await decodeImageFromList(await pickedFile.readAsBytes());

     print('optimum_from_multi_photo: ${decodedImage.width}');
     print('optimum_from_multi_photo: ${decodedImage.height}');

     if(decodedImage.width < 1000 && decodedImage.height < 1000){
       debugPrint('optimum_from_multi_photo: no crop');
       setState(() {
         underReqSize = true;
       });
     }else{
       debugPrint('optimum_from_multi_photo: crop');
       croppedFile = await ImageCropper.cropImage(
         aspectRatio: cropAspectRatioPreset == CropAspectRatioPreset.square ? CropAspectRatio(ratioX: 1, ratioY: 1) : CropAspectRatio(ratioX: 16, ratioY: 9),
           sourcePath: pickedFile.path,
           /*aspectRatioPresets: Platform.isAndroid
               ? [
             CropAspectRatioPreset.square,
             CropAspectRatioPreset.ratio3x2,
             CropAspectRatioPreset.original,
             CropAspectRatioPreset.ratio4x3,
             CropAspectRatioPreset.ratio16x9
           ]
               : [
             //CropAspectRatioPreset.original,
             CropAspectRatioPreset.square,
             //CropAspectRatioPreset.ratio3x2,
             //CropAspectRatioPreset.ratio4x3,
             //CropAspectRatioPreset.ratio5x3,
             //CropAspectRatioPreset.ratio5x4,
             //CropAspectRatioPreset.ratio7x5,
             CropAspectRatioPreset.ratio16x9
           ],*/
           androidUiSettings: AndroidUiSettings(
               toolbarTitle: AppLocalizations.of(context).cropYourImage,
               toolbarColor: BuytimeTheme.UserPrimary,
               toolbarWidgetColor: BuytimeTheme.TextWhite,
               initAspectRatio: cropAspectRatioPreset,
               lockAspectRatio: true,
               hideBottomControls: true
           ),
           iosUiSettings: IOSUiSettings(
             title: AppLocalizations.of(context).cropYourImage,
             hidesNavigationBar: true,
             rotateButtonsHidden: true,
             resetButtonHidden: true,
             aspectRatioLockEnabled: false,
             rotateClockwiseButtonHidden: true,
             aspectRatioPickerButtonHidden: true
           ));
     }
   }

    if (croppedFile != null) {
      debugPrint('optimum_from_multi_photo: cropped done');
      PickedFile tmpCroppedFile = new PickedFile(croppedFile.path);

      if (kIsWeb) {
        if (pickedFile != null) {
          setState(() {
            image = Image.network(tmpCroppedFile.path);
            imageFile = tmpCroppedFile;
          });
        }

      } else {
        Image imageFromMemory = Image.memory(await tmpCroppedFile.readAsBytes());
        if ( imageFromMemory != null) {
          setState(() {
            image = imageFromMemory;
            imageFile = tmpCroppedFile;
          });
        }


      }
      setState(() {
        state = ImageState.cropped;
      });
    }

    return imageFile;
  }

  void clearImage() {
    imageFile = null;
    setState(() {
      state = ImageState.free;
    });
  }

  void manageImage() async{
    setState(() {
      underReqSize = false;
      completer = new Completer<ui.Image>();
    });

    print("optimum_form_multi_photo: pick image");
    // call the image picker
    getImage().then((result) {
      if(result != null)
        onFilePicked(OptimumFileToUpload(fileType: path.extension(result.path), localPath: result.path, remoteFolder: remotePath, remoteName: path.basename(result.path), state: state));
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text == null ? AppLocalizations.of(context).staticPlaceholder : text,
                style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    color: BuytimeTheme.TextDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 18 //SizeConfig.safeBlockHorizontal * 4
                ),
              ),
              underReqSize ? Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  AppLocalizations.of(context).invalidSize,
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.AccentRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 18 //SizeConfig.safeBlockHorizontal * 4
                  ),
                ),
              ) : Container()
              /*imageFile != null ? Container(
                margin: EdgeInsets.only(left: 10.0),
                child: IconButton(
                  icon: Icon(
                      Icons.delete,
                      color: BuytimeTheme.AccentRed
                  ),
                ),
              ) : Container(),*/
            ],
          ),
          Container(
            height: SizeConfig.blockSizeVertical * 15,
            width: SizeConfig.blockSizeHorizontal * 50,
            margin: EdgeInsets.only(top: 10.0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: image == null ? Image(width: SizeConfig.blockSizeHorizontal * 50, image: assetImage) : image,
                      onTap: () {
                        manageImage();
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
