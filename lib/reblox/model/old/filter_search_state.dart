import 'package:flutter/foundation.dart';

class FilterSearchState {
  List<bool> star;
  List<bool> euro;
  double distance;
  String searchText;
  bool food;
  bool hotel;

  FilterSearchState({
    @required this.star,
    @required this.euro,
    @required this.distance,
    @required this.searchText,
    @required this.food,
    @required this.hotel,
  });

  FilterSearchState toEmpty(
      {bool star,
      bool euro,
      double distance,
      String searchText,
      bool food,
      bool hotel}) {
    return FilterSearchState(
        star: [false, false, false, false, false],
        euro: [false, false, false, false],
        distance: 10.0,
        searchText: "",
        food: false,
        hotel: false);
  }

  FilterSearchState.fromState(FilterSearchState state) {
    this.star = state.star;
    this.euro = state.euro;
    this.distance = state.distance;
    this.searchText = state.searchText;
    this.food = state.food;
    this.hotel = state.hotel;
  }

  FilterSearchState copyWith(
      {bool star,
      bool euro,
      double distance,
      String searchText,
      bool food,
      bool hotel}) {
    return FilterSearchState(
      star: star ?? this.star,
      euro: euro ?? this.euro,
      distance: distance ?? this.distance,
      searchText: searchText ?? this.searchText,
      food: food ?? this.food,
      hotel: hotel ?? this.hotel,
    );
  }

  FilterSearchState.fromJson(Map json)
      : star = json['star'],
        euro = json['euro'],
        distance = json['distance'],
        searchText = json['searchText'],
        food = json['food'],
        hotel = json['hotel'];

  Map toJson() => {
        'star': star,
        'euro': euro,
        'distance': distance,
        'searchText': searchText,
        'food': food,
        'hotel': hotel,
      };
}
