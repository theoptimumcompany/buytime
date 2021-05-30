import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/selected_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_state.dart';

part 'order_detail_state.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDetailState {
  List<OrderEntry> itemList;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime date;
  var position;
  double total = 0.0;
  double tip = 0.0;
  double tax = 0.0;
  double taxPercent = 0.0;
  int amount = 0;
  String progress = Utils.enumToString(OrderStatus.unpaid);
  @JsonKey(ignore: true)
  String addCardProgress = Utils.enumToString(AddCardStatus.notStarted);
  bool navigate = false;
  OrderBusinessSnippetState business;
  UserSnippet user;
  String businessId;
  String businessIdForGiveback;
  String userId;
  String orderId;
  List<SelectedEntry> selected;
  int cartCounter = 0;
  String cardType;
  String cardLast4Digit;
  @JsonKey(ignore: true)
  StripeRecommended.PaymentMethod paymentMethod;
  String location;
  @JsonKey(defaultValue: '--:--')
  String openUntil;

  OrderDetailState({
    @required this.itemList,
    this.position,
    this.date,
    this.total,
    this.tip,
    this.tax,
    this.taxPercent,
    this.amount,
    this.progress,
    this.addCardProgress,
    this.navigate = false,
    this.business,
    this.user,
    this.businessId,
    this.businessIdForGiveback,
    this.userId,
    this.orderId,
    this.selected,
    this.cartCounter,
    this.cardType,
    this.cardLast4Digit,
    this.paymentMethod,
    this.location,
    this.openUntil,
  });



  OrderDetailState.fromState(OrderDetailState state) {
    this.itemList = state.itemList;
    this.date = state.date;
    this.position = state.position;
    this.total = state.total;
    this.tip = state.tip;
    this.tax = state.tax;
    this.taxPercent = state.taxPercent;
    this.amount = state.amount;
    this.progress = state.progress;
    this.addCardProgress = state.addCardProgress;
    this.navigate = state.navigate;
    this.business = state.business;
    this.businessId = state.businessId;
    this.businessIdForGiveback = state.businessIdForGiveback;
    this.userId = state.userId;
    this.orderId = state.orderId;
    this.user = state.user;
    this.selected = state.selected;
    this.cartCounter = state.cartCounter;
    this.cardType = state.cardType;
    this.cardLast4Digit = state.cardLast4Digit;
    this.paymentMethod = state.paymentMethod;
    this.location = state.location;
    this.openUntil = state.openUntil;
  }

  OrderDetailState.fromOrderState(OrderState state) {
    this.itemList = state.itemList;
    this.date = state.date;
    this.position = state.position;
    this.total = state.total;
    this.tip = state.tip;
    this.tax = state.tax;
    this.taxPercent = state.taxPercent;
    this.amount = state.amount;
    this.progress = state.progress;
    this.addCardProgress = state.addCardProgress;
    this.navigate = state.navigate;
    this.business = state.business;
    this.businessId = state.businessId;
    this.businessIdForGiveback = state.businessIdForGiveback;
    this.userId = state.userId;
    this.orderId = state.orderId;
    this.user = state.user;
    this.selected = state.selected;
    this.cartCounter = state.cartCounter;
    this.cardType = state.cardType;
    this.cardLast4Digit = state.cardLast4Digit;
    this.paymentMethod = state.paymentMethod;
    this.location = state.location;
    this.openUntil = state.openUntil;
  }

  OrderDetailState.fromReservableState(OrderReservableState state) {
    this.itemList = state.itemList;
    this.date = state.date;
    this.position = state.position;
    this.total = state.total;
    this.tip = state.tip;
    this.tax = state.tax;
    this.taxPercent = state.taxPercent;
    this.amount = state.amount;
    this.progress = state.progress;
    this.addCardProgress = state.addCardProgress;
    this.navigate = state.navigate;
    this.business = state.business;
    this.businessId = state.businessId;
    this.businessIdForGiveback = state.businessIdForGiveback;
    this.userId = state.userId;
    this.orderId = state.orderId;
    this.user = state.user;
    this.selected = state.selected;
    this.cartCounter = state.cartCounter;
    this.cardType = state.cardType;
    this.cardLast4Digit = state.cardLast4Digit;
    this.paymentMethod = state.paymentMethod;
    this.location = state.location;
    this.openUntil = state.openUntil;
  }

  OrderDetailState copyWith({
    List<OrderEntry> itemList,
    DateTime date,
    var position,
    double total,
    double tip,
    double tax,
    double taxPercent,
    int amount,
    String progress,
    String addCardProgress,
    String navigate,
    String businessId,
    String businessIdForGiveback,
    String userId,
    String orderId,
    OrderBusinessSnippetState business,
    UserSnippet user,
    List<SelectedEntry> selected,
    int cartCounter,
    String cardType,
    String cardLast4Digit,
    bool confirmOrderWait,
    StripeRecommended.PaymentMethod paymentMethod,
    String location,
    String openUntil,
  }) {
    return OrderDetailState(
      itemList: itemList ?? this.itemList,
      date: date ?? this.date,
      position: position ?? this.position,
      total: total ?? this.total,
      tip: tip ?? this.tip,
      tax: tax ?? this.tax,
      taxPercent: taxPercent ?? this.taxPercent,
      amount: amount ?? this.amount,
      progress: progress ?? this.progress,
      addCardProgress: addCardProgress ?? this.addCardProgress,
      navigate: navigate ?? this.navigate,
      businessId: businessId ?? this.businessId,
      businessIdForGiveback: businessIdForGiveback ?? this.businessIdForGiveback,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      business: business ?? this.business,
      user: user ?? this.user,
      selected: selected ?? this.selected,
      cartCounter: cartCounter ?? this.cartCounter,
      cardType: cardType ?? this.cardType,
      cardLast4Digit: cardLast4Digit ?? this.cardLast4Digit,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      location: location ?? this.location,
      openUntil: openUntil ?? this.openUntil,
    );
  }

  OrderDetailState toEmpty() {
    return OrderDetailState(
      position: "",
      date: DateTime.now(),
      itemList: [],
      total: 0.0,
      tip: 0.0,
      tax: 0.0,
      taxPercent: 0.0,
      amount: 0,
      progress: Utils.enumToString(OrderStatus.unpaid),
      addCardProgress: Utils.enumToString(AddCardStatus.notStarted),
      navigate: false,
      businessId: "",
      businessIdForGiveback: "",
      userId: "",
        orderId: "",
      business: OrderBusinessSnippetState().toEmpty(),
      user: UserSnippet().toEmpty(),
      selected: [],
        cartCounter: 0,
        cardType: '',
      cardLast4Digit: '',
      paymentMethod: null,
      location: '',
      openUntil: '--:--',
    );
  }

  addItem(ServiceState itemToAdd, String idOwner) {
    bool added = false;
    itemList.forEach((element) {
      if (!added && element.id == itemToAdd.serviceId) {
        element.number++;
        added = true;
      }
    });
    if (!added) {
      itemList.add(OrderEntry(
          number: 1,
          name: itemToAdd.name,
          description: itemToAdd.description,
          price: itemToAdd.price,
          thumbnail: itemToAdd.image1,
          id: itemToAdd.serviceId,
          id_business: itemToAdd.businessId,
          id_category: itemToAdd.categoryId != null ? itemToAdd.categoryId[0] : '',
          id_owner: idOwner,
          switchAutoConfirm: itemToAdd.switchAutoConfirm
      ));
    }
    this.total += itemToAdd.price;
  }

  addReserveItem(ServiceState itemToAdd, String idOwner, String time, String minutes, DateTime date, dynamic price) {
    /*bool added = false;
    itemList.forEach((element) {
      if (!added && element.id == itemToAdd.serviceId) {
        element.number++;
        added = true;
      }
    });*/
    itemList.add(OrderEntry(
        number: 1,
        name: itemToAdd.name,
        description: itemToAdd.description,
        price: price,
        thumbnail: itemToAdd.image1,
        id: itemToAdd.serviceId,
        id_business: itemToAdd.businessId,
        id_category: itemToAdd.categoryId != null ? itemToAdd.categoryId[0] : '',
        id_owner: idOwner,
      time: time,
      minutes: minutes,
      date: date,
      switchAutoConfirm: itemToAdd.switchAutoConfirm
    ));
    this.total += price;
  }

  void removeItem(OrderEntry entry) {
    bool deleted = false;
    itemList.forEach((element) {
      //debugPrint('order_state => DATES: ${element.date} - ${entry.date}');
      if (!deleted && element.id == entry.id) {
        this.total -= (entry.price * element.number);
        element.number = 0;
        deleted = true;
      }
    });
  }

  void removeReserveItem(OrderEntry entry) {
    this.total -= (entry.price);

  }

  bool isOrderAutoConfirmable() {
    for(int i = 0; i < this.itemList.length; i++) {
      if (!this.itemList[i].switchAutoConfirm){
        return false;
      }
    }
    return true;
  }

  factory OrderDetailState.fromJson(Map<String, dynamic> json) => _$OrderDetailStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailStateToJson(this);

}
