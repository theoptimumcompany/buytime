import 'package:BuyTime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:BuyTime/reusable/snippet/generic.dart';
import 'package:BuyTime/reblox/model/order/order_entry.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:flutter/cupertino.dart';

class OrderState {
  List<OrderEntry> itemList;
  DateTime date;
  var position;
  double total = 0.0;
  double tip = 0.0;
  double tax = 0.0;
  double taxPercent = 0.0;
  int amount = 0;
  String progress = "unpaid";
  bool addCardProgress = false;
  BusinessSnippet business;
  UserSnippet user;
  String businessId;
  String userId;

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
    this.business,
    this.user,
    this.businessId,
    this.userId,
  });

  OrderState.fromJson(Map<String, dynamic> json)
      : itemList = List<OrderEntry>.from(json["itemList"].map((item) {
          return new OrderEntry(
            number: item['number'],
            name: item['name'],
            description: item['description'],
            price: item['price'].toDouble(),
            thumbnail: item['thumbnail'],
            id: item['id'],
            id_business: item['id_business'],
          );
        })),
        position = json['position'],
        date = json['date'].toDate(),
        progress = json['progress'],
        addCardProgress = false,
        tip = json['tip'],
        tax = json['tax'],
        taxPercent = json['taxPercent'],
        amount = json['amount'],
        businessId = json['businessId'],
        userId = json['userId'],
        business = BusinessSnippet.fromJson(json["business"]),
        user = UserSnippet.fromJson(json["user"]),
        total = json['total'].toDouble();

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
    this.business = state.business;
    this.businessId = state.businessId;
    this.userId = state.userId;
    this.user = state.user;
  }

  Map<String, dynamic> toJson() => {
        'itemList': convertToJson(itemList),
        'position': position,
        'date': date,
        'total': total,
        'tip': tip,
        'tax': tax,
        'taxPercent': taxPercent,
        'amount': amount,
        'progress': progress,
        'addCardProgress': addCardProgress,
        'businessId': businessId,
        'userId': userId,
        'business': business.toJson(),
        'user': user.toJson(),
      };

  List<dynamic> convertToJson(List<OrderEntry> orderEntryList) {
    List<dynamic> list = List<dynamic>();
    orderEntryList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
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
    String businessId,
    String userId,
    BusinessSnippet business,
    UserSnippet user,
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
      businessId: businessId ?? this.businessId,
      userId: userId ?? this.userId,
      business: business ?? this.business,
      user: user ?? this.user,
    );
  }

  OrderState toEmpty() {
    return OrderState(
      position: "",
      date: DateTime.now(),
      itemList: List<OrderEntry>(),
      total: 0.0,
      tip: 0.0,
      tax: 0.0,
      taxPercent: 0.0,
      amount: 0,
      progress: "unpaid",
      addCardProgress: false,
      businessId: "",
      userId: "",
      business: BusinessSnippet().toEmpty(),
      user: UserSnippet().toEmpty(),
    );
  }

  addItem(ServiceState itemToAdd, String idOwner) {
    bool added = false;
    itemList.forEach((element) {
      if (!added && element.id == itemToAdd.id) {
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
          thumbnail: itemToAdd.thumbnail,
          id: itemToAdd.id,
          id_business: itemToAdd.id_business,
          id_owner: idOwner));
    }
    this.total += itemToAdd.price;
  }

  void removeItem(OrderEntry entry) {
    bool deleted = false;
    itemList.forEach((element) {
      if (!deleted && element.id == entry.id) {
        this.total -= (entry.price * element.number);
        element.number = 0;
        deleted = true;
      }
    });
  }
}
