// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardState _$CardStateFromJson(Map<String, dynamic> json) {
  return CardState(
    cardId: json['cardId'] as String,
    cardOwner: json['cardOwner'] as String,
    stripeState: json['stripeState'] == null
        ? null
        : StripeState.fromJson(json['stripeState'] as Map<String, dynamic>),
    selected: json['selected'] as bool,
  );
}

Map<String, dynamic> _$CardStateToJson(CardState instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'cardOwner': instance.cardOwner,
      'stripeState': instance.stripeState?.toJson(),
      'selected': instance.selected,
    };
