/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reusable/form/w_optimum_form_multi_photo.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../reusable/appbar/w_buytime_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_M_CreateCategory extends StatefulWidget {
  final String title = 'Categories';
  bool empty;

  UI_M_CreateCategory({bool empty}) {
    this.empty = empty;
  }

  @override
  State<StatefulWidget> createState() => UI_M_CreateCategoryState();
}

class UI_M_CreateCategoryState extends State<UI_M_CreateCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formInviteKey = GlobalKey<FormState>();

  Parent _dropdownParentCategory = Parent(level: 0, id: "no_parent", name: "No Parent");

  List<DropdownMenuItem<Parent>> _dropdownMenuParentCategory = [];

  var size;

  String _selectedCategoryName = "";
  Parent selectedParentDropValue;
  Parent newParent;
  bool changeParent = false;
  bool stopBuildDropDown = false;
  bool errorCategoryImage = false;
  String inviteMail = '';

  String bookingRequest = '';

  CustomTag customTag;
  bool create = false;

  void initState() {
    super.initState();
  }

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateCategoryImage(){
   if( StoreProvider.of<AppState>(context).state.category.fileToUpload == null){
     setState(() {
       errorCategoryImage = true;
     });
     return false;
   }else{
     setState(() {
       errorCategoryImage = false;
     });
     return true;
   }
  }

  setNewCategoryParent(Parent contentSelectDrop,/* List<dynamic> list*/) {
    if (contentSelectDrop.id == 'no_parent') {
      Parent parentInitial = Parent(level: 0, id: "no_parent", name: "No Parent");
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(0));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(parentInitial));
    } else {
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(contentSelectDrop.level + 1));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(contentSelectDrop));
    }
  }

  setNewCategoryName(String name){
    StoreProvider.of<AppState>(context).dispatch(SetCategoryName(name));

  }

  setNewCategoryCustomTag(CustomTag customTag) {
    StoreProvider.of<AppState>(context).dispatch(SetCustomTag(Utils.enumToString(customTag)));
  }

  void buildDropDownMenuItemsParent(Parent item) {
    if (stopBuildDropDown == false) {
      stopBuildDropDown = true;
      List<DropdownMenuItem<Parent>> items = [];

      // items.add(
      //   DropdownMenuItem(
      //     child: Text(
      //       item.name,
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //     value: item,
      //   ),
      // );
      //
      // if (categoryNode.categoryNodeList != null) {
      //   if (categoryNode.categoryNodeList.length != 0 && categoryNode.categoryNodeList.length != null) {
      //     List<dynamic> list = categoryNode.categoryNodeList;
      //     items = openTree(list, items);
      //   }
      // }


      List<dynamic> snippet = StoreProvider.of<AppState>(context).state.serviceListSnippetState.businessSnippet;

      for (var i = 0; i < snippet.length; i++) {
        String categoryPath = snippet[i].categoryAbsolutePath;
        List<String> categoryRoute = categoryPath.split('/');

        Parent placeHolderParent = Parent(
          name: snippet[i].categoryName,
          id: categoryRoute.last,
          level: categoryRoute.length - 1,
         // parentRootId: categoryRoute[1],
        );
        items.insert(
          0,
          DropdownMenuItem(
            child: Text(
              placeHolderParent.name,
              overflow: TextOverflow.ellipsis,
            ),
            value: placeHolderParent,
          ),
        );
      }

      items.insert(
        0,
        DropdownMenuItem(
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
          ),
          value: item,
        ),
      );

      _dropdownMenuParentCategory = items;
    }
  }
