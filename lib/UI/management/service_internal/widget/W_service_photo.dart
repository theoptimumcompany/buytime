import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnFilePickedCallback = void Function(OptimumFileToUpload fileToUpload);

class WidgetServicePhoto extends StatefulWidget {
  final OnFilePickedCallback onFilePicked;
  final String remotePath;
  final int maxPhoto;
  final String image;
  final CropAspectRatioPreset cropAspectRatioPreset;

  WidgetServicePhoto(
      {@required this.remotePath,
      @required this.maxPhoto,
      @required this.onFilePicked,
      @required this.cropAspectRatioPreset,
      this.image});

  @override
  State<StatefulWidget> createState() => WidgetServicePhotoState(
      onFilePicked: onFilePicked,
      remotePath: remotePath,
      maxPhoto: maxPhoto,
      cropAspectRatioPreset: cropAspectRatioPreset,
      image: image);
}

class WidgetServicePhotoState extends State<WidgetServicePhoto> {
  final ImagePicker imagePicker = ImagePicker();

  final String remotePath;
  final int maxPhoto;
  final CropAspectRatioPreset cropAspectRatioPreset;
  final OnFilePickedCallback onFilePicked;
  var size;
  String image;
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');

  Image croppedImage;

  PickedFile imageFile;
  ImageState imageServiceState;
  Completer<ui.Image> completer;
  bool underReqSize = false;

  WidgetServicePhotoState({this.onFilePicked, this.remotePath, this.maxPhoto, this.cropAspectRatioPreset, this.image});

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

    if (pickedFile != null) {
      Image.file(new File(pickedFile.path)).image.resolve(new ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            completer.complete(image.image);
            debugPrint('optimum_from_multi_photo: image -> width: ${image.image.width} - height: ${image.image.height}');
            if (image.image.height < 1000 && image.image.width < 1000) {
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

    if (pickedFile != null) {
      var decodedImage = await decodeImageFromList(await pickedFile.readAsBytes());
      final bytes = (await pickedFile.readAsBytes()).lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      print('optimum_from_multi_photo WIDTH: ${decodedImage.width}');
      print('optimum_from_multi_photo LENGTH: ${decodedImage.height}');
      print('optimum_from_multi_photo SIZE: MB: $mb | KB: $kb');

      if (decodedImage.width < 1000 && decodedImage.height < 1000 && mb < 4) {
        debugPrint('optimum_from_multi_photo: no crop');
        setState(() {
          underReqSize = true;
        });
      } else {
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
                hideBottomControls: true),
            iosUiSettings: IOSUiSettings(
                title: AppLocalizations.of(context).cropYourImage,
                hidesNavigationBar: true,
                rotateButtonsHidden: true,
                resetButtonHidden: true,
                aspectRatioLockEnabled: false,
                rotateClockwiseButtonHidden: true,
                aspectRatioPickerButtonHidden: true));
      }
    }

    if (croppedFile != null) {
      debugPrint('optimum_from_multi_photo: cropped done');
      PickedFile tmpCroppedFile = new PickedFile(croppedFile.path);

      if (kIsWeb) {
        if (pickedFile != null) {
          setState(() {
            image = tmpCroppedFile.path;
            imageFile = tmpCroppedFile;
          });
        }
      } else {
        Image imageFromMemory = Image.memory(await tmpCroppedFile.readAsBytes());
        if (imageFromMemory != null) {
          setState(() {
            image = '';
            croppedImage = imageFromMemory;
            imageFile = tmpCroppedFile;
          });
        }
      }
      setState(() {
        imageServiceState = ImageState.cropped;
      });
    }

    return imageFile;
  }

  void clearImage() {
    imageFile = null;
    setState(() {
      imageServiceState = ImageState.free;
    });
  }

  void manageImage() async {
    setState(() {
      underReqSize = false;
      completer = new Completer<ui.Image>();
    });

    print("optimum_form_multi_photo: pick image");
    // call the image picker
    getImage().then((result) {
      if (result != null)
        onFilePicked(OptimumFileToUpload(fileType: path.extension(result.path), localPath: result.path, remoteFolder: remotePath, remoteName: path.basename(result.path), state: imageServiceState));
    });
  }

  bool canEdit(){
    bool edit = false;
    debugPrint('UI_M_edit_service => USER ROLE: ${StoreProvider.of<AppState>(context).state.user.getRole()}');
    if(StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner){
      edit = true;
      debugPrint('UI_M_edit_service => CAN EDIT ${Utils.enumToString(StoreProvider.of<AppState>(context).state.user.getRole())}');
    }
    StoreProvider.of<AppState>(context).state.category.manager.forEach((email) {
      if(email.mail == StoreProvider.of<AppState>(context).state.user.email){
        edit = true;
        debugPrint('UI_M_edit_service => CAN EDIT MANAGER');
      }
    });

    return edit;
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('REMOTE PATH: $remotePath');
    //debugPrint('IMAGE: $image');
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            underReqSize
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      AppLocalizations.of(context).invalidSize,
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.AccentRed, fontWeight: FontWeight.bold, fontSize: 18 //SizeConfig.safeBlockHorizontal * 4
                          ),
                    ),
                  )
                : Container()
          ],
        ),
        Container(
          child: GestureDetector(
            child: croppedImage != null ? croppedImage : (image != '' ? CachedNetworkImage(
              imageUrl: remotePath.endsWith('1') ? Utils.sizeImage(image, Utils.imageSizing600) : Utils.sizeImage(image, Utils.imageSizing200),
              imageBuilder: (context, imageProvider) => Container(
                //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                height: remotePath.endsWith('1') ? 300 : 150,
                width: remotePath.endsWith('1') ? 300 : 150,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
              ),
              placeholder: (context, url) => Utils.imageShimmer(remotePath.endsWith('1') ? 300 : 150, remotePath.endsWith('1') ? 300 : 150),
              errorWidget: (context, url, error) => croppedImage == null ? Image(width: SizeConfig.blockSizeHorizontal * 100, image: assetImage) : croppedImage,
            ) : Image(width: SizeConfig.blockSizeHorizontal * 100, image: assetImage)),
            onTap: canEdit() ? () {
              manageImage();
            } : null,
          ),
        )
      ],
    );
  }
}
