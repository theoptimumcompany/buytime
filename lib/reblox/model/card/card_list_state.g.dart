// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardListState _$CardListStateFromJson(Map<String, dynamic> json) {
  return CardListState(
    cardListState: (json['cardListState'] as List)
        ?.map((e) =>
            e == null ? null : CardState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CardListStateToJson(CardListState instance) =>
    <String, dynamic>{
      'cardListState':
          instance.cardListState?.map((e) => e?.toJson())?.toList(),
    };
