import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/old/filter_search_state.dart';
import 'package:BuyTime/reblox/reducer/filter_reducer.dart';
import 'package:BuyTime/reusable/form/filter/filter_euro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'filter_star.dart';

class FilterTongue extends StatefulWidget {
  FilterTongue(bool up) {
    this.up = up;
  }
  bool up = false;

  @override
  State<StatefulWidget> createState() => FilterTongueState();
}

class FilterTongueState extends State<FilterTongue> {

  String locationPreview (AppState snapshot) {
    return (snapshot.filterSearch.searchText == "" ? "me" : (snapshot.filterSearch.searchText.length > 4 ? snapshot.filterSearch.searchText.substring(0, 5) + "... center" : snapshot.filterSearch.searchText + "... center") );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AnimatedContainer(
        padding: EdgeInsets.all(10.0),
        duration: Duration(milliseconds: 500),
        // Animation speed
        transform: Transform.translate(
          offset: Offset(
              0, widget.up == true ? 0 : -1000), // Change -100 for the y offset
        ).transform,
        width: media.width * 0.95,
        height: media.height * 0.45,
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 3.0),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  color: Color.fromARGB(200, 130, 130, 130)),
            ],
            borderRadius: new BorderRadius.vertical(
              bottom: const Radius.elliptical(50, 40),
            )),
        child: Container(
          //height: 50.0,
          child: Container(
              child: Column(children: [
            Row(
              children: [
                SizedBox(
                  height: media.height * 0.03,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: media.height * 0.01,
                ),
              ],
            ),
            Container(
              height: media.height * 0.10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: media.height * 0.12,
                    child: Stack(alignment: Alignment.topCenter, children: [
                      SizedBox(
                        width: media.width * 0.4,
                      ),
                      Positioned(
                        top: 0,
                        child: Image(
                            width: 60,
                            image: AssetImage("assets/img/food.png")),
                      ),
                      Positioned(
                        top: 25,
                        child: Container(
                            width: media.width * 0.4,
                            height: media.height * 0.08,
                            child: RaisedButton(
                              onPressed: null,
                              padding:
                                  EdgeInsets.only(top: media.height * 0.035),
                              textColor: Colors.white,
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(500.0)),
                              child: Text(
                                "Food",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ),
                    ]),
                  ),
                  Container(
                    height: media.height * 0.12,
                    child: Stack(alignment: Alignment.topCenter, children: [
                      SizedBox(
                        width: media.width * 0.4,
                      ),
                      Positioned(
                        top: 0,
                        child: Image(
                            width: 60,
                            image: AssetImage("assets/img/hotel.png")),
                      ),
                      Positioned(
                        top: 25,
                        child: Container(
                            width: media.width * 0.4,
                            height: media.height * 0.08,
                            child: RaisedButton(
                              onPressed: null,
                              padding:
                                  EdgeInsets.only(top: media.height * 0.035),
                              textColor: Colors.white,
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(500.0)),
                              child: Text(
                                "Hotel",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: media.height * 0.018,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Price range",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                    child: GestureDetector(
                  child: StoreConnector<AppState, AppState>(
                      converter: (store) => store.state,
                      builder: (context, snapshot) {
                        return Row(
                          children: [Euro(0), Euro(1), Euro(2), Euro(3)],
                        );
                      }),
                  onTap: () {},
                ))
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: media.height * 0.018,
                ),
              ],
            ),
            //Distance Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, snapshot) {
                    return Container(
                      child: Text(
                        "Distance from " + (locationPreview(snapshot)) +
                            " : " +
                            snapshot.filterSearch.distance.toString() +
                            " Km",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(
                  width: media.width * 0.09,
                )
              ],
            ),
            Row(
              children: [
                StoreConnector<AppState, AppState>(
                    converter: (store) => store.state,
                    builder: (context, snapshot) {
                    return Container(
                      width: media.width * 0.89,
                      child: Slider.adaptive(
                        value: snapshot.filterSearch.distance.toDouble(),
                        min: 0.0,
                        max: 25,
                        divisions: 5,
                        label: snapshot.filterSearch.distance.toString(),
                        onChanged: (double distance) => {StoreProvider.of<AppState>(context).dispatch(SetDistance(distance))},
                      ),
                    );
                  }
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Rating",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  child: GestureDetector(
                    child: StoreConnector<AppState, AppState>(
                        converter: (store) => store.state,
                        builder: (context, snapshot) {
                          return Row(
                            children: [
                              Star(0),
                              Star(1),
                              Star(2),
                              Star(3),
                              Star(4),
                            ],
                          );
                        }),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ])),
        ));
  }
}
