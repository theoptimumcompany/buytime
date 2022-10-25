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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InviteUser extends StatefulWidget {
  bool hotel;

  InviteUser({this.hotel});

  @override
  State<StatefulWidget> createState() => InviteUserState();
}

class InviteUserState extends State<InviteUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      child:
      ///Invite
      widget.hotel
          ? Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key('business_invite_key'),
              onTap: () {
                debugPrint('INVITE USER Clicked!');

                /*final RenderBox box = context.findRenderObject();
                                                    Share.share(AppLocalizations.of(context).share, subject: 'Test', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/
                StoreProvider.of<AppState>(context).dispatch(BookingListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                //Navigator.push(context, MaterialPageRoute(builder: (context) => BookingList(bookingList: bookingList)));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  height: 70,
                  child: Row(
                    children: [
                      ///QR code Icon
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 15.0),
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      ///Message
                      Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    AppLocalizations.of(context).inviteUser,
                                    style: TextStyle(color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 16, letterSpacing: 0.15),
                                  ),
                                ),
                                Container(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).userJoinQR,
                                      style: TextStyle(color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 15, letterSpacing: 0.25),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),

                      ///Arrow Icon
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
          : Container(),
    );
  }
}
