class EveryDay {
  List<bool> everyDay;

  EveryDay({this.everyDay});

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

class TabAvailabilityStoreState {
  double height;
  int numberOfInterval;
  List<bool> switchWeek;
  List<EveryDay> daysInterval;

  TabAvailabilityStoreState({
    this.height,
    this.numberOfInterval,
    this.switchWeek,
    this.daysInterval,
  });

  TabAvailabilityStoreState copyWith({
    double height,
    int numberOfInterval,
    List<bool> switchWeek,
    List<EveryDay> daysInterval,
  }) {
    return TabAvailabilityStoreState(
      height: height ?? this.height,
      numberOfInterval: numberOfInterval ?? this.numberOfInterval,
      switchWeek: switchWeek ?? this.switchWeek,
      daysInterval: daysInterval ?? this.daysInterval,
    );
  }

  TabAvailabilityStoreState toEmpty() {
    return TabAvailabilityStoreState(
        height: 350.00,
        numberOfInterval: 1,
        switchWeek: [true],
        daysInterval: [EveryDay(everyDay: [false,false,false,false,false,false,false,])],
    );
  }

  List<dynamic> convertToJson(List<EveryDay> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  TabAvailabilityStoreState.fromJson(Map<String, dynamic> json)
      : height = json['height'],
        numberOfInterval = json['numberOfInterval'],
        switchWeek = List<bool>.from(json['switchWeek']),
        daysInterval = List<EveryDay>.from(json["daysInterval"].map((item) {
          return EveryDay(
            everyDay: item["everyDay"] != null ? List<bool>.from(item["everyDay"]) : "",
          );
        }));

  Map<String, dynamic> toJson() => {
        'height': height,
        'numberOfInterval': numberOfInterval,
        'switchWeek': switchWeek,
        'daysInterval': convertToJson(daysInterval),
      };
}
