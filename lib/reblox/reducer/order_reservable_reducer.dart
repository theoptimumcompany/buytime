import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';

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

class CreatedOrderReservable {
  OrderReservableState _orderReservableState;
  CreatedOrderReservable(this._orderReservableState);
  OrderReservableState get orderReservableState => _orderReservableState;
}

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

class SetOrderReservableCartCounter
{
  int _cartCounter;
  SetOrderReservableCartCounter(this._cartCounter);
  int get cartCounter => _cartCounter;
}

class SetOrderReservableBusiness
{
  BusinessSnippet _business;
  SetOrderReservableBusiness(this._business);
  BusinessSnippet get business => _business;
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