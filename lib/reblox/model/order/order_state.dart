import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'order_state.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderState {
  List<OrderEntry> itemList;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime date;
  var position;
  double total = 0.0;
  double tip = 0.0;
  double tax = 0.0;
  double taxPercent = 0.0;
  int amount = 0;
  String progress = "unpaid";
  bool addCardProgress = false;
  bool navigate = false;
  BusinessSnippet business;
  UserSnippet user;
  String businessId;
  String userId;
  List<List<int>> selected;
  int cartCounter = 0;

  OrderState({
    @required this.itemList,
    this.position,
    this.date,
    this.total,
    this.tip,
    this.tax,
    this.taxPercent,
    this.amount,
    this.progress,
    this.addCardProgress = false,
    this.navigate = false,
    this.business,
    this.user,
    this.businessId,
    this.userId,
    this.selected,
    this.cartCounter,
  });



  OrderState.fromState(OrderState state) {
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
    this.userId = state.userId;
    this.user = state.user;
    this.selected = state.selected;
    this.cartCounter = state.cartCounter;
  }

  OrderState copyWith({
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
    String userId,
    BusinessSnippet business,
    UserSnippet user,
    List<List<int>> selected,
    int cartCounter
  }) {
    return OrderState(
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
      userId: userId ?? this.userId,
      business: business ?? this.business,
      user: user ?? this.user,
      selected: selected ?? this.selected,
      cartCounter: cartCounter ?? this.cartCounter,
    );
  }

  OrderState toEmpty() {
    return OrderState(
      position: "",
      date: DateTime.now(),
      itemList: [],
      total: 0.0,
      tip: 0.0,
      tax: 0.0,
      taxPercent: 0.0,
      amount: 0,
      progress: "unpaid",
      addCardProgress: false,
      navigate: false,
      businessId: "",
      userId: "",
      business: BusinessSnippet().toEmpty(),
      user: UserSnippet().toEmpty(),
      selected: [],
        cartCounter: 0
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
          id_owner: idOwner));
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
        id_owner: idOwner,
      time: time,
      minutes: minutes,
      date: date
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
  factory OrderState.fromJson(Map<String, dynamic> json) => _$OrderStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStateToJson(this);
}
