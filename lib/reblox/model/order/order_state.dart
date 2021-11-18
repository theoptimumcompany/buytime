import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/selected_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_reducer.dart';
// import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
part 'order_state.g.dart';

enum OrderStatus {
  accepted,
  paid,
  pending,
  toBePaidAtCheckout,
  canceled,
}

enum AddCardStatus {
  notStarted,
  done,
  inProgress,
}

@JsonSerializable(explicitToJson: true)
class OrderState {
  List<OrderEntry> itemList;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime date; /// date in which the service will be used
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime creationDate; /// date in which the service was created
  var position;
  double total = 0.0;
  double tip = 0.0;
  double tax = 0.0;
  double taxPercent = 0.0;
  int amount = 0;
  String progress = Utils.enumToString(OrderStatus.pending);
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
  PaymentMethod paymentMethod;
  String location;
  String openUntil;
  @JsonKey(defaultValue: "")
  String tableNumber;
  String cancellationReason;
  bool carbonCompensation = false;
  double totalPromoDiscount = 0.0;
  String promotionId;

  OrderState({
    @required this.itemList,
    this.position,
    this.date,
    this.creationDate,
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
    this.tableNumber,
    this.cancellationReason,
    this.carbonCompensation,
    this.totalPromoDiscount,
    this.promotionId,
  });



  OrderState.fromState(OrderState state) {
    this.itemList = state.itemList;
    this.date = state.date;
    this.creationDate = state.creationDate;
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
    this.tableNumber = state.tableNumber;
    this.cancellationReason = state.cancellationReason;
    this.carbonCompensation = state.carbonCompensation;
    this.totalPromoDiscount = state.totalPromoDiscount;
    this.promotionId = state.promotionId;
  }

  OrderState.fromReservableState(OrderReservableState state) {
    this.itemList = state.itemList;
    this.date = state.date;
    this.creationDate = state.creationDate;
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
    this.tableNumber = state.tableNumber;
    this.cancellationReason = state.cancellationReason;
    this.carbonCompensation = state.carbonCompensation;
    this.totalPromoDiscount = state.totalPromoDiscount;
    this.promotionId = state.promotionId;
  }

  OrderState copyWith({
    List<OrderEntry> itemList,
    DateTime date,
    DateTime creationDate,
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
    PaymentMethod paymentMethod,
    String location,
    String openUntil,
    String tableNumber,
    String cancellationReason,
    bool carbonCompensation,
    double totalPromoDiscount,
    String promotionId,
  }) {
    return OrderState(
      itemList: itemList ?? this.itemList,
      date: date ?? this.date,
      creationDate: creationDate ?? this.creationDate,
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
      tableNumber: tableNumber ?? this.tableNumber,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      carbonCompensation: carbonCompensation ?? this.carbonCompensation,
      totalPromoDiscount: totalPromoDiscount ?? this.totalPromoDiscount,
      promotionId: promotionId ?? this.promotionId,
    );
  }

  OrderState toEmpty() {
    return OrderState(
      position: "",
      date: DateTime.now(),
      creationDate: DateTime.now(),
      itemList: [],
      total: 0.0,
      tip: 0.0,
      tax: 0.0,
      taxPercent: 0.0,
      amount: 0,
      progress: Utils.enumToString(OrderStatus.pending),
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
      tableNumber: '',
      cancellationReason: 'Overbooking',
      carbonCompensation: false,
      totalPromoDiscount: 0.0,
      promotionId: '',
    );
  }

  addItem(ServiceState itemToAdd, String idOwner, BuildContext context) {
    bool added = false;
    double itemDiscount = 0.0;//Utils.calculatePromoDiscount(itemToAdd.price, context, itemToAdd.businessId, 1, totalNumberOfItems());
      itemList.forEach((element) {
        if (!added && element.id == itemToAdd.serviceId) {
          element.number++;
          // if (itemDiscount != 0.0){
          //   // element.numberDiscounted++;
          //   debugPrint("order_state numberDiscounted: " +  element.numberDiscounted.toString());
          // }
          added = true;
        }
      });
      if (!added) {
        itemList.add(OrderEntry(
            number: 1,
            numberDiscounted: itemDiscount != 0.0 ? 1 : 0,
            name: itemToAdd.name,
            description: itemToAdd.description,
            price: itemToAdd.price,
            thumbnail: itemToAdd.image1,
            id: itemToAdd.serviceId,
            id_business: itemToAdd.businessId,
            id_category: itemToAdd.categoryId != null ? itemToAdd.categoryId[0] : '',
            id_owner: idOwner,
            switchAutoConfirm: itemToAdd.switchAutoConfirm,
          vat: itemToAdd.vat != null && itemToAdd.vat != 0 ? itemToAdd.vat : 22
        ));
      }
      this.total += itemToAdd.price;

      this.totalPromoDiscount += itemDiscount;
      this.total -= itemDiscount;
  }

  addingFromAnotherBusiness(String businessId) {
    for(int i = 0; i < itemList.length; i++ ) {
      if (itemList[i].id_business != businessId) {
        return true;
      }
    }
    return false;
  }

  void removeItem(OrderEntry entry, BuildContext context) {
    bool deleted = false;
    itemList.forEach((element) {
      if (!deleted && element.id == entry.id) {
        this.total -= (entry.price * element.number);
        double itemDiscount = 0.0;//Utils.calculatePromoDiscount(entry.price, context, entry.id_business, 2, totalNumberOfItems());
        this.totalPromoDiscount -= itemDiscount;
        this.total += itemDiscount;
        // if (itemDiscount != 0.0){
        //   element.numberDiscounted--;
        //   if (element.numberDiscounted < 0) {
        //     element.numberDiscounted = 0;
        //   }
        // }
        element.number = 0;
        deleted = true;
      }
    });
  }

  void removeReserveItem(OrderEntry entry, BuildContext context) {
    this.total -= (entry.price);
    double itemDiscount = 0.0;//Utils.calculatePromoDiscount(entry.price, context, entry.id_business, 2, totalNumberOfItems());
    this.totalPromoDiscount -= itemDiscount;
    this.total += itemDiscount;
  }

  int totalNumberOfItems () {
    int totalNumberOfItems = 0;
    if (this.itemList != null && this.itemList.isNotEmpty) {
      for (int i = 0; i < this.itemList.length; i++) {
        totalNumberOfItems += this.itemList[i].number;
      }
    }
    return totalNumberOfItems;
  }

  bool isOrderAutoConfirmable() {
    for(int i = 0; i < this.itemList.length; i++) {
      if (!this.itemList[i].switchAutoConfirm){
        return false;
      }
    }
    return true;
  }

  factory OrderState.fromJson(Map<String, dynamic> json) => _$OrderStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStateToJson(this);

}
