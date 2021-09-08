// import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/selected_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../app_state.dart';

part 'order_reservable_state.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderReservableState {
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
  String progress = "unpaid";
  @JsonKey(ignore: true)
  String addCardProgress = "notStarted";
  bool navigate = false;
  OrderBusinessSnippetState business;
  UserSnippet user;
  String businessId;
  String businessIdForGiveback;
  String userId;
  String orderId;
  List<SelectedEntry> selected;
  int cartCounter = 0;
  String serviceId;
  String cardType;
  String cardLast4Digit;
  @JsonKey(ignore: true)
  bool confirmOrderWait = false;
  @JsonKey(ignore: true)
  PaymentMethod paymentMethod;
  String location;
  String openUntil;
  String cancellationReason;
  bool carbonCompensation = false;
  double totalPromoDiscount = 0.0;
  String promotionId;

  OrderReservableState({
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
    this.addCardProgress = "notStarted",
    this.navigate = false,
    this.business,
    this.user,
    this.businessId,
    this.businessIdForGiveback,
    this.userId,
    this.orderId,
    this.selected,
    this.cartCounter,
    this.serviceId,
    this.cardType,
    this.cardLast4Digit,
    this.confirmOrderWait,
    this.paymentMethod,
    this.location,
    this.openUntil,
    this.cancellationReason,
    this.carbonCompensation,
    this.totalPromoDiscount,
    this.promotionId,
  });



  OrderReservableState.fromState(OrderReservableState state) {
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
    this.serviceId = state.serviceId;
    this.cardType = state.cardType;
    this.cardLast4Digit = state.cardLast4Digit;
    this.confirmOrderWait = state.confirmOrderWait;
    this.paymentMethod = state.paymentMethod;
    this.location = state.location;
    this.openUntil = state.openUntil;
    this.cancellationReason = state.cancellationReason;
    this.carbonCompensation = state.carbonCompensation;
    this.totalPromoDiscount = state.totalPromoDiscount;
    this.promotionId = state.promotionId;
  }

  OrderReservableState copyWith({
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
    String serviceId,
    String cardType,
    String cardLast4Digit,
    bool confirmOrderWait,
    PaymentMethod paymentMethodRequest,
    String location,
    String openUntil,
    String cancellationReason,
    bool carbonCompensation,
    bool totalPromoDiscount,
    String promotionId,
  }) {
    return OrderReservableState(
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
      serviceId: serviceId ?? this.serviceId,
      cardType: cardType ?? this.cardType,
      cardLast4Digit: cardLast4Digit ?? this.cardLast4Digit,
      confirmOrderWait: confirmOrderWait ?? this.confirmOrderWait,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      location: location ?? this.location,
      openUntil: openUntil ?? this.openUntil,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      carbonCompensation: carbonCompensation ?? this.carbonCompensation,
      totalPromoDiscount: totalPromoDiscount ?? this.totalPromoDiscount,
      promotionId: promotionId ?? this.promotionId,
    );
  }

  OrderReservableState toEmpty() {
    return OrderReservableState(
      position: "",
      date: DateTime.now(),
        creationDate: DateTime.now(),
      itemList: [],
      total: 0.0,
      tip: 0.0,
      tax: 0.0,
      taxPercent: 0.0,
      amount: 0,
      progress: "unpaid",
      addCardProgress: "notStarted",
      navigate: false,
      businessId: "",
      businessIdForGiveback: "",
      userId: "",
        orderId: "",
      business: OrderBusinessSnippetState().toEmpty(),
      user: UserSnippet().toEmpty(),
      selected: [],
        cartCounter: 0,
      serviceId: '',
        cardType: '',
        cardLast4Digit: '',
        confirmOrderWait: false,
        paymentMethod: null,
        location: '',
        openUntil: '--:--',
      cancellationReason: 'Overbooking',
      carbonCompensation: false,
      totalPromoDiscount: 0.0,
      promotionId: '',
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
          id_owner: idOwner,
          id_category: itemToAdd.categoryId != null ? itemToAdd.categoryId[0] : '',
          switchAutoConfirm: itemToAdd.switchAutoConfirm,
          vat: itemToAdd.vat
      ));
    }
    this.total += itemToAdd.price;
  }

  addReserveItem(ServiceState itemToAdd, String idOwner, String time, String minutes, DateTime date, dynamic price, String slotId,  BuildContext context) {
    /*bool added = false;
    itemList.forEach((element) {
      if (!added && element.id == itemToAdd.serviceId) {
        element.number++;
        added = true;
      }
    });*/
    DateTime tmpDate = date;
    tmpDate = DateTime(date.year, date.month, date.day, int.parse(time.split(':').first), int.parse(time.split(':').last));
    itemList.add(OrderEntry(
      orderCapacity: 1,
      idSquareSlot: slotId,
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
      date: tmpDate,
        switchAutoConfirm: itemToAdd.switchAutoConfirm,
      vat: itemToAdd.vat != null && itemToAdd.vat != 0 ? itemToAdd.vat : 22
    ));

    this.totalPromoDiscount += Utils.calculatePromoDiscount(price, context, itemToAdd.businessId, 1);
    this.total += price;
    this.total -= (totalPromoDiscount / itemList.length);
  }

  // void removeItem(OrderEntry entry, BuildContext context) {
  //   bool deleted = false;
  //   itemList.forEach((element) {
  //     //debugPrint('order_state => DATES: ${element.date} - ${entry.date}');
  //     if (!deleted && element.id == entry.id) {
  //       this.totalPromoDiscount -= (Utils.calculatePromoDiscount(entry.price, context));
  //       this.total -= ((entry.price + this.totalPromoDiscount ) * element.number);
  //       element.number = 0;
  //       deleted = true;
  //     }
  //   });
  // }

  void removeReserveItem(OrderEntry entry, BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(DecreasePromotionCounter(1));
    this.totalPromoDiscount -= (Utils.calculatePromoDiscount(entry.price, context, entry.id_business, 2));
    this.total -= entry.price;
    if(this.itemList.length!= 0)
      this.total += (totalPromoDiscount / this.itemList.length);
    else
      this.total = 0;
  }

  bool isOrderAutoConfirmable() {
    for(int i = 0; i < this.itemList.length; i++) {
      if (!this.itemList[i].switchAutoConfirm){
        return false;
      }
    }
    return true;
  }

  factory OrderReservableState.fromJson(Map<String, dynamic> json) => _$OrderReservableStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderReservableStateToJson(this);
}
