import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';

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
  UpdateOrderByManager(this._orderState);
  OrderState get orderState => _orderState;
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

class CreatedOrder {
  OrderState _orderState;
  CreatedOrder(this._orderState);
  OrderState get orderState => _orderState;
}

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

class AddingStripePaymentMethodWithNavigation {
  String _userId;
  AddingStripePaymentMethodWithNavigation(this._userId);
  String get userId => _userId;
}
class AddedStripePaymentMethod
{
  AddedStripePaymentMethod();
}

class AddedStripePaymentMethodAndNavigate
{
  AddedStripePaymentMethodAndNavigate();
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
  if (action is SetOrderBusiness) {
    orderState.business = action.business;
    return orderState;
  }
  if (action is SetOrderUser) {
    orderState.user = action.user;
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
  if (action is SetOrderCartCounter) {
    orderState.cartCounter = action.cartCounter;
    //orderState = action.orderState.copyWith();
    return orderState;
  }
  if (action is SetOrderToEmpty) {
    orderState = OrderState().toEmpty();
    return orderState;
  }
  if (action is AddingStripePaymentMethod) {
    orderState.addCardProgress = "inProgress";
    return orderState;
  }
  if (action is AddingStripePaymentMethodReset) {
    orderState.addCardProgress = "notStarted";
    return orderState;
  }
  if (action is AddedStripePaymentMethod) {
    orderState.addCardProgress = "done";
    return orderState;
  }
  if (action is DeletingStripePaymentMethod) {
    orderState.addCardProgress = "inProgress";
    return orderState;
  }
  if (action is DeletedStripePaymentMethod) {
    orderState.addCardProgress = "done";
    return orderState;
  }
  if (action is AddedStripePaymentMethodAndNavigate) {
    orderState.addCardProgress = "done";
    orderState.navigate = true;
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