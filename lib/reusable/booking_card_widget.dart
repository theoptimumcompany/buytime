import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class BookingCardWidget extends StatefulWidget {

  BookingState bookingState;
  BookingCardWidget(this.bookingState);

  @override
  _BookingCardWidgetState createState() => _BookingCardWidgetState();
}

class _BookingCardWidgetState extends State<BookingCardWidget> {

  @override
  void initState() {
    super.initState();
    if(widget.bookingState.status == 'opened')
      readDynamicLink(widget.bookingState.booking_code);
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

  ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  ColorFilter identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {

    return ColorFiltered(
      colorFilter: widget.bookingState.status == 'opened' ? identity: greyscale,
      child: Container(
        height: SizeConfig.safeBlockVertical * 28,
        width: SizeConfig.safeBlockHorizontal * 80,
        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(widget.bookingState.wide),
              fit: BoxFit.cover,
            )
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black.withOpacity(.3),
            onTap: widget.bookingState.status == 'opened' ? (){
              StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(widget.bookingState));
              StoreProvider.of<AppState>(context).dispatch(BusinessAndNavigateRequest(widget.bookingState.business_id));
            } : null,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              height: SizeConfig.safeBlockVertical * 25,
              width: SizeConfig.safeBlockHorizontal * 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: widget.bookingState.status == 'opened' ? Colors.black.withOpacity(.2) : BuytimeTheme.TextWhite.withOpacity(0.1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.bookingState.business_name,
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: widget.bookingState.status == 'opened' ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockHorizontal * 4
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 0),
                        child:  FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${DateFormat('dd MMMM').format(widget.bookingState.start_date)} - ${DateFormat('dd MMMM yyyy').format(widget.bookingState.end_date)}',
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: widget.bookingState.status == 'opened' ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockHorizontal * 4
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 1),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.bookingState.status.substring(0,1).toUpperCase() + widget.bookingState.status.substring(1,widget.bookingState.status.length),
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: widget.bookingState.status == 'opened' ? BuytimeTheme.TextWhite : BuytimeTheme.TextWhite.withOpacity(.8),
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockHorizontal * 4
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
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockHorizontal * 0),
                      child: IconButton(
                        onPressed: widget.bookingState.status == 'opened' ?  (){
                          final RenderBox box = context.findRenderObject();
                          Share.share('check out Buytime App at $link', subject: 'Take your Time!', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
    );
  }
}

