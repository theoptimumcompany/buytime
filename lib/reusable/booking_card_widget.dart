import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

typedef OnBookingCallback = void Function(bool clicked);
class BookingCardWidget extends StatefulWidget {

  BookingState bookingState;
  OnBookingCallback call;
  BookingCardWidget({this.bookingState, this.call});

  @override
  _BookingCardWidgetState createState() => _BookingCardWidgetState();
}

class _BookingCardWidgetState extends State<BookingCardWidget> {

  String bookingStatus = '';
  bool closed = false;

  @override
  void initState() {
    super.initState();
    if(widget.bookingState.status == 'opened')
      readDynamicLink(widget.bookingState.booking_code);

    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.bookingState.end_date.isBefore(DateTime.now())){
        widget.bookingState.status = widget.bookingState.enumToString(BookingStatus.closed);
        StoreProvider.of<AppState>(context).dispatch(UpdateBooking(widget.bookingState));
      }
    });*/

    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);

    DateTime endTime = DateTime.now();
    //DateTime startTime = DateTime.now();
    endTime = new DateTime(widget.bookingState.end_date.year, widget.bookingState.end_date.month, widget.bookingState.end_date.day, 0, 0, 0, 0, 0);
    if(endTime.isBefore(currentTime)){
      bookingStatus = 'Closed';
      closed = true;
    }else if(widget.bookingState.start_date.isAtSameMomentAs(currentTime))
      bookingStatus = 'Active';
    else if(widget.bookingState.start_date.isAfter(currentTime))
      bookingStatus = 'Upcoming';
    else
      bookingStatus = 'Active';


  }

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buytime.page.link',
      link: Uri.parse('https://buytime.page.link/booking/?booking=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.theoptimumcompany.buytime',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.theoptimumcompany.buytime',
        minimumVersion: '1',
        appStoreId: '1508552491',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    print("Link dinamico creato " + dynamicUrl.toString());
    return dynamicUrl;
  }

  String link = '';
  Future readDynamicLink(String id) async{
    if(link.isEmpty){
      Uri tmp = await createDynamicLink(id);
      setState(() {
        link = '$tmp';
      });
    }
  }

  ///Grey scale
  ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  ///Normal scale
  ColorFilter identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {

    return ColorFiltered(
      colorFilter: !closed ? identity: greyscale,
      child: CachedNetworkImage(
        imageUrl: widget.bookingState.wide,
        imageBuilder: (context, imageProvider) => Container(
          height: 200, ///SizeConfig.safeBlockVertical * 28
          width: 310, ///SizeConfig.safeBlockHorizontal * 80
          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5, left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.black.withOpacity(.3),
              onTap: !closed ? (){
                widget.call(true);
                StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(widget.bookingState));
                StoreProvider.of<AppState>(context).dispatch(BusinessServiceListAndNavigateRequest(widget.bookingState.business_id));
              } : null,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Container(
                height: 200, ///SizeConfig.safeBlockVertical * 25
                width: 310, ///SizeConfig.safeBlockHorizontal * 50
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: !closed ? Colors.black.withOpacity(.2) : BuytimeTheme.TextWhite.withOpacity(0.1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, bottom: SizeConfig.safeBlockVertical * .5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.bookingState.business_name,
                              style: TextStyle(
                                  letterSpacing:  -.1,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: !closed ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, bottom: SizeConfig.safeBlockVertical * .5),
                          child:  FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${DateFormat('dd MMMM',Localizations.localeOf(context).languageCode).format(widget.bookingState.start_date)} - ${DateFormat('dd MMMM yyyy').format(widget.bookingState.end_date)}',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: !closed ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, bottom: SizeConfig.safeBlockVertical * 1.5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              bookingStatus == 'Active' ?
                              AppLocalizations.of(context).active :
                              bookingStatus == 'Upcoming' ?
                              AppLocalizations.of(context).upcoming :
                              AppLocalizations.of(context).closed ,
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: !closed ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ///Share icon
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockHorizontal * .5),
                        child: IconButton(
                          onPressed: !closed ? (){
                            final RenderBox box = context.findRenderObject();
                            Share.share('${AppLocalizations.of(context).checkOutBuytimeApp} $link', subject: '${AppLocalizations.of(context).takeYourTime}', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                          } : null,
                          icon: Icon(
                            Icons.share,
                            color: widget.bookingState.status == 'opened' ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          height: 200, ///SizeConfig.safeBlockVertical * 28
          width: 310, ///SizeConfig.safeBlockHorizontal * 80
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //padding: EdgeInsets.only(top: 80, bottom: 80, left: 50, right: 50),
                child: CircularProgressIndicator(
                  //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                ),
              )
            ],
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      )
    );
  }
}

