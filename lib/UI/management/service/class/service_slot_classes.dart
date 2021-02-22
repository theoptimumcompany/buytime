import 'package:flutter/material.dart';

class ListEveryDay {
  List<EveryDay> listEveryDay;

  ListEveryDay({this.listEveryDay});

  ListEveryDay toEmpty() {
    return ListEveryDay(
      listEveryDay: [EveryDay().toEmpty()],
    );
  }

  ListEveryDay copyWith({
    List<EveryDay> listEveryDay,
  }) {
    return ListEveryDay(
      listEveryDay: listEveryDay ?? this.listEveryDay,
    );
  }

  List<dynamic> convertToJson(var objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  ListEveryDay.fromJson(Map<String, dynamic> json)
      : listEveryDay = List<EveryDay>.from(json["listEveryDay"].map((item) {
    return EveryDay(
      everyDay: item["everyDay"] != null ? List<bool>.from(item["everyDay"]) : EveryDay().toEmpty(),
    );
  }));

  Map<String, dynamic> toJson() => {
    'listEveryDay': convertToJson(listEveryDay),
  };
}

class EveryDay {
  List<bool> everyDay;

  EveryDay({this.everyDay});

  EveryDay toEmpty() {
    return EveryDay(
      everyDay: [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
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

class ListTextEditingController {
  List<TextEditingController> listTextEditingController;

  ListTextEditingController({this.listTextEditingController});

  ListTextEditingController toEmpty() {
    return ListTextEditingController(
      listTextEditingController: [TextEditingController()],
    );
  }

  ListTextEditingController copyWith({
    List<TextEditingController> listTextEditingController,
  }) {
    return ListTextEditingController(
      listTextEditingController: listTextEditingController ?? this.listTextEditingController,
    );
  }

  List<String> convertTextEditingControllerToString(List<TextEditingController> controllers) {
    List<String> list = [];
    controllers.forEach((element) {
      list.add(element.text);
    });
    return list;
  }

  ListTextEditingController.convertStringToTextEditingController(List<String> strings) {
    List<TextEditingController> list = [];
    strings.forEach((element) {
      TextEditingController tec = TextEditingController();
      tec.text = element;
      list.add(tec);
    });
    listTextEditingController = list;
  }

  ListTextEditingController.fromJson(Map<String, dynamic> json)
      : listTextEditingController = ListTextEditingController.convertStringToTextEditingController(List<String>.from(json['listTextEditingController'])).listTextEditingController;

  Map<String, dynamic> toJson() => {
    'listTextEditingController': convertTextEditingControllerToString(listTextEditingController),
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


class ListWeek {
  List<bool> listWeek;

  ListWeek({this.listWeek});

  ListWeek toEmpty() {
    return ListWeek(
      listWeek: [true],
    );
  }

  ListWeek copyWith({
    List<bool> listWeek,
  }) {
    return ListWeek(
      listWeek: listWeek ?? this.listWeek,
    );
  }

  ListWeek.fromJson(Map<String, dynamic> json) : listWeek = List<bool>.from(json['listWeek']);


  Map<String, dynamic> toJson() => {
    'listWeek': listWeek,
  };
}
