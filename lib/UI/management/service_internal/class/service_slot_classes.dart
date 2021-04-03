import 'package:flutter/material.dart';

class EveryDay {
  List<bool> everyDay;

  EveryDay({this.everyDay});

  EveryDay toEmpty() {
    return EveryDay(
      everyDay: [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
      ],
    );
  }

  EveryDay copyWith({
    List<bool> everyDay,
  }) {
    return EveryDay(
      everyDay: everyDay ?? this.everyDay,
    );
  }

  EveryDay.fromJson(Map<String, dynamic> json) : everyDay = List<bool>.from(json['everyDay']);

  Map<String, dynamic> toJson() => {
    'everyDay': everyDay,
  };
}

class EveryTime {
  List<TimeOfDay> everyTime;

  EveryTime({this.everyTime});

  EveryTime toEmpty() {
    return EveryTime(
      everyTime: [TimeOfDay.now()],
    );
  }

  EveryTime copyWith({
    List<TimeOfDay> everyTime,
  }) {
    return EveryTime(
      everyTime: everyTime ?? this.everyTime,
    );
  }

  List<String> convertTimeOfDayToString(List<TimeOfDay> times) {
    List<String> list = [];
    times.forEach((element) {
      String hour = element.hour < 10 ? "0" + element.hour.toString() : element.hour.toString();
      String minute = element.minute < 10 ? "0" + element.minute.toString() : element.minute.toString();
      list.add(hour + ":" + minute);
    });
    return list;
  }

  EveryTime.convertStringToTimeOfDay(List<String> strings) {
    List<TimeOfDay> list = [];
    strings.forEach((element) {
      TimeOfDay tec;
      List<String> time = element.split(':');
      tec = TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
      list.add(tec);
    });
    everyTime = list;
  }

  EveryTime.fromJson(Map<String, dynamic> json) : everyTime = EveryTime.convertStringToTimeOfDay(List<String>.from(json['everyTime'])).everyTime;


  Map<String, dynamic> toJson() => {
    'everyTime': convertTimeOfDayToString(everyTime),
  };
}
