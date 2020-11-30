import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/old/filter_search_state.dart';
import 'package:BuyTime/reblox/reducer/filter_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../globals.dart' as globals;

class Euro extends StatefulWidget {

  Euro(int index) {
    this.index = index;
  }

  int index;

  @override
  State<StatefulWidget> createState() => EuroState();
}

class EuroState extends State<Euro> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        child: StoreConnector<AppState, FilterSearchState>(
          converter: (store) => store.state.filterSearch,
          builder: (context, snapshot) {
            return Image(
              width: 35,
              image: snapshot.euro[widget.index]
                  ? AssetImage("assets/img/euro_on.png")
                  : AssetImage("assets/img/euro_off.png"),
            );
          },
        ),
          onTap: () {
            List<bool> euro = [false, false, false, false];
            for (int i = 0; i <= widget.index; i++) {
              euro[i] = true;
            }
            if (widget.index < 3) {
              for (int i = widget.index + 1; i <= 3; i++) {
                euro[i] = false;
              }
            }
            print('filter_star: tap euro');
            StoreProvider.of<AppState>(context).dispatch(SetEuros(euro));
          });
  }
}
