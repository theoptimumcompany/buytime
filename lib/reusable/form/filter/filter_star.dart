import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/old/filter_search_state.dart';
import 'package:BuyTime/reblox/reducer/filter_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class Star extends StatefulWidget {
  Star(int index) {
    this.index = index;
  }
  int index;

  @override
  State<StatefulWidget> createState() => StarState();
}

class StarState extends State<Star> {
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
              image: snapshot.star[widget.index]
                  ? AssetImage("assets/img/star_on.png")
                  : AssetImage("assets/img/star_off.png"),
            );
          },
        ),
        onTap: () {
          List<bool> star = [false, false, false, false, false];
          for (int i = 0; i <= widget.index; i++) {
            star[i] = true;
          }
          if (widget.index < 4) {
            for (int i = widget.index + 1; i <= 4; i++) {
              star[i] = false;
            }
          }
          print('filter_star: tap star');
          StoreProvider.of<AppState>(context).dispatch(SetStars(star));
        });
  }
}
