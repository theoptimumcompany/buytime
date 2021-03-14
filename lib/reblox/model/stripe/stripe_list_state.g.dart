// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeListState _$StripeListStateFromJson(Map<String, dynamic> json) {
  return StripeListState(
    stripeListState: (json['stripeListState'] as List)
        ?.map((e) =>
            e == null ? null : StripeState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$StripeListStateToJson(StripeListState instance) =>
    <String, dynamic>{
      'stripeListState':
          instance.stripeListState?.map((e) => e?.toJson())?.toList(),
    };
