import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    if (widget.image == null && widget.imageUrl == null) {
      return Container(
        child: Text("Foto non inserita."),
      );
    }
    return Container(
      child: GestureDetector(
        onTap: () {
          businessCardTap(widget.businessState);
        },
        child: Row(
          children: [
            widget.image == null
                ? Image.network(
                    version200(widget.imageUrl),
                    height: widget.mediaSize != null
                        ? widget.mediaSize.height * 0.13
                        : 50.0,
                  )
                : widget.image,
            SizedBox(
              width: widget.mediaSize.width * 0.025,
            ),
            Expanded(
              child: Container(
                height: mediaSize.height * 0.13,
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
                                    fontWeight: FontWeight.w500,
                                    fontSize: mediaSize.height * 0.0215,
                                  ),
                                ),
                              ),
                              Text(
                                "4 employees",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: widget.mediaSize.height * 0.019,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  "5 services",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: widget.mediaSize.height * 0.019,
                                      color: Colors.black.withOpacity(0.6)),
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
    );
  }

  String version200(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0) {
      extension =
          imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_200x200" + extension;
    } else {
      result =
          "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }
}
