import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/widgets.dart';
// import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class RefundOrderByUser {
  String _orderStateId;
  RefundOrderByUser(this._orderStateId);
  String get orderStateId => _orderStateId;
}

class RefundedRequestDone {
  RefundedRequestDone();
}

class SetOrder {
  OrderState _orderState;
  SetOrder(this._orderState);
  OrderState get orderState => _orderState;
}
class SetOrderToEmpty {
  String _something;
  SetOrderToEmpty(this._something);
  String get something => _something;
}
class OrderRequest {
  String _orderStateId;
  OrderRequest(this._orderStateId);
  String get orderStateId => _orderStateId;
}
class AddItemToOrder {
  OrderEntry _orderEntry;
  AddItemToOrder(this._orderEntry);
  OrderEntry get orderEntry => _orderEntry;
}
class UpdateOrder {
  OrderState _orderState;
  UpdateOrder(this._orderState);
  OrderState get orderState => _orderState;
}
class UpdateOrderByManager{
  OrderState _orderState;
  OrderStatus _orderStatus;
  String cancellationReason = '';
  UpdateOrderByManager(this._orderState, this._orderStatus, {this.cancellationReason});
  OrderState get orderState => _orderState;
  OrderStatus get orderStatus => _orderStatus;
}
class UpdatedOrder {
  OrderState _orderState;
  UpdatedOrder(this._orderState);
  OrderState get orderState => _orderState;
}
class CreateOrder {
  OrderState _orderState;
  CreateOrder(this._orderState);
  OrderState get orderState => _orderState;
}
class CreateOrderCardAndPay {
  OrderState _orderState;
  String _last4;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderCardAndPay(this._orderState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType, this._context, this._businessStripeAccount);
  OrderState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get last4 => _last4;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}
class CreateOrderNativeAndPay {
  OrderState _orderState;
  PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderNativeAndPay(this._orderState, this._paymentMethod, this._paymentType, this._context, this._businessStripeAccount);
  OrderState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  PaymentMethod get paymentMethod => _paymentMethod;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}

class CreateOrderRoomAndPay {
  OrderState _orderState;
  String _roomNumber;
  PaymentType _paymentType;
  CreateOrderRoomAndPay(this._orderState, this._roomNumber, this._paymentType);
  OrderState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get roomNumber => _roomNumber;
}

class CreateOrderCardPending {
  OrderState _orderState;
  String _last4;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  CreateOrderCardPending(this._orderState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType);
  OrderState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get last4 => _last4;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
}
class CreateOrderNativePending {
  OrderState _orderState;
  PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  CreateOrderNativePending(this._orderState, this._paymentMethod, this._paymentType);
  OrderState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  PaymentMethod get paymentMethod => _paymentMethod;
}
class CreateOrderRoomPending {
  OrderState _orderState;
  String _roomNumber;
  PaymentType _paymentType;
  CreateOrderRoomPending(this._orderState, this._roomNumber, this._paymentType);
  OrderState get orderState => _orderState;
  PaymentType get paymentType => _paymentType;
  String get roomNumber => _roomNumber;
}

class CreatedOrder {}
class CreatingOrder {}
class ResetOrderIfPaidOrCanceled {}
class DeleteOrder {
  String _orderId;
  DeleteOrder(this._orderId);
  String get orderId => _orderId;
}
class DeletedOrder {
  OrderState _orderState;
  DeletedOrder();
  OrderState get orderState => _orderState;
}
class OrderRequestResponse {
  OrderState _orderState;
  OrderRequestResponse(this._orderState);
  OrderState get orderState => _orderState;
}
class SetOrderDate
{
  DateTime _date;
  SetOrderDate(this._date);
  DateTime get date => _date;
}
class SetOrderPosition
{
  String _position;
  SetOrderPosition(this._position);
  String get position => _position;
}
class SetOrderProgress
{
  String _progress;
  SetOrderProgress(this._progress);
  String get progress => _progress;
}

class SetOrderOrderId
{
  String _orderId;
  SetOrderOrderId(this._orderId);
  String get orderId => _orderId;
}

class SetOrderPaymentMethod
{
  PaymentMethod _paymentMethod;
  SetOrderPaymentMethod(this._paymentMethod);
  PaymentMethod get paymentMethod => _paymentMethod;
}
class SetOrderCartCounter
{
  int _cartCounter;
  SetOrderCartCounter(this._cartCounter);
  int get cartCounter => _cartCounter;
}
class SetOrderBusiness
{
  OrderBusinessSnippetState _business;
  SetOrderBusiness(this._business);
  OrderBusinessSnippetState get business => _business;
}
class SetOrderUser
{
  UserSnippet _user;
  SetOrderUser(this._user);
  UserSnippet get user => _user;
}
class SetOrderCancellationReason
{
  String _cancellationReason;
  SetOrderCancellationReason(this._cancellationReason);
  String get cancellationReason => _cancellationReason;
}

class ConfirmOrderWait
{
  bool _confirmOrderWait;
  ConfirmOrderWait(this._confirmOrderWait);
  bool get confirmOrderWait => _confirmOrderWait;
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
OrderState orderReducer(OrderState state, action) {
  OrderState orderState = new OrderState.fromState(state);
  if (action is SetOrderDate) {
    orderState.date = action.date;
    return orderState;
  }
  if (action is SetOrderPosition) {
    orderState.position = action.position;
    return orderState;
  }
  if (action is SetOrderProgress) {
    orderState.progress = action.progress;
    return orderState;
  }
  if (action is SetOrderOrderId) {
    orderState.orderId = action.orderId;
    return orderState;
  }
  if (action is SetOrderPaymentMethod) {
    orderState.paymentMethod = action.paymentMethod;
    return orderState;
  }
  if (action is SetOrderBusiness) {
    orderState.business = action.business;
    return orderState;
  }
  if (action is SetOrderUser) {
    orderState.user = action.user;
    return orderState;
  }
  if (action is SetOrderCancellationReason) {
    orderState.cancellationReason = action.cancellationReason;
    return orderState;
  }
  if (action is OrderRequestResponse) {
    orderState = action.orderState.copyWith();
    return orderState;
  }
  if (action is SetOrder) {
    orderState = action.orderState.copyWith();
    return orderState;
  }
  if (action is CreatingOrder) {
    orderState.progress = Utils.enumToString(OrderStatus.creating);
    return orderState;
  }
  if (action is CreatedOrder) {
    //orderState.progress = Utils.enumToString(OrderStatus.unpaid);
    orderState = OrderState().toEmpty();
    return orderState;
  }
  if (action is SetOrderCartCounter) {
    orderState.cartCounter = action.cartCounter;
    return orderState;
  }
  if (action is SetOrderToEmpty) {
    orderState = OrderState().toEmpty();
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
  if (action is ResetOrderIfPaidOrCanceled) {
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
  if (action is RefundedRequestDone) {
    orderState.progress = Utils.enumToString(OrderStatus.canceled);
    return orderState;
  }
  if (action is DeletedStripePaymentMethod) {
    orderState.addCardProgress = Utils.enumToString(AddCardStatus.done);
    return orderState;
  }
  if (action is AddItemToOrder) {
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