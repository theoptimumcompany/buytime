import 'package:BuyTime/reblox/model/old/filter_search_state.dart';

class SetStars {
  List<bool> _star = [false, false, false, false, false];
  SetStars(this._star);
  List<bool> get star => _star;
}

class SetEuros {
  List<bool> _euro = [false, false, false, false];
  SetEuros(this._euro);
  List<bool> get euro => _euro;
}

class SetDistance {
  double _distance = 0;
  SetDistance(this._distance);
  double get distance => _distance;
}
class SetSearchText {
  String _searchText = "";
  SetSearchText(this._searchText);
  String get searchText => _searchText;
}
class SetFood {
  bool _food = false;
  SetFood(this._food);
  bool get food => _food;
}
class SetHotel {
  bool _hotel = false;
  SetHotel(this._hotel);
  bool get hotel => _hotel;
}

class SetFilterToEmpty {
  FilterSearchState _filterState;
  SetFilterToEmpty();
  FilterSearchState get filterState => _filterState;
}

FilterSearchState filterReducer(FilterSearchState state, action) {
  FilterSearchState filterState = new FilterSearchState.fromState(state);
  if (action is SetStars) {
    filterState.star = action.star;
    return filterState;
  }
  if (action is SetEuros) {
    filterState.euro = action.euro;
    return filterState;
  }
  if (action is SetDistance) {
    filterState.distance = action.distance;
    return filterState;
  }
  if (action is SetSearchText) {
    filterState.searchText = action.searchText;
    return filterState;
  }
  if (action is SetFood) {
    filterState.food = action.food;
    return filterState;
  }
  if (action is SetHotel) {
    filterState.hotel = action.hotel;
    return filterState;
  }
  if (action is SetFilterToEmpty) {
    filterState = FilterSearchState().toEmpty();
    return filterState;
  }

  return state;
}