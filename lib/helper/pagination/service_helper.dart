import 'dart:async';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ServicePagingBloc {

  List<List<ServiceState>> _allServicesPagedResults = [];
  DocumentSnapshot _lastServiceDocument;
  bool _hasMorePosts = true;
  static const int ServicesLimit = 10;
  bool showIndicator = false;
  StreamController<List<ServiceState>> serviceController;
  StreamController<bool> showIndicatorController;

  ServicePagingBloc() {
    serviceController = StreamController<List<ServiceState>>.broadcast();
    showIndicatorController = StreamController<bool>.broadcast();
  }

  Stream<List<ServiceState>> get serviceStream => serviceController.stream;
  Stream<bool> get getShowIndicatorStream => showIndicatorController.stream;

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  loadService(){
    //serviceController.close();
    var allServices = _allServicesPagedResults.fold<List<ServiceState>>([],
            (initialValue, pageItems) => initialValue..addAll(pageItems));
    debugPrint('LOAD ALL SERVICES LENGTH: ${allServices.length}');

    serviceController.add(allServices);
  }

  // #1: Move the request posts into it's own function
  void requestServices(BuildContext context) {
    updateIndicator(true);
    // #2: split the query from the actual subscription
    Query pageServicesQuery;
    if (StoreProvider.of<AppState>(context).state.area != null && StoreProvider.of<AppState>(context).state.area.areaId != null && StoreProvider.of<AppState>(context).state.area.areaId.isNotEmpty) {
      pageServicesQuery = FirebaseFirestore.instance.collection("service")
          .where("tag", arrayContains: StoreProvider.of<AppState>(context).state.area.areaId)
          .where("visibility", isEqualTo: 'Active')
          //.orderBy("name")
          .limit(ServicesLimit);
    }else{
      pageServicesQuery = FirebaseFirestore.instance.collection("service")
          .where("visibility", isEqualTo: 'Active')
          //.orderBy("name")
          .limit(ServicesLimit);
    }

    // #5: If we have a document start the query after it
    if (_lastServiceDocument != null) {
      pageServicesQuery = pageServicesQuery.startAfterDocument(_lastServiceDocument);
    }

    if (!_hasMorePosts) {
      Future.delayed(Duration(seconds: 1), (){
        updateIndicator(false);
      });
      return;
    }

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allServicesPagedResults.length;

    pageServicesQuery.snapshots().listen((servicesSnapshot) {
      debugPrint('SERVICE SNAPSHOT IS NOT EMPTY: ${servicesSnapshot.docs.isNotEmpty}');
      if (servicesSnapshot.docs.isNotEmpty) {
        List<ServiceState> services = [];
        servicesSnapshot.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          services.add(serviceState);
        });
        debugPrint('SERVICES LENGTH: ${services.length}');

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allServicesPagedResults.length;
        debugPrint('PAGE EXISTS: $pageExists');

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allServicesPagedResults[currentRequestIndex] = services;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allServicesPagedResults.add(services);
        }

        // #11: Concatenate the full list to be shown
        var allServices = _allServicesPagedResults.fold<List<ServiceState>>([],
                (initialValue, pageItems) => initialValue..addAll(pageItems));
        debugPrint('ALL SERVICES LENGTH: ${allServices.length}');
        allServices.forEach((element) {
          //debugPrint('SERVICE NAME: ${element.name}');
        });

        // #12: Broadcase all posts
        serviceController.add(allServices);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allServicesPagedResults.length - 1) {
          _lastServiceDocument = servicesSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMorePosts = services.length == ServicesLimit;
        Future.delayed(Duration(seconds: 1), (){
          updateIndicator(false);
        });
      }
    });
  }

  // #1: Move the request posts into it's own function
  void requestCategoryServices(BuildContext context, List<String> categoryIdList) {
    updateIndicator(true);
    // #2: split the query from the actual subscription
    Query pageServicesQuery;
    if (StoreProvider.of<AppState>(context).state.area != null && StoreProvider.of<AppState>(context).state.area.areaId != null && StoreProvider.of<AppState>(context).state.area.areaId.isNotEmpty) {
      pageServicesQuery = FirebaseFirestore.instance.collection("service")
          .where("tag", arrayContains: StoreProvider.of<AppState>(context).state.area.areaId)
          .where("visibility", isEqualTo: 'Active')
          .where('categoryId', arrayContainsAny: categoryIdList.length > 10 ? categoryIdList.sublist(0, 10) : categoryIdList)
          .limit(ServicesLimit);
    }else{
      pageServicesQuery = FirebaseFirestore.instance.collection("service")
          .where("visibility", isEqualTo: 'Active')
          .where('categoryId', arrayContainsAny: categoryIdList.length > 10 ? categoryIdList.sublist(0, 10) : categoryIdList)
          .limit(ServicesLimit);
    }

    // #5: If we have a document start the query after it
    if (_lastServiceDocument != null) {
      pageServicesQuery = pageServicesQuery.startAfterDocument(_lastServiceDocument);
    }

    if (!_hasMorePosts){
      Future.delayed(Duration(seconds: 1), (){
        updateIndicator(false);
      });
      return;
    }

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allServicesPagedResults.length;

    pageServicesQuery.snapshots().listen((servicesSnapshot) {
      debugPrint('SERVICE SNAPSHOT IS NOT EMPTY: ${servicesSnapshot.docs.isNotEmpty}');
      if (servicesSnapshot.docs.isNotEmpty) {
        List<ServiceState> services = [];
        servicesSnapshot.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          services.add(serviceState);
        });
        debugPrint('SERVICES LENGTH: ${services.length}');

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allServicesPagedResults.length;
        debugPrint('PAGE EXISTS: $pageExists');

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allServicesPagedResults[currentRequestIndex] = services;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allServicesPagedResults.add(services);
        }

        // #11: Concatenate the full list to be shown
        var allServices = _allServicesPagedResults.fold<List<ServiceState>>([],
                (initialValue, pageItems) => initialValue..addAll(pageItems));
        debugPrint('ALL SERVICES LENGTH: ${allServices.length}');
        allServices.forEach((element) {
          //debugPrint('SERVICE NAME: ${element.name}');
        });

        // #12: Broadcase all posts
        serviceController.add(allServices);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allServicesPagedResults.length - 1) {
          _lastServiceDocument = servicesSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMorePosts = services.length == ServicesLimit;
        Future.delayed(Duration(seconds: 1), (){
          updateIndicator(false);
        });
      }
    });
  }

  void dispose() {
    serviceController.close();
  }
}