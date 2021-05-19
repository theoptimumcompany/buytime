import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';

class SetOrderDetail {
  OrderDetailState _orderState;
  SetOrderDetail(this._orderState);
  OrderDetailState get orderState => _orderState;
}
class SetOrderDetailToEmpty {
  String _something;
  SetOrderDetailToEmpty(this._something);
  String get something => _something;
}
class OrderDetailRequest {
  String _orderStateId;
  OrderDetailRequest(this._orderStateId);
  String get orderStateId => _orderStateId;
}
class AddItemToOrderDetail {
  OrderEntry _orderEntry;
  AddItemToOrderDetail(this._orderEntry);
  OrderEntry get orderEntry => _orderEntry;
}
class UpdateOrderDetail {
  OrderDetailState _orderState;
  UpdateOrderDetail(this._orderState);
  OrderDetailState get orderState => _orderState;
}
class UpdateOrderDetailByManager{
  OrderDetailState _orderState;
  OrderStatus _orderStatus;
  UpdateOrderDetailByManager(this._orderState, this._orderStatus);
  OrderDetailState get orderState => _orderState;
  OrderStatus get orderStatus => _orderStatus;
}
class UpdatedOrderDetail {
  OrderDetailState _orderState;
  UpdatedOrderDetail(this._orderState);
  OrderDetailState get orderState => _orderState;
}
class CreateOrderDetail {
  OrderDetailState _orderState;
  CreateOrderDetail(this._orderState);
  OrderDetailState get orderState => _orderState;
}
class CreateOrderDetailCardAndPay {
  OrderDetailState _orderState;
  String _last4;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderDetailCardAndPay(this._orderState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType, this._context, this._businessStripeAccount);
  OrderDetailState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get last4 => _last4;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}
class CreateOrderDetailNativeAndPay {
  OrderDetailState _orderState;
  StripeRecommended.PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderDetailNativeAndPay(this._orderState, this._paymentMethod, this._paymentType, this._context, this._businessStripeAccount);
  OrderDetailState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}

class CreateOrderDetailRoomAndPay {
  OrderDetailState _orderState;
  String _roomNumber;
  PaymentType _paymentType;
  CreateOrderDetailRoomAndPay(this._orderState, this._roomNumber, this._paymentType);
  OrderDetailState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get roomNumber => _roomNumber;
}

class CreateOrderDetailCardPending {
  OrderDetailState _orderState;
  String _last4;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  CreateOrderDetailCardPending(this._orderState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType);
  OrderDetailState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get last4 => _last4;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
}
class CreateOrderDetailNativePending {
  OrderDetailState _orderState;
  StripeRecommended.PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  CreateOrderDetailNativePending(this._orderState, this._paymentMethod, this._paymentType);
  OrderDetailState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
}
class CreateOrderDetailRoomPending {
  OrderDetailState _orderState;
  String _roomNumber;
  PaymentType _paymentType;
  CreateOrderDetailRoomPending(this._orderState, this._roomNumber, this._paymentType);
  OrderDetailState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get roomNumber => _roomNumber;
}

class CreatedOrderDetail {}
class CreatingOrderDetail {}
class ResetOrderDetailIfPaidOrCanceled {}
class DeleteOrderDetail {
  String _orderId;
  DeleteOrderDetail(this._orderId);
  String get orderId => _orderId;
}
class DeletedOrderDetail {
  OrderDetailState _orderState;
  DeletedOrderDetail();
  OrderDetailState get orderState => _orderState;
}
class OrderDetailRequestResponse {
  OrderDetailState _orderState;
  OrderDetailRequestResponse(this._orderState);
  OrderDetailState get orderState => _orderState;
}
class SetOrderDetailDate
{
  DateTime _date;
  SetOrderDetailDate(this._date);
  DateTime get date => _date;
}
class SetOrderDetailPosition
{
  String _position;
  SetOrderDetailPosition(this._position);
  String get position => _position;
}
class SetOrderDetailProgress
{
  String _progress;
  SetOrderDetailProgress(this._progress);
  String get progress => _progress;
}

class SetOrderDetailOrderDetailId
{
  String _orderId;
  SetOrderDetailOrderDetailId(this._orderId);
  String get orderId => _orderId;
}

