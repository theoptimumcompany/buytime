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
    total: (json['total'] as num)?.toDouble(),
    tip: (json['tip'] as num)?.toDouble(),
    tax: (json['tax'] as num)?.toDouble(),
    taxPercent: (json['taxPercent'] as num)?.toDouble(),
    amount: json['amount'] as int,
    progress: json['progress'] as String,
    addCardProgress: json['addCardProgress'] as bool,
    navigate: json['navigate'] as bool,
    business: json['business'] == null
        ? null
        : BusinessSnippet.fromJson(json['business'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : UserSnippet.fromJson(json['user'] as Map<String, dynamic>),
    businessId: json['businessId'] as String,
    userId: json['userId'] as String,
    selected: (json['selected'] as List)
        ?.map((e) => e == null
            ? null
            : SelectedEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    cartCounter: json['cartCounter'] as int,
    serviceId: json['serviceId'] as String,
  );
}

Map<String, dynamic> _$OrderReservableStateToJson(
        OrderReservableState instance) =>
    <String, dynamic>{
      'itemList': instance.itemList?.map((e) => e?.toJson())?.toList(),
      'date': Utils.setDate(instance.date),
      'position': instance.position,
      'total': instance.total,
      'tip': instance.tip,
      'tax': instance.tax,
      'taxPercent': instance.taxPercent,
      'amount': instance.amount,
      'progress': instance.progress,
      'addCardProgress': instance.addCardProgress,
      'navigate': instance.navigate,
      'business': instance.business?.toJson(),
      'user': instance.user?.toJson(),
      'businessId': instance.businessId,
      'userId': instance.userId,
      'selected': instance.selected?.map((e) => e?.toJson())?.toList(),
      'cartCounter': instance.cartCounter,
      'serviceId': instance.serviceId,
    };
