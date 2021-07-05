import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/email/email_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/area_list_reducer.dart';
import 'package:Buytime/reblox/reducer/area_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_reducer.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/email_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_list_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/reservations_orders_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/reservations_orders_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/slot_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'package:Buytime/utils/globals.dart';

import 'business_reducer.dart';
import 'business_list_reducer.dart';
import 'category_reducer.dart';
import 'category_tree_reducer.dart';
import 'order_detail_reducer.dart';

class ClickOnBusinessState {}
class ErrorAction {
  String _error;
  ErrorAction(this._error);
  String get error => _error;
}
class ErrorReset {}

AppState appReducer(AppState state, dynamic action) {
  BusinessState businessState = businessReducer(state.business, action);
  AreaState areaState = areaReducer(state.area, action);
  AreaListState areaListState = areaListReducer(state.areaList, action);
  ExternalBusinessState externalBusinessState = externalBusinessReducer(state.externalBusiness, action);
  BookingState bookingState = bookingReducer(state.booking, action);
  OrderState orderState = orderReducer(state.order, action);
  OrderDetailState orderDetailState = orderDetailReducer(state.orderDetail, action);
  OrderReservableState orderReservableState = orderReservableReducer(state.orderReservable, action);
  OrderListState orderListState = orderListReducer(state.orderList, action);
  OrderReservableListState orderReservableListState = orderReservableListReducer(state.orderReservableList, action);
  BusinessListState businessListState = businessListReducer(state.businessList, action);
  ExternalBusinessListState externalBusinessListState = externalBusinessListReducer(state.externalBusinessList, action);
  BookingListState bookingListState = bookingListReducer(state.bookingList, action);
  StripeState stripeState = stripePaymentReducer(state.stripe, action);
  UserState userState = userReducer(state.user, action);
  CategoryState categoryState = categoryReducer(state.category, action);
  CategoryInviteState categoryInviteState = categoryInviteReducer(state.categoryInvite, action);
  CategoryListState categoryListState = categoryListReducer(state.categoryList, action);
  ServiceState serviceState = serviceReducer(state.serviceState, action);
  ServiceListState serviceListState = serviceListReducer(state.serviceList, action);
  ServiceSlot serviceSlot = serviceSlotReducer(state.serviceSlot, action);
  Pipeline pipeline = pipelineReducer(state.pipeline, action);
  PipelineList pipelineList = pipelineListReducer(state.pipelineList, action);
  StatisticsState statisticsState = statisticsReducer(state.statistics, action);
  CardState cardState = cardReducer(state.cardState, action);
  CardListState cardListState = cardListReducer(state.cardListState, action);
  AutoCompleteState autoCompleteState = autoCompleteReducer(state.autoCompleteState, action);
  AutoCompleteListState autoCompleteListState = autoCompleteListReducer(state.autoCompleteListState, action);
  NotificationState notificationState = notificationReducer(state.notificationState, action);
  NotificationListState notificationListState = notificationListReducer(state.notificationListState, action);
  EmailState emailState = emailReducer(state.emailState, action);
  String lastError = "";
  String previousError = "";
  ServiceListSnippetState serviceListSnippetState = serviceListSnippetReducer(state.serviceListSnippetState, action);
  ServiceListSnippetListState serviceListSnippetListState = serviceListSnippetListReducer(state.serviceListSnippetListState, action);
  ExternalBusinessImportedState externalBusinessImportedState = externalBusinessImportedReducer(state.externalBusinessImportedState, action);
  ExternalBusinessImportedListState externalBusinessImportedListState = externalBusinessImportedListReducer(state.externalBusinessImportedListState, action);
  ExternalServiceImportedState externalServiceImportedState = externalServiceImportedReducer(state.externalServiceImportedState, action);
  ExternalServiceImportedListState externalServiceImportedListState = externalServiceImportedListReducer(state.externalServiceImportedListState, action);
  SlotListSnippetState slotSnippetListState = slotListSnippetReducer(state.slotSnippetListState, action);
  ReservationsOrdersListSnippetState reservationsOrdersListSnippetState = reservationsOrdersListSnippetReducer(state.reservationsOrdersListSnippetState, action);
  ReservationsOrdersListSnippetListState reservationsOrdersListSnippetListState = reservationsOrdersListSnippetListReducer(state.reservationsOrdersListSnippetListState, action);

  AppState newState = AppState.copyWith(
      //route: navigationReducer(state.route, action),
      business: businessState,
      area: areaState,
      areaList: areaListState,
      externalBusiness: externalBusinessState,
      booking: bookingState,
      order: orderState,
      orderDetail: orderDetailState,
      orderReservable: orderReservableState,
      orderList: orderListState,
      orderReservableList: orderReservableListState,
      businessList: businessListState,
      externalBusinessList: externalBusinessListState,
      bookingList: bookingListState,
      user: userState,
      stripe: stripeState,
      category: categoryState,
      categoryInvite: categoryInviteState,
      categoryList: categoryListState,
      serviceState: serviceState,
      serviceList: serviceListState,
      serviceSlot: serviceSlot,
      pipeline: pipeline,
      pipelineList: pipelineList,
      route: navigationReducer(state.route, action),
      statistics: statisticsState,
      cardState: cardState,
      cardListState: cardListState,
      autoCompleteState: autoCompleteState,
      autoCompleteListState: autoCompleteListState,
      notificationState: notificationState,
      notificationListState: notificationListState,
      emailState: emailState,
      lastError: lastError,
      previousError: previousError,
      serviceListSnippetState: serviceListSnippetState,
      serviceListSnippetListState: serviceListSnippetListState,
      reservationsOrdersListSnippetState: reservationsOrdersListSnippetState,
      reservationsOrdersListSnippetListState: reservationsOrdersListSnippetListState,
      externalBusinessImportedState: externalBusinessImportedState,
      externalBusinessImportedListState: externalBusinessImportedListState,
    externalServiceImportedState: externalServiceImportedState,
    externalServiceImportedListState: externalServiceImportedListState,
      slotSnippetListState: slotSnippetListState
  );

  if (action is ClickOnBusinessState) {
    // reset the store before going to the service list
    newState.order = OrderState().toEmpty();
    newState.serviceList = ServiceListState().toEmpty();
    newState.serviceState = ServiceState().toEmpty();
    //cartCounter = 0;
  }

  if (action is ErrorAction) {
    // reset the store before going to the service list
    newState.lastError = action.error;
    return newState;
    //cartCounter = 0;
  }

  if (action is ErrorReset) {
    // reset the store before going to the service list
    newState.lastError = "";
    return newState;
    //cartCounter = 0;
  }

  return newState;
}
