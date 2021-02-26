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

  ///Price vars
  double price = 0.0;

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
    this.price,
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
    double price,
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
      price: price ?? this.price,
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
      price: 0.0,
    );
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
        'price': price,
      };
}
