class EveryDay {
  List<bool> everyDay;

  EveryDay({this.everyDay});

  EveryDay toEmpty() {
    return EveryDay(
      everyDay: [false,false,false,false,false,false,false,],
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

class TabAvailabilityStoreState {
  double tabHeight;
  double intervalsHeight;
  int numberOfInterval;
  List<bool> switchWeek;
  List<EveryDay> daysInterval;

  TabAvailabilityStoreState({
    this.tabHeight,
    this.intervalsHeight,
    this.numberOfInterval,
    this.switchWeek,
    this.daysInterval,
  });

  TabAvailabilityStoreState copyWith({
    double tabHeight,
    double intervalsHeight,
    int numberOfInterval,
    List<bool> switchWeek,
    List<EveryDay> daysInterval,
  }) {
    return TabAvailabilityStoreState(
      tabHeight: tabHeight ?? this.tabHeight,
      intervalsHeight: intervalsHeight ?? this.intervalsHeight,
      numberOfInterval: numberOfInterval ?? this.numberOfInterval,
      switchWeek: switchWeek ?? this.switchWeek,
      daysInterval: daysInterval ?? this.daysInterval,
    );
  }

  TabAvailabilityStoreState toEmpty() {
    return TabAvailabilityStoreState(
        tabHeight: 350.00,
        intervalsHeight: 190.00,
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
      : tabHeight = json.containsKey('tabHeight') ?  json['tabHeight'].toDouble() : 0.0,
        intervalsHeight = json.containsKey('intervalsHeight') ?  json['intervalsHeight'].toDouble() : 0.0,
        numberOfInterval = json['numberOfInterval'],
        switchWeek = List<bool>.from(json['switchWeek']),
        daysInterval = List<EveryDay>.from(json["daysInterval"].map((item) {
          return EveryDay(
            everyDay: item["everyDay"] != null ? List<bool>.from(item["everyDay"]) : "",
          );
        }));

  Map<String, dynamic> toJson() => {
        'tabHeight': tabHeight,
        'intervalsHeight': intervalsHeight,
        'numberOfInterval': numberOfInterval,
        'switchWeek': switchWeek,
        'daysInterval': convertToJson(daysInterval),
      };
}
