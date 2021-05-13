import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class SlotListSnippetRequest {
  String _serviceId;

  SlotListSnippetRequest(this._serviceId);

  String get serviceId => _serviceId;
}

/*class ServiceListSnippetRequestNavigate {
  String _businessId;

  ServiceListSnippetRequestNavigate(this._businessId);

  String get businessId => _businessId;
}*/

class SlotListSnippetRequestResponse {
  SlotListSnippetState _slotSnippetListState;

  SlotListSnippetRequestResponse(this._slotSnippetListState);

  SlotListSnippetState get slotSnippetListState => _slotSnippetListState;
}


SlotListSnippetState slotListSnippetReducer(SlotListSnippetState state, action) {
  SlotListSnippetState slotListSnippetState = new SlotListSnippetState.fromState(state);

  if (action is SlotListSnippetRequestResponse) {
    slotListSnippetState = action.slotSnippetListState.copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return slotListSnippetState;
  }
  return state;
}