class SetOrderDetailPaymentMethod
{
  StripeRecommended.PaymentMethod _paymentMethod;
  SetOrderDetailPaymentMethod(this._paymentMethod);
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
}
class SetOrderDetailCartCounter
{
  int _cartCounter;
  SetOrderDetailCartCounter(this._cartCounter);
  int get cartCounter => _cartCounter;
}
class SetOrderDetailBusiness
{
  OrderBusinessSnippetState _business;
  SetOrderDetailBusiness(this._business);
  OrderBusinessSnippetState get business => _business;
}
class SetOrderDetailUser
{
  UserSnippet _user;
  SetOrderDetailUser(this._user);
  UserSnippet get user => _user;
}
class ConfirmOrderDetailWait
{
  bool _confirmOrderDetailWait;
  ConfirmOrderDetailWait(this._confirmOrderDetailWait);
  bool get confirmOrderDetailWait => _confirmOrderDetailWait;
}
class AddingStripePaymentMethod {
  AddingStripePaymentMethod();
}
class AddingStripePaymentMethodReset {
  AddingStripePaymentMethodReset();
}
class DeletingStripePaymentMethod {
  DeletingStripePaymentMethod();
}
class DeletedStripePaymentMethod {
  DeletedStripePaymentMethod();
}
class AddedStripePaymentMethod
{
  AddedStripePaymentMethod();
}
OrderDetailState orderDetailReducer(OrderDetailState state, action) {
  OrderDetailState orderState = new OrderDetailState.fromState(state);
  if (action is SetOrderDetailDate) {
    orderState.date = action.date;
    return orderState;
  }
  if (action is SetOrderDetailPosition) {
    orderState.position = action.position;
    return orderState;
  }
  if (action is SetOrderDetailProgress) {
    orderState.progress = action.progress;
    return orderState;
  }
  if (action is SetOrderDetailOrderDetailId) {
    orderState.orderId = action.orderId;
    return orderState;
  }
  if (action is SetOrderDetailPaymentMethod) {
    orderState.paymentMethod = action.paymentMethod;
    return orderState;
  }
  if (action is SetOrderDetailBusiness) {
    orderState.business = action.business;
    return orderState;
  }
  if (action is SetOrderDetailUser) {
    orderState.user = action.user;
    return orderState;
  }
  if (action is OrderDetailRequestResponse) {
    orderState = action.orderState.copyWith();
    return orderState;
  }
  if (action is SetOrderDetail) {
    orderState = action.orderState.copyWith();
    return orderState;
  }
  if (action is CreatingOrderDetail) {
    orderState.progress = Utils.enumToString(OrderStatus.creating);
    return orderState;
  }
  if (action is CreatedOrderDetail) {
    orderState.progress = Utils.enumToString(OrderStatus.unpaid);
    return orderState;
  }
  if (action is SetOrderDetailCartCounter) {
    orderState.cartCounter = action.cartCounter;
    return orderState;
  }
  if (action is SetOrderDetailToEmpty) {
    orderState = OrderDetailState().toEmpty();
    return orderState;
  }
  if (action is AddingStripePaymentMethod) {
    orderState.addCardProgress = Utils.enumToString(AddCardStatus.inProgress);
    return orderState;
  }
  if (action is AddingStripePaymentMethodReset) {
    orderState.addCardProgress = Utils.enumToString(AddCardStatus.notStarted);
    return orderState;
  }
  if (action is AddedStripePaymentMethod) {
    orderState.addCardProgress = Utils.enumToString(AddCardStatus.done);
    return orderState;
  }
  if (action is ResetOrderDetailIfPaidOrCanceled) {
    if (orderState.progress == Utils.enumToString(OrderStatus.paid) 
        || orderState.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
        || orderState.progress == Utils.enumToString(OrderStatus.canceled)
    )
    return orderState.toEmpty();
  }
  if (action is DeletingStripePaymentMethod) {
    orderState.addCardProgress = Utils.enumToString(AddCardStatus.inProgress);
    return orderState;
  }
  if (action is DeletedStripePaymentMethod) {
    orderState.addCardProgress = Utils.enumToString(AddCardStatus.done);
    return orderState;
  }
  if (action is AddItemToOrderDetail) {
    if (state.itemList != null) {
      print("order_reducer: itemList != null");
      orderState.itemList
      = []
        ..addAll(state.itemList)
        ..add(action.orderEntry);
    } else {
      print("order_reducer: itemList == null");
      orderState.itemList
      = []
        ..add(action.orderEntry);
    }
    return orderState;
  }
  return state;
}