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
    @required this.videoAsset,
    @required this.textToDisplay,
    @required this.orderState,
    @required this.reservable,
    @required this.tourist,
    videoController,
  }) : _videorController = videoController, super(key: key);

  final CardState cardState;
  final String cardOrBooking;
  final String fromValue;
  final String textToDisplay;
  final String videoAsset;
  final bool reservable;
  final bool tourist;
  final OrderReservableState orderReservableState;
  final OrderState orderState;
  final VideoPlayerController _videorController;

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {



  void initVideoController(VideoPlayerController videoPlayerController) {
    videoPlayerController.play();
    // videoPlayerController.seekTo(Duration(seconds: 3));
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(0.0);
  }

  @override
  void initState() {
    widget._videorController..initialize().then((_) {
      initVideoController(widget._videorController);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._videorController.dispose();
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
            Container(
              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2.5),
              padding: EdgeInsets.all(5.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.textToDisplay,
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
        Container(
          width: SizeConfig.safeBlockVertical * 20,
          height: SizeConfig.safeBlockVertical * 20,
          child: Center(
              child: widget._videorController != null &&  widget._videorController.value.isInitialized
                  ? SizedBox.expand(
                child: FittedBox(
                  // If your background video doesn't look right, try changing the BoxFit property.
                  // BoxFit.fill created the look I was going for.
                    fit: BoxFit.cover,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      width: widget._videorController.value.size?.width ?? 0,
                      height: widget._videorController.value.size?.height ?? 0,
                      child: VideoPlayer(
                        widget._videorController,
                      ),
                    )
                ),
              ) : Container()
          ),
        ),
      ],
    );
  }
}