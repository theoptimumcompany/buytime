// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_reservable_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderReservableState _$OrderReservableStateFromJson(Map<String, dynamic> json) {
  return OrderReservableState(
    itemList: (json['itemList'] as List)
        ?.map((e) =>
            e == null ? null : OrderEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    position: json['position'],
    date: Utils.getDate(json['date'] as Timestamp),
    creationDate: Utils.getDate(json['creationDate'] as Timestamp),
    total: (json['total'] as num)?.toDouble(),
    tip: (json['tip'] as num)?.toDouble(),
    tax: (json['tax'] as num)?.toDouble(),
    taxPercent: (json['taxPercent'] as num)?.toDouble(),
    amount: json['amount'] as int,
    progress: json['progress'] as String,
    navigate: json['navigate'] as bool,
    business: json['business'] == null
        ? null
        : OrderBusinessSnippetState.fromJson(
            json['business'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : UserSnippet.fromJson(json['user'] as Map<String, dynamic>),
    businessId: json['businessId'] as String,
    businessIdForGiveback: json['businessIdForGiveback'] as String,
    userId: json['userId'] as String,
    orderId: json['orderId'] as String,
    selected: (json['selected'] as List)
        ?.map((e) => e == null
            ? null
            : SelectedEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    cartCounter: json['cartCounter'] as int,
    serviceId: json['serviceId'] as String,
    cardType: json['cardType'] as String,
    cardLast4Digit: json['cardLast4Digit'] as String,
    location: json['location'] as String,
  );
}

Map<String, dynamic> _$OrderReservableStateToJson(
        OrderReservableState instance) =>
    <String, dynamic>{
      'itemList': instance.itemList?.map((e) => e?.toJson())?.toList(),
      'date': Utils.setDate(instance.date),
      'creationDate': Utils.setDate(instance.creationDate),
      'position': instance.position,
      'total': instance.total,
      'tip': instance.tip,
      'tax': instance.tax,
      'taxPercent': instance.taxPercent,
      'amount': instance.amount,
      'progress': instance.progress,
      'navigate': instance.navigate,
      'business': instance.business?.toJson(),
      'user': instance.user?.toJson(),
      'businessId': instance.businessId,
      'businessIdForGiveback': instance.businessIdForGiveback,
      'userId': instance.userId,
      'orderId': instance.orderId,
      'selected': instance.selected?.map((e) => e?.toJson())?.toList(),
      'cartCounter': instance.cartCounter,
      'serviceId': instance.serviceId,
      'cardType': instance.cardType,
      'cardLast4Digit': instance.cardLast4Digit,
      'location': instance.location,
    };
