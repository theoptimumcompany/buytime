

import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';

class SetServiceSlot {
  ServiceSlot _serviceSlot;

  SetServiceSlot(this._serviceSlot);

  ServiceSlot get serviceSlot => _serviceSlot;
}

class SetServiceSlotToEmpty {
  ServiceSlot _serviceSlot;

  SetServiceSlotToEmpty();

  ServiceSlot get serviceSlot => _serviceSlot;
}

class SetServiceSlotDaysInterval {
  List<EveryDay> _daysInterval;

  SetServiceSlotDaysInterval(this._daysInterval);

  List<EveryDay> get daysInterval => _daysInterval;
}

class SetServiceSlotNumberOfInterval {
  int _numberOfInterval;
  SetServiceSlotNumberOfInterval(this._numberOfInterval);
  int get numberOfInterval => _numberOfInterval;
}

class SetServiceSlotSwitchWeek {
  List<bool>  _switchWeek;
  SetServiceSlotSwitchWeek(this._switchWeek);
  List<bool> get switchWeek => _switchWeek;

}

class SetServiceSlotStartTime {
  List<String> _time;
  SetServiceSlotStartTime(this._time);
  List<String>  get time => _time;
}

class SetServiceSlotStopTime {
  List<String> _time;
  SetServiceSlotStopTime(this._time);
  List<String>  get time => _time;
}


class SetServiceSlotCheckIn {
  String _date;
  SetServiceSlotCheckIn(this._date);
  String get date => _date;
}


class SetServiceSlotCheckOut{
  String _date;
  SetServiceSlotCheckOut(this._date);
  String get date => _date;
}

class SetServiceSlotHour {
  int _hour;
  SetServiceSlotHour(this._hour);
  int get hour => _hour;
}

class SetServiceSlotMinute {
  int _minute;
  SetServiceSlotMinute(this._minute);
  int get minute => _minute;
}

class SetServiceSlotMinDuration {
  int _minDuration;
  SetServiceSlotMinDuration(this._minDuration);
  int get minDuration => _minDuration;
}

class SetServiceSlotLimitBooking {
  int _limit;
  SetServiceSlotLimitBooking(this._limit);
  int get limit => _limit;
}

class SetServiceSlotNoLimitBooking {
  bool _noLimit;
  SetServiceSlotNoLimitBooking(this._noLimit);
  bool get noLimit => _noLimit;
}

class SetServiceSlotPrice {
  double _price;
  SetServiceSlotPrice(this._price);
  double get price => _price;
}


ServiceSlot serviceSlotReducer(ServiceSlot state, action) {
  ServiceSlot serviceSlot = ServiceSlot.fromState(state);
  if (action is SetServiceSlot) {
    serviceSlot = action.serviceSlot.copyWith();
    return serviceSlot;
  }
  if (action is SetServiceSlotDaysInterval) {
    serviceSlot.daysInterval = action.daysInterval;
    return serviceSlot;
  }
  if (action is SetServiceSlotNumberOfInterval) {
    serviceSlot.numberOfInterval = action.numberOfInterval;
    return serviceSlot;
  }
  if (action is SetServiceSlotSwitchWeek) {
    serviceSlot.switchWeek = action.switchWeek;
    return serviceSlot;
  }
  if (action is SetServiceSlotCheckIn) {
    serviceSlot.checkIn = action.date;
    return serviceSlot;
  }
  if (action is SetServiceSlotCheckOut) {
    serviceSlot.checkOut = action.date;
    return serviceSlot;
  }
  if (action is SetServiceSlotStartTime) {
    serviceSlot.startTime = action.time;
    return serviceSlot;
  }
  if (action is SetServiceSlotStopTime) {
    serviceSlot.stopTime = action.time;
    return serviceSlot;
  }
  if (action is SetServiceSlotHour) {
    serviceSlot.hour = action.hour;
    return serviceSlot;
  }
  if (action is SetServiceSlotMinute) {
    serviceSlot.minute = action.minute;
    return serviceSlot;
  }
  if (action is SetServiceSlotMinDuration) {
    serviceSlot.minDuration = action.minDuration;
    return serviceSlot;
  }
  if (action is SetServiceSlotLimitBooking) {
    serviceSlot.limitBooking = action.limit;
    return serviceSlot;
  }
  if (action is SetServiceSlotNoLimitBooking) {
    serviceSlot.noLimitBooking = action.noLimit;
    return serviceSlot;
  }
  if (action is SetServiceSlotPrice) {
    serviceSlot.price = action.price;
    return serviceSlot;
  }
  if (action is SetServiceSlotToEmpty) {
    serviceSlot = ServiceSlot().toEmpty();
    return serviceSlot;
  }
  return state;
}
