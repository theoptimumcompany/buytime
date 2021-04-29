import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OptimumServiceCardMediumCallback = void Function(ServiceState);

class OptimumServiceCardMedium extends StatefulWidget {
  OptimumServiceCardMediumCallback onServiceCardTap;
  String imageUrl;
  Image image;
  ServiceState serviceState;
  Size mediaSize;
  Widget rowWidget1;
  Widget rowWidget2;
  Widget rowWidget3;
  Widget rightWidget1;
  bool greyScale;

  OptimumServiceCardMedium(
      {this.image, this.imageUrl, this.serviceState, this.onServiceCardTap, this.rowWidget1, this.rowWidget2, this.rowWidget3, this.rightWidget1, @required this.mediaSize, this.greyScale}) {
    this.image = image;
    this.imageUrl = imageUrl;
    this.serviceState = serviceState;
    this.onServiceCardTap = onServiceCardTap;
    this.rowWidget1 = rowWidget1;
    this.rowWidget2 = rowWidget2;
    this.rowWidget3 = rowWidget3;
    this.rightWidget1 = rightWidget1;
    this.mediaSize = mediaSize;
    this.greyScale = greyScale == true ? greyScale : false;
  }

  @override
  _OptimumServiceCardMediumState createState() => _OptimumServiceCardMediumState(
      image: image,
      imageUrl: imageUrl,
      serviceState: serviceState,
      onServiceCardTap: onServiceCardTap,
      rowWidget1: rowWidget1,
      rowWidget2: rowWidget2,
      rowWidget3: rowWidget3,
      rightWidget1: rightWidget1,
      mediaSize: mediaSize,
      greyScale: greyScale);
}

class _OptimumServiceCardMediumState extends State<OptimumServiceCardMedium> {
  OptimumServiceCardMediumCallback onServiceCardTap;
  String imageUrl;
  Image image;
  ServiceState serviceState;
  Widget rowWidget1;
  Widget rowWidget2;
  Widget rowWidget3;
  Widget rightWidget1;
  Size mediaSize;
  bool greyScale;

  _OptimumServiceCardMediumState(
      {this.image, this.imageUrl, this.serviceState, this.onServiceCardTap, this.rowWidget1, this.rowWidget2, this.rowWidget3, this.rightWidget1, this.mediaSize, this.greyScale});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    if (widget.image == null && widget.imageUrl == null) {
      return Container(
        child: Text(AppLocalizations.of(context).photoNotInserted),
      );
    }
    return Container(
      child: GestureDetector(
        onTap: () {
          onServiceCardTap(serviceState);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServiceDetails(serviceState: serviceState, tourist: false,)),
          );
        },
        child: Row(
          children: [
            widget.greyScale
                ? ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.srcOver),
                    child: widget.image == null
                        ? Image.network(
                            version200(widget.imageUrl),
                            height: mediaSize != null ? mediaSize.height * 0.15 : 50.0,
                          )
                        : image,
                  )
                : widget.image == null
                    ? Image.network(
                        version200(widget.imageUrl),
                        height: mediaSize != null ? mediaSize.height * 0.15 : 50.0,
                      )
                    : widget.image,
            SizedBox(
              width: mediaSize.width * 0.045,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
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
                              Text(
                                widget.serviceState.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: mediaSize.height * 0.024, color: greyScale ? Colors.grey.withOpacity(0.6) : Colors.black.withOpacity(0.6)),
                              ),
                              Text(
                                widget.serviceState.description,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: mediaSize.height * 0.021, color: greyScale ? Colors.grey.withOpacity(0.6) : Colors.black.withOpacity(0.6)),
                              ),
                              Row(
                                children: [
                                  widget.greyScale
                                      ? Text(
                                          '${AppLocalizations.of(context).euroSpace} ' + widget.serviceState.price.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              TextStyle(fontWeight: FontWeight.w700, fontSize: mediaSize.height * 0.021, color: Colors.grey.withOpacity(0.6), decoration: TextDecoration.lineThrough),
                                        )
                                      : Text(
                                      '${AppLocalizations.of(context).euroSpace} ' + widget.serviceState.price.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: mediaSize.height * 0.021,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                  widget.greyScale
                                      ? Text(
                                          AppLocalizations.of(context).unavailable,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: mediaSize.height * 0.021,
                                            color: Colors.grey.withOpacity(0.6),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            ],
                          ),
                        ),
                        widget.rightWidget1 != null ? widget.rightWidget1 : SizedBox()
                      ],
                    ),
                    widget.rowWidget1 != null || widget.rowWidget2 != null || widget.rowWidget3 != null
                        ? Row(
                            children: [
                              widget.rowWidget1 != null ? widget.rowWidget1 : Container(),
                              widget.rowWidget2 != null ? widget.rowWidget2 : Container(),
                              widget.rowWidget3 != null ? widget.rowWidget3 : Container()
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String version200(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_200x200" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }
}
