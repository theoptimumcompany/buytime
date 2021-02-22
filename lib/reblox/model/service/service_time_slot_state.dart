import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceSlot {
  ///External Interval (Stepper) vars
  int numberOfSlot; //todo
  int actualSlotIndex; //todo

  List<GlobalKey<FormState>> formSlotTimeKey =
      []; //todo: lista di globalKey non vengono salvate su db, vanno ricostruite prima di entrare nella edit service(azzerato alla create) in base al numero di stepper
  List<GlobalKey<FormState>> formSlotLengthKey = [];
  List<GlobalKey<FormState>> formSlotPriceKey = [];

  ///Time Slot Inner Interval vars
  List<int> numberOfInterval; //todo
  List<ListWeek> switchWeek;
  List<ListEveryDay> daysInterval;

  ///Time vars
  List<ListTextEditingController> startController = [];
  List<ListTextEditingController> stopController = [];
  List<EveryTime> startTime = [];
  List<EveryTime> stopTime = [];

  ///Calendar vars
  List<TextEditingController> checkInController = [];
  List<TextEditingController> checkOutController = [];
  List<DateTime> checkIn = [];
  List<DateTime> checkOut = [];

  ///Length vars
  List<TextEditingController> hourController = [];
  List<TextEditingController> minuteController = [];
  List<TextEditingController> limitBookingController = [];

  ///Price vars
  List<TextEditingController> priceController = [];

  ServiceSlot({
    this.numberOfSlot,
    this.actualSlotIndex,
    this.numberOfInterval,
    this.switchWeek,
    this.daysInterval,
    this.startController,
    this.stopController,
    this.startTime,
    this.stopTime,
    this.checkInController,
    this.checkOutController,
    this.checkIn,
    this.checkOut,
    this.formSlotTimeKey,
    this.formSlotLengthKey,
    this.formSlotPriceKey,
    this.hourController,
    this.minuteController,
    this.limitBookingController,
    this.priceController,
  });

  ServiceSlot copyWith({
    int numberOfSlot,
    int actualSlotIndex,
    List<int> numberOfInterval,
    List<ListWeek> switchWeek,
    List<ListEveryDay> daysInterval,
    List<ListTextEditingController> startController,
    List<ListTextEditingController> stopController,
    List<EveryTime> startTime,
    List<EveryTime> stopTime,
    List<TextEditingController> checkInController,
    List<TextEditingController> checkOutController,
    List<DateTime> checkIn,
    List<DateTime> checkOut,
    List<GlobalKey<FormState>> formSlotTimeKey,
    List<GlobalKey<FormState>> formSlotLengthKey,
    List<GlobalKey<FormState>> formSlotPriceKey,
    List<TextEditingController> hourController,
    List<TextEditingController> minuteController,
    List<TextEditingController> limitBookingController,
    List<TextEditingController> priceController,
  }) {
    return ServiceSlot(
      numberOfSlot: numberOfSlot ?? this.numberOfSlot,
      actualSlotIndex: actualSlotIndex ?? this.actualSlotIndex,
      numberOfInterval: numberOfInterval ?? this.numberOfInterval,
      switchWeek: switchWeek ?? this.switchWeek,
      daysInterval: daysInterval ?? this.daysInterval,
      startController: startController ?? this.startController,
      stopController: stopController ?? this.stopController,
      startTime: startTime ?? this.startTime,
      stopTime: stopTime ?? this.stopTime,
      checkInController: checkInController ?? this.checkInController,
      checkOutController: checkOutController ?? this.checkOutController,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      formSlotTimeKey: formSlotTimeKey ?? this.formSlotTimeKey,
      formSlotLengthKey: formSlotLengthKey ?? this.formSlotLengthKey,
      formSlotPriceKey: formSlotPriceKey ?? this.formSlotPriceKey,
      hourController: hourController ?? this.hourController,
      minuteController: minuteController ?? this.minuteController,
      limitBookingController: limitBookingController ?? this.limitBookingController,
      priceController: priceController ?? this.priceController,
    );
  }

  ServiceSlot toEmpty() {
    return ServiceSlot(
      numberOfSlot: 1,
      actualSlotIndex: 0,
      numberOfInterval: [1],
      switchWeek: [ListWeek().toEmpty()],
      daysInterval: [ListEveryDay().toEmpty()],
      startController: [ListTextEditingController().toEmpty()],
      stopController: [ListTextEditingController().toEmpty()],
      startTime: [EveryTime().toEmpty()],
      stopTime: [EveryTime().toEmpty()],
      checkInController: [TextEditingController()],
      checkOutController: [TextEditingController()],
      checkIn: [DateTime.now()],
      checkOut: [DateTime.now()],
      formSlotTimeKey: [GlobalKey<FormState>()],
      formSlotLengthKey: [GlobalKey<FormState>()],
      formSlotPriceKey: [GlobalKey<FormState>()],
      hourController: [TextEditingController()],
      minuteController: [TextEditingController()],
      limitBookingController: [TextEditingController()],
      priceController: [TextEditingController()],
    );
  }

  List<dynamic> convertToJsonEveryDay(ListEveryDay objectStateList) {
    List<dynamic> list = [];
    objectStateList.listEveryDay.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  List<dynamic> convertToJsonListEveryDay(List<ListEveryDay> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  List<dynamic> convertListTextEditingControllerToString(List<ListTextEditingController> controllers) {
    List<dynamic> strings = [];
    controllers.forEach((element) {
      strings.add(element.toJson());
    });
    return strings;
  }

  List<dynamic> convertEveryTimeToString(List<EveryTime> times) {
    List<dynamic> strings = [];
    times.forEach((element) {
      strings.add(element.toJson());
    });
    return strings;
  }

  List<dynamic> convertToJson(var objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  ServiceSlot.convertStringToTextEditingController(List<String> strings, String inOut) {
    List<TextEditingController> list = [];
    strings.forEach((element) {
      TextEditingController tec = TextEditingController();
      tec.text = element;
      list.add(tec);
    });
    switch (inOut) {
      case 'in':
        checkInController = list;
        break;
      case 'out':
        checkOutController = list;
        break;
      case 'hour':
        hourController = list;
        break;
      case 'minute':
        minuteController = list;
        break;
      case 'limit':
        limitBookingController = list;
        break;
      case 'price':
        priceController = list;
        break;
    }
  }

  ServiceSlot.fromJson(Map<String, dynamic> json)
      : numberOfSlot = json.containsKey('numberOfSlot') ? json['numberOfSlot'] : 1,
        actualSlotIndex = json.containsKey('actualSlotIndex') ? json['actualSlotIndex'] : 0,
        numberOfInterval = json.containsKey('numberOfInterval') ? List<int>.from(json['numberOfInterval']) : [1],
        switchWeek = json.containsKey('switchWeek')
            ? List<ListWeek>.from(json["switchWeek"].map((item) {
                return ListWeek.fromJson(item);
              }))
            : [ListWeek().toEmpty()],
        startTime = json.containsKey('startTime')
            ? List<EveryTime>.from(json["startTime"].map((item) {
                return EveryTime.fromJson(item);
              }))
            : [EveryTime().toEmpty()],
        stopTime = json.containsKey('stopTime')
            ? List<EveryTime>.from(json["stopTime"].map((item) {
                return EveryTime.fromJson(item);
              }))
            : [EveryTime().toEmpty()],
        checkInController =
            json.containsKey('checkInController') ? ServiceSlot.convertStringToTextEditingController(List<String>.from(json['checkInController']), "in").checkInController : [TextEditingController()],
        checkOutController = json.containsKey('checkOutController')
            ? ServiceSlot.convertStringToTextEditingController(List<String>.from(json['checkOutController']), "out").checkOutController
            : [TextEditingController()],
        checkIn = json.containsKey('checkIn') ? ServiceSlot.convertStringToDateTime(List<String>.from(json['checkIn']), "in").checkIn : [DateTime.now()],
        checkOut = json.containsKey('checkOut') ? ServiceSlot.convertStringToDateTime(List<String>.from(json['checkOut']), "out").checkOut : [DateTime.now()],
        hourController =
            json.containsKey('hourController') ? ServiceSlot.convertStringToTextEditingController(List<String>.from(json['hourController']), "hour").hourController : [TextEditingController()],
        minuteController =
            json.containsKey('minuteController') ? ServiceSlot.convertStringToTextEditingController(List<String>.from(json['minuteController']), "minute").minuteController : [TextEditingController()],
        limitBookingController = json.containsKey('limitBookingController')
            ? ServiceSlot.convertStringToTextEditingController(List<String>.from(json['limitBookingController']), "limit").limitBookingController
            : [TextEditingController()],
        priceController =
            json.containsKey('priceController') ? ServiceSlot.convertStringToTextEditingController(List<String>.from(json['priceController']), "price").priceController : [TextEditingController()],
        startController = json.containsKey('startController')
            ? List<ListTextEditingController>.from(json["startController"].map((item) {
                return ListTextEditingController.fromJson(item);
              }))
            : [ListTextEditingController().toEmpty()],
        stopController = json.containsKey('stopController')
            ? List<ListTextEditingController>.from(json["stopController"].map((item) {
                return ListTextEditingController.fromJson(item);
              }))
            : [ListTextEditingController().toEmpty()],
        daysInterval = json.containsKey('daysInterval')
            ? List<ListEveryDay>.from(json["daysInterval"].map((item) {
                return ListEveryDay.fromJson(item);
              }))
            : [ListEveryDay().toEmpty()];

  List<String> convertTextEditingControllerToString(List<TextEditingController> controllers) {
    List<String> list = [];
    controllers.forEach((element) {
      list.add(element.text);
    });
    return list;
  }

  List<String> convertDateTimeToString(List<DateTime> times) {
    List<String> list = [];
    times.forEach((element) {
      String year = element.year.toString();
      String month = element.month < 10 ? "0" + element.month.toString() : element.month.toString();
      String day = element.day < 10 ? "0" + element.day.toString() : element.day.toString();
      list.add(day + "/" + month + "/" + year);
    });
    return list;
  }

  ServiceSlot.convertStringToDateTime(List<String> strings, String inOut) {
    List<DateTime> list = [];
    strings.forEach((element) {
      DateTime tec;
      List<String> time = element.split('/');
      tec = DateTime.utc(int.parse(time[2]), int.parse(time[1]), int.parse(time[0])); //    int.parse(time[0]),int.parse(time[1]),int.parse(time[2]),);
      list.add(tec);
    });
    inOut == "in" ? checkIn = list : checkOut = list;
  }

  Map<String, dynamic> toJson() => {
        'numberOfSlot': numberOfSlot,
        'actualSlotIndex': actualSlotIndex,
        'numberOfInterval': numberOfInterval,
        'switchWeek': convertToJson(switchWeek),
        'daysInterval': convertToJsonListEveryDay(daysInterval),
        'startController': convertListTextEditingControllerToString(startController),
        'stopController': convertListTextEditingControllerToString(stopController),
        'startTime': convertEveryTimeToString(startTime),
        'stopTime': convertEveryTimeToString(stopTime),
        'checkInController': convertTextEditingControllerToString(checkInController),
        'checkOutController': convertTextEditingControllerToString(checkOutController),
        'checkIn': convertDateTimeToString(checkIn),
        'checkOut': convertDateTimeToString(checkOut),
        'hourController': convertTextEditingControllerToString(hourController),
        'minuteController': convertTextEditingControllerToString(minuteController),
        'limitBookingController': convertTextEditingControllerToString(limitBookingController),
        'priceController': convertTextEditingControllerToString(priceController),
      };
}
