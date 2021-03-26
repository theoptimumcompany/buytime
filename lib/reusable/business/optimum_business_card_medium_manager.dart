import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OptimumBusinessCardMediumManagerCallback = void Function(BusinessState);

class OptimumBusinessCardMediumManager extends StatefulWidget {
  OptimumBusinessCardMediumManagerCallback onBusinessCardTap;
  String imageUrl;
  Image image;
  BusinessState businessState;
  Widget rowWidget1;
  Widget rowWidget2;
  Widget rowWidget3;
  Size mediaSize;

  OptimumBusinessCardMediumManager(
      {this.image,
        @required this.imageUrl,
        @required this.businessState,
        this.onBusinessCardTap,
        this.rowWidget1,
        this.rowWidget2,
        this.rowWidget3,
        @required this.mediaSize}) {
    this.image = image;
    this.imageUrl = imageUrl;
    this.businessState = businessState;
    this.onBusinessCardTap = onBusinessCardTap;
    this.rowWidget1 = rowWidget1;
    this.rowWidget2 = rowWidget2;
    this.rowWidget3 = rowWidget3;
    this.mediaSize = mediaSize;
  }

  @override
  _OptimumBusinessCardMediumManagerState createState() =>
      _OptimumBusinessCardMediumManagerState(
          image: image,
          imageUrl: imageUrl,
          businessState: businessState,
          businessCardTap: onBusinessCardTap,
          rowWidget1: rowWidget1,
          rowWidget2: rowWidget2,
          rowWidget3: rowWidget3,
          mediaSize: mediaSize);
}

class _OptimumBusinessCardMediumManagerState extends State<OptimumBusinessCardMediumManager> {
  OptimumBusinessCardMediumManagerCallback businessCardTap;
  String imageUrl;
  Image image;
  BusinessState businessState;
  Widget rowWidget1;
  Widget rowWidget2;
  Widget rowWidget3;
  Size mediaSize;

  _OptimumBusinessCardMediumManagerState(
      {this.image,
        this.imageUrl,
        this.businessState,
        this.businessCardTap,
        this.rowWidget1,
        this.rowWidget2,
        this.rowWidget3,
        this.mediaSize});

  String version200(String imageUrl) {
    //debugPrint('optimum_business_card_medium_manager => RAW IMAGE URL: $imageUrl');
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_200x200" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }

    //debugPrint('optimum_business_card_medium_manager => IMAGE URL: $result');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image == null && widget.imageUrl == null) {
      return Container(
        child: Text(AppLocalizations.of(context).photoNotInserted),
      );
    }
    return Container(
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            //borderRadius: BorderRadius.all(Radius.circular(10)),
            onTap: () async {
              businessCardTap(widget.businessState);
            },
            child: Container(
              //height: 91,  ///SizeConfig.safeBlockVertical * 15
              //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
              child: Row(
                children: [
                  ///Image
                  widget.image == null
                      ? CachedNetworkImage(
                    imageUrl: version200(widget.imageUrl),
                    imageBuilder: (context, imageProvider) => Container(
                      //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(
                      //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                  /*Image.network(
                    version200(widget.imageUrl),
                    height: widget.mediaSize != null
                        ? widget.mediaSize.height * 0.13
                        : 50.0,
                  )*/
                      : widget.image,
                  SizedBox(
                    width: widget.mediaSize.width * 0.025,
                  ),
                  Expanded(
                    child: Container(
                      height: 100,//mediaSize.height * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        widget.businessState.name,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: BuytimeTheme.TextBlack,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16, ///mediaSize.height * 0.0215
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context).employees,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14, ///widget.mediaSize.height * 0.019
                                        color: BuytimeTheme.TextMedium,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Text(
                                        AppLocalizations.of(context).services5,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 14, ///widget.mediaSize.height * 0.019
                                          color: BuytimeTheme.TextMedium,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: widget.mediaSize.height * 0.035,
                                    color: Colors.black.withOpacity(0.6),
                                  )
                                ],
                              )
                            ],
                          ),
                          widget.rowWidget1 != null ||
                              widget.rowWidget2 != null ||
                              widget.rowWidget3 != null
                              ? Row(
                            children: [
                              widget.rowWidget1 != null
                                  ? widget.rowWidget1
                                  : Container(),
                              widget.rowWidget2 != null
                                  ? widget.rowWidget2
                                  : Container(),
                              widget.rowWidget3 != null
                                  ? widget.rowWidget3
                                  : Container(),
                            ],
                          )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }


}
