// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderEntry _$OrderEntryFromJson(Map<String, dynamic> json) {
  return OrderEntry(
    number: json['number'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num)?.toDouble(),
    thumbnail: json['thumbnail'] as String,
    id: json['id'] as String,
    id_business: json['id_business'] as String,
    id_owner: json['id_owner'] as String,
    id_category: json['id_category'] as String,
    time: json['time'] as String,
    minutes: json['minutes'] as String,
    date: Utils.getDate(json['date'] as Timestamp),
    switchAutoConfirm: json['switchAutoConfirm'] as bool ?? false,
    idSquareSlot: json['idSquareSlot'] as String ?? '',
    orderCapacity: json['orderCapacity'] as int,
    vat: json['vat'] as int ?? 22,
  );
}

Map<String, dynamic> _$OrderEntryToJson(OrderEntry instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'thumbnail': instance.thumbnail,
      'id': instance.id,
      'id_business': instance.id_business,
      'id_owner': instance.id_owner,
      'id_category': instance.id_category,
      'time': instance.time,
      'minutes': instance.minutes,
      'date': Utils.setDate(instance.date),
      'switchAutoConfirm': instance.switchAutoConfirm,
      'idSquareSlot': instance.idSquareSlot,
      'orderCapacity': instance.orderCapacity,
      'vat': instance.vat,
    };
