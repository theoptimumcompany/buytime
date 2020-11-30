import 'package:flutter/foundation.dart';

import 'business_state.dart';

class BusinessListState {
  List<BusinessState> businessListState;

  BusinessListState({
    @required this.businessListState,
  });

  BusinessListState.fromState(BusinessListState state) {
    this.businessListState = state.businessListState ;
  }

  companyStateFieldUpdate(List<BusinessState> businessListState) {
    BusinessListState(
      businessListState: businessListState ?? this.businessListState
    );
  }

  BusinessListState copyWith({businessListState}) {
    return BusinessListState(
      businessListState: businessListState ?? this.businessListState
    );
  }

  BusinessListState.fromJson(Map json)
      : businessListState = json['businessListState'];

  Map<String, dynamic> toJson() => {
    'businessListState': businessListState
  };

  BusinessListState toEmpty() {
    return BusinessListState(businessListState: List<BusinessState>());
  }

}