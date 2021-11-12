import 'dart:async';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CategoryBloc {

  List<List<ServiceState>> _allServicesPagedResults = [];
  DocumentSnapshot _lastServiceDocument;
  bool _hasMorePosts = true;
  static const int ServicesLimit = 10;
  bool showIndicator = false;
  StreamController<List<CategoryState>> categoryController;
  StreamController<bool> showIndicatorController;

  CategoryBloc() {
    categoryController = StreamController<List<CategoryState>>.broadcast();
    showIndicatorController = StreamController<bool>.broadcast();
  }

  Stream<List<CategoryState>> get serviceStream => categoryController.stream;
  Stream<bool> get getShowIndicatorStream => showIndicatorController.stream;

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  // #1: Move the request posts into it's own function
  void requestCategories(BuildContext context, List<BusinessState> businessList) {
    updateIndicator(true);
    // #2: split the query from the actual subscription
    List<Query> queryList = [];
    List<CategoryState> categoryList = [];
    businessList.forEach((element) {
      queryList.add(FirebaseFirestore.instance.collection("business").doc(element.id_firestore).collection('service_list_snippet'));
    });

    for(int i = 0; i < queryList.length; i++){
      queryList[i].snapshots().listen((servicesSnapshot) {
        //debugPrint('SERVICE SNAPSHOT IS NOT EMPTY: ${servicesSnapshot.docs.isNotEmpty}');
        if (servicesSnapshot.docs.isNotEmpty) {
          ServiceListSnippetState tmp = ServiceListSnippetState.fromJson(servicesSnapshot.docs.first.data());
          tmp.businessSnippet.forEach((category) {
            //String categoryId = category.categoryAbsolutePath.split('/')[1];
            String businessId = category.categoryAbsolutePath.split('/')[0];
            if(businessId == businessList[i].id_firestore){
              CategoryState categoryState = CategoryState().toEmpty();
              categoryState.businessId = businessId;
              categoryState.id = category.categoryAbsolutePath.split('/').last;
              categoryState.name = category.categoryName;
              categoryState.categoryImage = category.categoryImage;
              if(category.categoryAbsolutePath.split('/').length == 2){
                categoryState.level = 0;
                categoryState.parent = Parent(id: 'no_parent');
              }else{
                categoryState.level = 1;
                categoryState.parent = Parent(id: category.categoryAbsolutePath.split('/')[1]);
              }
              categoryState.customTag = category.tags.isNotEmpty ? category.tags.first : '';
              categoryList.add(categoryState);
            }
          });
        }
      });
    }
    categoryController.add(categoryList);

  }

  void dispose() {
    categoryController.close();
  }
}