import 'package:Buytime/UI/user/booking/RUI_U_notifications.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RNotificationBell extends StatelessWidget {
  const RNotificationBell({
    Key key,
    @required this.orderList,
    @required this.userId,
    this.tourist
  }) : super(key: key);

  final List<OrderState> orderList;
  final String userId;
  final bool tourist;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('user').doc(userId).collection('userNotification').doc('userNotificationDoc').snapshots(includeMetadataChanges: true),
        builder: (context, AsyncSnapshot<DocumentSnapshot> userNotificationSnapshot) {
          if(userNotificationSnapshot.hasError)
            return Container();
          return Container(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        color: BuytimeTheme.TextBlack,
                        size: 25.0,
                      ),
                      onPressed: () async{
                        if(userNotificationSnapshot.data.get('hasNotification')){
                          FirebaseFirestore.instance.collection('user').doc(userId).collection('userNotification').doc('userNotificationDoc').update(
                              {'hasNotification': false}
                          );
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RNotifications(orderStateList: orderList, tourist: tourist,)));
                      },
                    ),
                  ),
                ),
                userNotificationSnapshot.data != null && userNotificationSnapshot.data.get('hasNotification') ?
                Positioned.fill(
                  bottom: 20,
                  left: 15,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: BuytimeTheme.AccentRed,
                          borderRadius: BorderRadius.all(Radius.circular(7.5))
                      ),
                    ),
                  ),
                ) : Container(),
              ],
            ),
          );
        }
    );
  }
}