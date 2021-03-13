import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'stripe_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class StripeListState {
  List<StripeState> stripeListState;

  StripeListState({
    @required this.stripeListState,
  });

  StripeListState.fromState(StripeListState state) {
    this.stripeListState = state.stripeListState ;
  }

  companyStateFieldUpdate(List<StripeState> stripeListState) {
    StripeListState(
        stripeListState: stripeListState ?? this.stripeListState
    );
  }

  StripeListState copyWith({stripeListState}) {
    return StripeListState(
        stripeListState: stripeListState ?? this.stripeListState
    );
  }

  StripeListState toEmpty() {
    return StripeListState(stripeListState: []);
  }
  factory StripeListState.fromJson(Map<String, dynamic> json) => _$StripeListStateFromJson(json);
  Map<String, dynamic> toJson() => _$StripeListStateToJson(this);
}