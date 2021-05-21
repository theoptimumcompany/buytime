import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;


class CreateOrderReservableCardAndPay {
  BuildContext _context;
  OrderReservableState _orderReservableState;
  String _last4;
  String _businessStripeAccount;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  CreateOrderReservableCardAndPay(this._orderReservableState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  BuildContext get context => _context;
  String get last4 => _last4;
  String get businessStripeAccount => _businessStripeAccount;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
}


class CreateOrderReservableCardAndHold {
  BuildContext _context;
  OrderReservableState _orderReservableState;
  String _last4;
  String _businessStripeAccount;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  CreateOrderReservableCardAndHold(this._orderReservableState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  BuildContext get context => _context;
  String get last4 => _last4;
  String get businessStripeAccount => _businessStripeAccount;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
}
class CreateOrderReservableCardAndReminder {
  BuildContext _context;
  OrderReservableState _orderReservableState;
  String _last4;
  String _businessStripeAccount;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  CreateOrderReservableCardAndReminder(this._orderReservableState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  BuildContext get context => _context;
  String get last4 => _last4;
  String get businessStripeAccount => _businessStripeAccount;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
}
class CreateOrderReservableCardPending {
  BuildContext _context;
  OrderReservableState _orderReservableState;
  String _last4;
  String _businessStripeAccount;
  String _brand;
  String _country;
  String _selectedCardPaymentMethodId;
  PaymentType _paymentType;
  CreateOrderReservableCardPending(this._orderReservableState, this._last4, this._brand, this._country, this._selectedCardPaymentMethodId, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
  String get last4 => _last4;
  String get brand => _brand;
  String get country => _country;
  String get selectedCardPaymentMethodId => _selectedCardPaymentMethodId;
}
class CreateOrderReservableNativeAndPay {
  OrderReservableState _orderReservableState;
  StripeRecommended.PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderReservableNativeAndPay(this._orderReservableState, this._paymentMethod, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}
class CreateOrderReservableNativeAndHold {
  OrderReservableState _orderReservableState;
  StripeRecommended.PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderReservableNativeAndHold(this._orderReservableState, this._paymentMethod, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}
class CreateOrderReservableNativeAndReminder {
  OrderReservableState _orderReservableState;
  StripeRecommended.PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderReservableNativeAndReminder(this._orderReservableState, this._paymentMethod, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}
class CreateOrderReservableNativePending {
  OrderReservableState _orderReservableState;
  StripeRecommended.PaymentMethod _paymentMethod;
  PaymentType _paymentType;
  String _businessStripeAccount;
  BuildContext _context;
  CreateOrderReservableNativePending(this._orderReservableState, this._paymentMethod, this._paymentType, this._context, this._businessStripeAccount);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
  BuildContext get context => _context;
  String get businessStripeAccount => _businessStripeAccount;
}

class CreateOrderReservableRoomAndPay {
  OrderReservableState _orderReservableState;
  String _roomNumber;
  PaymentType _paymentType;
  CreateOrderReservableRoomAndPay(this._orderReservableState, this._roomNumber, this._paymentType);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  String get roomNumber => _roomNumber;
}

class CreateOrderReservableRoomPending {
  OrderReservableState _orderReservableState;
  String _roomNumber;
  PaymentType _paymentType;
  CreateOrderReservableRoomPending(this._orderReservableState, this._roomNumber, this._paymentType);
  OrderReservableState get orderReservableState => _orderReservableState;
  PaymentType get paymentType => _paymentType;
  String get roomNumber => _roomNumber;
}

class SetOrderReservablePaymentMethod
{
  StripeRecommended.PaymentMethod _paymentMethod;
  SetOrderReservablePaymentMethod(this._paymentMethod);
  StripeRecommended.PaymentMethod get paymentMethod => _paymentMethod;
}


class SetOrderReservable {
  OrderReservableState _orderReservableState;
  SetOrderReservable(this._orderReservableState);
  OrderReservableState get orderReservableState => _orderReservableState;
}

class SetOrderReservableToEmpty {
  String _something;
  SetOrderReservableToEmpty(this._something);
  String get something => _something;
}


class OrderReservableRequest {
  String _orderReservableStateId;
  OrderReservableRequest(this._orderReservableStateId);
  String get orderReservableStateId => _orderReservableStateId;
}

class AddItemToOrderReservable {
  OrderEntry _orderReservableEntry;
  AddItemToOrderReservable(this._orderReservableEntry);
  OrderEntry get orderReservableEntry => _orderReservableEntry;
}

class UpdateOrderReservable {
  OrderReservableState _orderReservableState;
  UpdateOrderReservable(this._orderReservableState);
  OrderReservableState get orderReservableState => _orderReservableState;
}

class UpdatedOrderReservable {
  OrderReservableState _orderReservableState;
  UpdatedOrderReservable(this._orderReservableState);
  OrderReservableState get orderReservableState => _orderReservableState;
}

class CreateOrderReservable {
  OrderReservableState _orderReservableState;
  CreateOrderReservable(this._orderReservableState);
  OrderReservableState get orderReservableState => _orderReservableState;
}

class CreatedOrderReservable {}

class DeleteOrderReservable {
  String _orderReservableId;
  DeleteOrderReservable(this._orderReservableId);
  String get orderReservableId => _orderReservableId;
}

class DeletedOrderReservable {
  OrderReservableState _orderReservableState;
  DeletedOrderReservable();
  OrderReservableState get orderReservableState => _orderReservableState;
}

class OrderReservableRequestResponse {
  OrderReservableState _orderReservableState;
  OrderReservableRequestResponse(this._orderReservableState);
  OrderReservableState get orderReservableState => _orderReservableState;
}

class SetOrderReservableDate
{
  DateTime _date;
  SetOrderReservableDate(this._date);
  DateTime get date => _date;
}

class SetOrderReservablePosition
{
  String _position;
  SetOrderReservablePosition(this._position);
  String get position => _position;
}

class SetOrderReservableProgress
{
  String _progress;
  SetOrderReservableProgress(this._progress);
  String get progress => _progress;
}

class SetOrderReservableOrderId
{
  String _orderId;
  SetOrderReservableOrderId(this._orderId);
  String get orderId => _orderId;
}

class SetOrderReservableCartCounter
{
  int _cartCounter;
  SetOrderReservableCartCounter(this._cartCounter);
  int get cartCounter => _cartCounter;
}

class SetOrderReservableBusiness
{
  OrderBusinessSnippetState _business;
  SetOrderReservableBusiness(this._business);
  OrderBusinessSnippetState get business => _business;
}

class SetOrderReservableUser
{
  UserSnippet _user;
  SetOrderReservableUser(this._user);
  UserSnippet get user => _user;
}

class AddingReservableStripePaymentMethod {
  AddingReservableStripePaymentMethod();
}

class AddingReservableStripePaymentMethodWithNavigation {
  String _userId;
  AddingReservableStripePaymentMethodWithNavigation(this._userId);
  String get userId => _userId;
}
class AddedReservableStripePaymentMethod
{
  AddedReservableStripePaymentMethod();
}

class AddedReservableStripePaymentMethodAndNavigate
{
  AddedReservableStripePaymentMethodAndNavigate();
}

OrderReservableState orderReservableReducer(OrderReservableState state, action) {
  OrderReservableState orderReservableState = new OrderReservableState.fromState(state);
  if (action is SetOrderReservableDate) {
    orderReservableState.date = action.date;
    return orderReservableState;
  }
  if (action is SetOrderReservablePosition) {
    orderReservableState.position = action.position;
    return orderReservableState;
  }
  if (action is SetOrderReservableProgress) {
    orderReservableState.progress = action.progress;
    return orderReservableState;
  }
  if (action is SetOrderReservableOrderId) {
    orderReservableState.orderId = action.orderId;
    return orderReservableState;
  }
  if (action is SetOrderReservableBusiness) {
    orderReservableState.business = action.business;
    return orderReservableState;
  }
  if (action is SetOrderReservableUser) {
    orderReservableState.user = action.user;
    return orderReservableState;
  }
  if (action is OrderReservableRequestResponse) {
    orderReservableState = action.orderReservableState.copyWith();
    return orderReservableState;
  }
  if (action is SetOrderReservable) {
    orderReservableState = action.orderReservableState.copyWith();
    return orderReservableState;
  }
  if (action is SetOrderReservableCartCounter) {
    orderReservableState.cartCounter = action.cartCounter;
    return orderReservableState;
  }
  if (action is SetOrderReservableToEmpty) {
    orderReservableState = OrderReservableState().toEmpty();
    return orderReservableState;
  }
  if (action is AddingReservableStripePaymentMethod) {
    orderReservableState.addCardProgress = "inProgress";
    return orderReservableState;
  }
  if (action is AddingReservableStripePaymentMethodWithNavigation) {
    orderReservableState.addCardProgress = "inProgress";
    return orderReservableState;
  }
  if (action is AddedReservableStripePaymentMethod) {
    orderReservableState.addCardProgress = "done";
    return orderReservableState;
  }
  if (action is AddedReservableStripePaymentMethodAndNavigate) {
    orderReservableState.addCardProgress = "done";
    orderReservableState.navigate = true;
    return orderReservableState;
  }
  if (action is SetOrderReservablePaymentMethod) {
    orderReservableState.paymentMethod = action.paymentMethod;
    return orderReservableState;
  }
  if (action is AddItemToOrderReservable) {
    if (state.itemList != null) {
      print("orderReservable_reducer: itemList != null");
      orderReservableState.itemList
      = []
        ..addAll(state.itemList)
        ..add(action.orderReservableEntry);
    } else {
      print("orderReservable_reducer: itemList == null");
      orderReservableState.itemList
      = []
        ..add(action.orderReservableEntry);
    }
    return orderReservableState;
  }
  return state;
}