/*
  openTree(List<dynamic> list, List<DropdownMenuItem<Parent>> items) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['level'] < 4) {
        Parent parent = Parent(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level'], parentRootId: list[i]['categoryRootId']);
        items.add(
          DropdownMenuItem(
            child: Padding(
              padding: EdgeInsets.only(
                left: double.parse(list[i]["level"].toString()) * 12.0,
              ),
              child: Text(parent.name),
            ),
            value: parent,
          ),
        );
      }

      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
  }
*/
  Parent searchDropdownParent(var snapshot) {
    for (var element in _dropdownMenuParentCategory) {
      if (snapshot.category.id == element.value.id) {
        return element.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          buildDropDownMenuItemsParent(_dropdownParentCategory);

          if (snapshot.category != null && !widget.empty) {
            selectedParentDropValue = searchDropdownParent(snapshot);
          }
          else {
            selectedParentDropValue = _dropdownMenuParentCategory.first.value;
          }

          customTag = CustomTag.other;

          String businessName = snapshot.business.name;

          return GestureDetector(
            onTap: (){
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Stack(
              children: [
                ///Booking Code
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          backgroundColor: Colors.white,
                          brightness: Brightness.dark,
                          elevation: 1,
                          title: Text(
                            AppLocalizations.of(context).createCategory,
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
                            ),
                          ),
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black,
                              //size: 25.0,
                            ),
                            tooltip: AppLocalizations.of(context).comeBack,
                            onPressed: () {
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageCategory()),);
                              Navigator.of(context).pop();
                              //Navigator.pushReplacement(context, EnterExitRoute(enterPage: ManageCategory(), exitPage: UI_M_CreateCategory(empty: true,), from: false));
                            },
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: BuytimeTheme.TextBlack,
                                size: 24.0,
                              ),
                              tooltip: AppLocalizations.of(context).submitNewCategory,
                              onPressed: !create ? () {
                                if (validateAndSave() && validateCategoryImage()) {
                                  setState(() {
                                    create = true;
                                  });
                                  if (changeParent == false) {

                                    setState(() {
                                      bookingRequest = 'send';
                                    });

                                    debugPrint("CategoryCreate : Parent non Scelto");
                                    CategoryState categoryCreate = snapshot.category != null ? snapshot.category : CategoryState().toEmpty();
                                    Parent newCategoryParent = selectedParentDropValue;
                                    debugPrint("Livello prima : " + snapshot.category.level.toString());
                                    categoryCreate.parent = newCategoryParent;
                                    if (categoryCreate.parent != _dropdownMenuParentCategory.first.value) {
                                      categoryCreate.level = newCategoryParent.level + 1;
                                    } else {
                                      categoryCreate.level = 0;
                                    }

                                    StoreProvider.of<AppState>(context).dispatch(new CreateCategory(categoryCreate));
                                  } else {
                                    CategoryState categoryCreate = snapshot.category != null ? snapshot.category : CategoryState().toEmpty();

                                    if(categoryCreate.parent.id == 'no_parent'){
                                      categoryCreate.level = 0;
                                    }
                                    StoreProvider.of<AppState>(context).dispatch(CreateCategory(categoryCreate));
                                  }

                                }
                              } : null,
                            )
                          ],
                        ),
                        body: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  ///Category Image
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ///Category Image
                                          Container(
                                            margin: EdgeInsets.only(left: 12 , bottom: 10),
                                            width: SizeConfig.safeBlockHorizontal* 50,
                                            alignment: Alignment.center,
                                            child: OptimumFormMultiPhoto(
                                              text: AppLocalizations.of(context).categoryImage,
                                              remotePath: "business/" + businessName + "/category",
                                              maxHeight: 1000,
                                              maxPhoto: 1,
                                              maxWidth: 800,
                                              minHeight: 200,
                                              minWidth: 600,
                                              roleAllowedArray: [Role.admin, Role.salesman],
                                              cropAspectRatioPreset: CropAspectRatioPreset.square,
                                              onFilePicked: (fileToUpload) {
                                                if(fileToUpload != null){
                                                  setState(() {
                                                    errorCategoryImage = false;
                                                  });
                                                }
                                                fileToUpload.remoteFolder = "business/" + businessName + "/category";
                                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInCategory(fileToUpload, fileToUpload.state, 0));
                                              },
                                            ),
                                          ),
                                          ///Category Tag
                                          /*Padding(
                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child: Center(
                                      child: Container(
                                        width: media.width * 0.9,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField<CustomTag>(
                                                isExpanded: true,
                                                value: customTag,
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      Utils.enumToString(CustomTag.showcase),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    value: CustomTag.showcase,
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      Utils.enumToString(CustomTag.external),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    value: CustomTag.external,
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text(
                                                      Utils.enumToString(CustomTag.other),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    value: CustomTag.other,
                                                  ),
                                                ],
                                                decoration: InputDecoration(labelText: AppLocalizations.of(context).customTag, enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                                onChanged: (value) {
                                                  setState(() {
                                                    customTag = value;
                                                    setNewCategoryCustomTag(customTag);
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),*/
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context).showcase,
                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600, color: BuytimeTheme.TextGrey, fontSize: 16),
                                                ),
                                                Switch(
                                                    activeColor: BuytimeTheme.ManagerPrimary,
                                                    value: snapshot.category.showcase,
                                                    onChanged: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                                        ? (value) {
                                                      debugPrint('UI_M_create_category => SHOWCASE: $value');
                                                      setState(() {
                                                        //isHub = value;
                                                      });
                                                      StoreProvider.of<AppState>(context).dispatch(SetCategoryShowcase(value));
                                                      //snapshot.hub = value;
                                                    }
                                                        : (value) {}),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ///Error message Empty CategoryList
                                      errorCategoryImage
                                          ? Center(
                                              child: Text(
                                                AppLocalizations.of(context).noCategoryImageSet,
                                                style: TextStyle(
                                                  fontSize: media.height * 0.018,
                                                  color: BuytimeTheme.ErrorRed,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ))
                                          : Container(),
                                    ],
                                  ),
                                  ///Category Name
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Center(
                                      child: Container(
                                        width: media.width * 0.9,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                        child: Form(
                                            key: _formKey,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                              child: TextFormField(
                                                validator: (value) => value.isEmpty ? AppLocalizations.of(context).categoryNameIsBlank : null,
                                                initialValue: _selectedCategoryName,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedCategoryName = value;
                                                    setNewCategoryName(value);
                                                  });
                                                },
                                                decoration: InputDecoration(labelText: AppLocalizations.of(context).categoryName),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Center(
                                      child: Container(
                                        width: media.width * 0.9,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField<Parent>(
                                                isExpanded: true,
                                                value: selectedParentDropValue,
                                                items: _dropdownMenuParentCategory,
                                                decoration: InputDecoration(labelText: AppLocalizations.of(context).parentCategory, enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                                onChanged: (Parent newValue) {
                                                  setState(() {
                                                    changeParent = true;
                                                    selectedParentDropValue = newValue;
                                                    newParent = newValue;
                                                    debugPrint("Drop Selezionato su onchangedrop : " + selectedParentDropValue.name);
                                                    setNewCategoryParent(selectedParentDropValue);
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
                ///Ripple Effect
                bookingRequest.isNotEmpty ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: SizeConfig.safeBlockVertical * 100,
                        decoration: BoxDecoration(
                          color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: SizeConfig.safeBlockVertical * 20,
                                height: SizeConfig.safeBlockVertical * 20,
                                child: Center(
                                  child: SpinKitRipple(
                                    color: Colors.white,
                                    size: SizeConfig.safeBlockVertical * 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ) : Container()
              ],
            ),
          );
        });
  }
}
