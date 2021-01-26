import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/old/filter_search_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/utils/globals.dart';

import 'business_reducer.dart';
import 'business_list_reducer.dart';
import 'category_reducer.dart';
import 'category_tree_reducer.dart';
import 'filter_reducer.dart';

class ClickOnBusinessState {
}



AppState appReducer(AppState state, dynamic action) {
  FilterSearchState filterSearchState = filterReducer(state.filterSearch, action);
  BusinessState businessState = businessReducer(state.business, action);
  OrderState orderState = orderReducer(state.order, action);
  OrderListState orderListState = orderListReducer(state.orderList, action);
  BusinessListState businessListState = businessListReducer(state.businessList, action);
  StripeState stripeState = stripePaymentReducer(state.stripe, action);
  UserState userState = userReducer(state.user, action);
  CategoryState categoryState = categoryReducer(state.category, action);
  CategoryListState categoryListState = categoryListReducer(state.categoryList, action);
  CategoryTree categoryTree = categoryTreeReducer(state.categoryTree, action);
  ServiceState serviceState = serviceReducer(state.serviceState, action);
  ServiceListState serviceListState = serviceListReducer(state.serviceList, action);
  Pipeline pipeline = pipelineReducer(state.pipeline, action);
  PipelineList pipelineList = pipelineListReducer(state.pipelineList, action);


  AppState newState = AppState.copyWith(
    filterSearch: filterSearchState,
    business: businessState,
    order: orderState,
    orderList: orderListState,
    businessList: businessListState,
    user: userState,
    stripe: stripeState,
    category: categoryState,
    categoryList: categoryListState,
    categoryTree: categoryTree,
    serviceState: serviceState,
    serviceList: serviceListState,
    pipeline: pipeline,
    pipelineList: pipelineList,
  );

  if (action is ClickOnBusinessState) { // reset the store before going to the service list
    newState.order = OrderState().toEmpty();
    newState.serviceList = ServiceListState().toEmpty();
    newState.serviceState = ServiceState().toEmpty();
    cartCounter = 0;
  }


  return newState;
}

