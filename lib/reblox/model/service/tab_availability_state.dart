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
  int numberOfInterval;
  List<bool> switchWeek;
  List<EveryDay> daysInterval;

  TabAvailabilityStoreState({
    this.numberOfInterval,
    this.switchWeek,
    this.daysInterval,
  });

  TabAvailabilityStoreState copyWith({
    int numberOfInterval,
    List<bool> switchWeek,
    List<EveryDay> daysInterval,
  }) {
    return TabAvailabilityStoreState(
      numberOfInterval: numberOfInterval ?? this.numberOfInterval,
      switchWeek: switchWeek ?? this.switchWeek,
      daysInterval: daysInterval ?? this.daysInterval,
    );
  }

  TabAvailabilityStoreState toEmpty() {
    return TabAvailabilityStoreState(
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
      : numberOfInterval = json['numberOfInterval'],
        switchWeek = List<bool>.from(json['switchWeek']),
        daysInterval = List<EveryDay>.from(json["daysInterval"].map((item) {
          return EveryDay(
            everyDay: item["everyDay"] != null ? List<bool>.from(item["everyDay"]) : "",
          );
        }));

  Map<String, dynamic> toJson() => {
        'numberOfInterval': numberOfInterval,
        'switchWeek': switchWeek,
        'daysInterval': convertToJson(daysInterval),
      };
}
