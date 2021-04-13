import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/email/email_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/material.dart';

class SendEmail {
  EmailState _emailState;
  SendEmail(this._emailState);
  EmailState get emailState => _emailState;
}

class SentEmail {
  EmailState _emailState;
  SentEmail(this._emailState);
  EmailState get emailState => _emailState;
}

EmailState emailReducer(EmailState state, action) {
  EmailState emailState = new EmailState.fromState(state);
  if (action is SendEmail) {
    emailState = action.emailState.copyWith();
    return emailState;
  }
  if (action is SentEmail) {
    emailState = action.emailState.copyWith();
    return emailState;
  }
  return state;
}
