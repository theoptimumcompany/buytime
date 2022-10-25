/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Progress extends StatefulWidget {
  const Progress({
    Key key,
    @required this.cardState,
    @required this.orderReservableState,
    @required this.cardOrBooking,
    @required this.fromValue,
    // @required this.videoAsset,
    @required this.textToDisplay,
    @required this.orderState,
    @required this.reservable,
    @required this.tourist,
  }) : super(key: key);

  final CardState cardState;
  final String cardOrBooking;
  final String fromValue;
  final String textToDisplay;
  // final String videoAsset;
  final bool reservable;
  final bool tourist;
  final OrderReservableState orderReservableState;
  final OrderState orderState;

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  VideoPlayerController _videoController;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);

  void initVideoController(VideoPlayerController videoPlayerController) {

    videoPlayerController.play();
    // videoPlayerController.seekTo(Duration(seconds: 3));
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(0.0);
  }

  @override
  void initState() {
    // _videoController = VideoPlayerController.asset(widget.videoAsset, videoPlayerOptions: videoPlayerOptions);
    // _videoController..initialize().then((_) {
    //   initVideoController(_videoController);
    //   setState(() {
    //     _videoController = _videoController;
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
          height: SizeConfig.safeBlockVertical * 8,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Room or Credit CardText
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                  child: Text(
                    widget.cardOrBooking, // == 0 ? AppLocalizations.of(context).creditCard : AppLocalizations.of(context).room
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      letterSpacing: 0.25,
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextMedium,
                      fontSize: 14, ///SizeConfig.safeBlockHorizontal * 3.5
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ///Room or Credit Card Value
                Container(
                  margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                  child: Text(
                    widget.fromValue, /// == 2 ? '${cardState.stripeState.stripeCard.brand} **** ${cardState.stripeState.stripeCard.last4}' : AppLocalizations.of(context).roomNumber,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextBlack,
                      fontSize: 16, ///SizeConfig.safeBlockHorizontal * 3.5
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
          color: BuytimeTheme.BackgroundLightGrey,
          height: SizeConfig.safeBlockVertical * .2,
        ),
        ///Order Status
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2.5, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  widget.textToDisplay,
                  maxLines: 2,
                  style: TextStyle(
                    letterSpacing: 1.25,
                    fontFamily: BuytimeTheme.FontFamily,
                    color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                    fontSize: 16, ///SizeConfig.safeBlockHorizontal * 3.5
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        ///Animation
        // Container(
        //   width: SizeConfig.safeBlockVertical * 20,
        //   height: SizeConfig.safeBlockVertical * 20,
        //   child: Center(
        //       child: (_videoController != null &&  _videoController.value.isInitialized)
        //           ? SizedBox.expand(
        //         child: FittedBox(
        //           // If your background video doesn't look right, try changing the BoxFit property.
        //           // BoxFit.fill created the look I was going for.
        //             fit: BoxFit.cover,
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(20)),
        //               ),
        //               width: _videoController.value.size?.width ?? 0,
        //               height: _videoController.value.size?.height ?? 0,
        //               child: VideoPlayer(
        //                 _videoController,
        //               ),
        //             )
        //         ),
        //       ) : Container()
        //   ),
        // ),
      ],
    );
  }
}