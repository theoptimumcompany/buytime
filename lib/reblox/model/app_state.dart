import 'package:BuyTime/reblox/model/business/business_list_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/category/category_list_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/order/order_list_state.dart';
import 'package:BuyTime/reblox/model/order/order_state.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:BuyTime/reblox/model/service/service_list_state.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/model/stripe/stripe_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:flutter/foundation.dart';
import 'category/tree/category_tree_state.dart';
import 'old/filter_search_state.dart';

class AppRoutes {
  static const home = "/home";
  static const login = "/login";
  static const registration = "/history";
  static const orderDetail = "/orderDetail";
}

class AppState {
  FilterSearchState filterSearch;
  BusinessState business;
  BusinessListState businessList;
  OrderState order;
  OrderListState orderList;
  StripeState stripe;
  UserState user;
  CategoryState category;
  CategoryListState categoryList;
  CategoryTree categoryTree;
  ServiceState serviceState;
  ServiceListState serviceList;
  Pipeline pipeline;
  PipelineList pipelineList;
  List<String> route;

  AppState({
    @required this.filterSearch,
    @required this.business,
    @required this.order,
    @required this.orderList,
    @required this.stripe,
    @required this.businessList,
    @required this.user,
    @required this.category,
    @required this.categoryList,
    @required this.categoryTree,
    @required this.serviceState,
    @required this.serviceList,
    @required this.pipeline,
    @required this.pipelineList,
    this.route = const [AppRoutes.home],
  });

  AppState.initialState() {
    filterSearch = FilterSearchState();
    business = BusinessState();
    order = OrderState();
    stripe = StripeState();
    orderList = OrderListState();
    businessList = BusinessListState();
    user = UserState();
    category = CategoryState();
    categoryList = CategoryListState();
    categoryTree = CategoryTree();
    serviceState = ServiceState();
    serviceList = ServiceListState();
    pipeline = Pipeline();
    pipelineList = PipelineList();
  }

  AppState.copyWith(
      {FilterSearchState filterSearch,
      BusinessState business,
      OrderState order,
      OrderListState orderList,
      StripeState stripe,
      BusinessListState businessList,
      UserState user,
      CategoryState category,
      CategoryListState categoryList,
      CategoryTree categoryTree,
      ServiceState serviceState,
      ServiceListState serviceList,
      Pipeline pipeline,
      PipelineList pipelineList,
      List<String> route}) {
    this.filterSearch = filterSearch;
    this.business = business;
    this.order = order;
    this.orderList = orderList;
    this.stripe = stripe;
    this.businessList = businessList;
    this.user = user;
    this.category = category;
    this.categoryList = categoryList;
    this.categoryTree = categoryTree;
    this.serviceState = serviceState;
    this.serviceList = serviceList;
    this.pipeline = pipeline;
    this.pipelineList = pipelineList;
    this.route = route;
  }

  AppState.fromJson(Map json) {
    filterSearch = json['filterSearch'];
    business = json['business'];
    order = json['order'];
    orderList = json['orderList'];
    stripe = json['stripe'];
    businessList = json['businessList'];
    user = json['user'];
    category = json['category'];
    categoryList = json['categoryList'];
    categoryTree = json['categoryTree'];
    serviceState = json['serviceState'];
    serviceList = json['serviceList'];
    pipeline = json['pipeline'];
    pipelineList = json['pipelineList'];
    route = json['route'];
  }

  Map toJson() => {
        'filterSearch': filterSearch,
        'business': business,
        'order': order,
        'orderList': orderList,
        'stripe': stripe,
        'businessList': businessList,
        'user': user,
        'category': category,
        'categoryList': categoryList,
        'categoryTree': categoryTree,
        'serviceState': serviceState,
        'serviceList': serviceList,
        'pipeline': pipeline,
        'pipelineList': pipelineList,
        'route': route,
      };
}
