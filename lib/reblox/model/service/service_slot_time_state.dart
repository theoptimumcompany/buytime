import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';

class ServiceSlot {
  ///Time Slot Inner Interval vars
  int numberOfInterval = 1;
  List<bool> switchWeek = [];
  List<EveryDay> daysInterval = [];

  ///Time vars
  List<String> startTime = [];
  List<String> stopTime = [];

  ///Calendar vars
  String checkIn = '';
  String checkOut = '';

  ///Length vars
  int hour = 0;
  int minute = 0;
  int limitBooking = 1;
  bool noLimitBooking = false;

  ///Price vars
  double price = 0.0;

  ///Vars out of DB
  int minDuration = 10;
  List<bool> intervalVisibility = [true];

  ServiceSlot({
    this.numberOfInterval,
    this.switchWeek,
    this.daysInterval,
    this.startTime,
    this.stopTime,
    this.checkIn,
    this.checkOut,
    this.hour,
    this.minute,
    this.limitBooking,
    this.noLimitBooking,
    this.price,
    this.minDuration,
    this.intervalVisibility,
  });

  ServiceSlot copyWith({
    int numberOfInterval,
    List<bool> switchWeek,
    List<EveryDay> daysInterval,
    List<String> startTime,
    List<String> stopTime,
    String checkIn,
    String checkOut,
    int hour,
    int minute,
    int limitBooking,
    bool noLimitBooking,
    double price,
    int minDuration,
    int intervalVisibility,
  }) {
    return ServiceSlot(
      numberOfInterval: numberOfInterval ?? this.numberOfInterval,
      switchWeek: switchWeek ?? this.switchWeek,
      daysInterval: daysInterval ?? this.daysInterval,
      startTime: startTime ?? this.startTime,
      stopTime: stopTime ?? this.stopTime,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      limitBooking: limitBooking ?? this.limitBooking,
      noLimitBooking: noLimitBooking ?? this.noLimitBooking,
      price: price ?? this.price,
      minDuration: minDuration ?? this.minDuration,
      intervalVisibility: intervalVisibility ?? this.intervalVisibility,
    );
  }

  ServiceSlot toEmpty() {
    return ServiceSlot(
      numberOfInterval: 1,
      switchWeek: [true],
      daysInterval: [EveryDay().toEmpty()],
      startTime: [],
      stopTime: [],
      checkIn: '',
      checkOut: '',
      hour: 0,
      minute: 0,
      limitBooking: 1,
      noLimitBooking: false,
      price: 0.0,
      minDuration: 10,
      intervalVisibility: [true],
    );
  }

  ServiceSlot.fromState(ServiceSlot serviceSlot) {
    this.numberOfInterval = serviceSlot.numberOfInterval;
    this.switchWeek = serviceSlot.switchWeek;
    this.daysInterval = serviceSlot.daysInterval;
    this.startTime = serviceSlot.startTime;
    this.stopTime = serviceSlot.stopTime;
    this.checkIn = serviceSlot.checkIn;
    this.checkOut = serviceSlot.checkOut;
    this.hour = serviceSlot.hour;
    this.minute = serviceSlot.minute;
    this.limitBooking = serviceSlot.limitBooking;
    this.noLimitBooking = serviceSlot.noLimitBooking;
    this.price = serviceSlot.price;
    this.minDuration = serviceSlot.minDuration;
    this.intervalVisibility = serviceSlot.intervalVisibility;
  }

  // List<dynamic> convertToJsonEveryDay(List<EveryDay> objectStateList) {
  //   List<dynamic> list = [];
  //   objectStateList.forEach((element) {
  //     list.add(element.toJson());
  //   });
  //   return list;
  // }

  List<dynamic> convertToJson(var objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  ServiceSlot.fromJson(Map<String, dynamic> json)
      : numberOfInterval = json.containsKey('numberOfInterval') ? json['numberOfInterval'] : 1,
        switchWeek = json.containsKey('switchWeek') ? List<bool>.from(json["switchWeek"]) : [true],
        startTime = json.containsKey('startTime') ? List<String>.from(json["startTime"]) : [],
        stopTime = json.containsKey('stopTime') ? List<String>.from(json["stopTime"]) : [],
        checkIn = json.containsKey('checkIn') ? json['checkIn'] : [],
        checkOut = json.containsKey('checkOut') ? json['checkOut'] : [],
        hour = json.containsKey('hour') ? json['hour'] : 0,
        minute = json.containsKey('minute') ? json['minute'] : 0,
        limitBooking = json.containsKey('limitBooking') ? json['limitBooking'] : 1,
        noLimitBooking = json.containsKey('noLimitBooking') ? json['noLimitBooking'] : false,
        price = json.containsKey('price') ? json['price'] : 0,
        daysInterval = json.containsKey('daysInterval')
            ? List<EveryDay>.from(json["daysInterval"].map((item) {
                return EveryDay(
                  everyDay: List<bool>.from(item['everyDay']),
                );
              }))
            : [EveryDay().toEmpty()];

  Map<String, dynamic> toJson() => {
        'numberOfInterval': numberOfInterval,
        'switchWeek': switchWeek,
        'daysInterval': convertToJson(daysInterval),
        'startTime': startTime,
        'stopTime': stopTime,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'hour': hour,
        'minute': minute,
        'limitBooking': limitBooking,
        'noLimitBooking': noLimitBooking,
        'price': price,
      };
}
