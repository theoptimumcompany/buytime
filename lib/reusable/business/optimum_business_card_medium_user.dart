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

import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OptimumBusinessCardMediumUserCallback = void Function(BusinessState);

class OptimumBusinessCardMediumUser extends StatefulWidget {
  OptimumBusinessCardMediumUserCallback onBusinessCardTap;
  String imageUrl;
  Image image;
  BusinessState businessState;
  Widget rowWidget1;
  Widget rowWidget2;
  Widget rowWidget3;
  Size mediaSize;

  OptimumBusinessCardMediumUser(
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
  _OptimumBusinessCardMediumUserState createState() =>
      _OptimumBusinessCardMediumUserState(
          image: image,
          imageUrl: imageUrl,
          businessState: businessState,
          businessCardTap: onBusinessCardTap,
          rowWidget1: rowWidget1,
          rowWidget2: rowWidget2,
          rowWidget3: rowWidget3,
          mediaSize: mediaSize);
}

class _OptimumBusinessCardMediumUserState
    extends State<OptimumBusinessCardMediumUser> {
  OptimumBusinessCardMediumUserCallback businessCardTap;
  String imageUrl;
  Image image;
  BusinessState businessState;
  Widget rowWidget1;
  Widget rowWidget2;
  Widget rowWidget3;
  Size mediaSize;

  _OptimumBusinessCardMediumUserState(
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
        child: Text(AppLocalizations.of(context).photoNotInserted),
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
                    Utils.version200(widget.imageUrl),
                    height: widget.mediaSize != null
                        ? widget.mediaSize.height * 0.16
                        : 50.0,
                  )
                : widget.image,
            SizedBox(
              width: widget.mediaSize.width * 0.045,
            ),
            Expanded(
              child: Container(
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
                                    fontWeight: FontWeight.w700,
                                    fontSize: mediaSize.height * 0.024,
                                  ),
                                ),
                              ),
                              Text(
                                widget.businessState.street +
                                    ", " +
                                    widget.businessState.street_number,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: widget.mediaSize.height * 0.021,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              Text(
                                widget.businessState.municipality,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: widget.mediaSize.height * 0.021,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: widget.mediaSize.height * 0.045,
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

}