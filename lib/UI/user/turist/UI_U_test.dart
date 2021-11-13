import 'dart:async';
import 'dart:io';

import 'package:Buytime/UI/user/turist/widget/p_r_card_widget.dart';
import 'package:Buytime/helper/pagination/service_helper.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'RUI_U_service_explorer.dart';

class Test extends StatefulWidget {
  final String title = 'About Us';

  @override
  State<StatefulWidget> createState() => TestState();
}

class TestState extends State<Test> {
  ScrollController popularScoller = ScrollController();
  List<ServiceState> myList = [];
  ServicePagingBloc servicePagingBloc;

  @override
  void initState() {
    super.initState();
    servicePagingBloc = ServicePagingBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      servicePagingBloc.requestServices(context);
    });
    popularScoller.addListener(_scrollListener);
  }

  void _scrollListener() {
    //_currentUserStreamCtrl = StreamController.broadcast();
    if (popularScoller.offset >= popularScoller.position.maxScrollExtent &&
        !popularScoller.position.outOfRange) {
      print("at the end of list");
      servicePagingBloc.requestServices(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    servicePagingBloc.serviceStream.listen((event) {
      debugPrint('EVENT: $event');
    });
    return StreamBuilder<List<ServiceState>>(
        stream: servicePagingBloc.serviceStream,
        builder: (context, AsyncSnapshot<List<ServiceState>> orderSnapshot) {
          //myList.clear();
          if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Row(
                  children: [
                    CircularProgressIndicator()
                  ],
                )
              ],
            );
          }
          myList = orderSnapshot.data;
          debugPrint('MYLIST LENGTH: ${myList.length}');
          myList.forEach((element) {
            debugPrint('SERVICE NAME: ${element.name}');
          });
          return ///List
          Container(
            height: 240,
            width: double.infinity,
            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
            child: CustomScrollView(
                controller: popularScoller,
                shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    //MenuItemModel menuItem = menuItems.elementAt(index);
                    ServiceState service = myList.elementAt(index);
                    return Container(
                      child: PRCardWidget(182, 182, service, false, true, index, 'popular'),
                    );
                  },
                  childCount: myList.length,
                ),
              ),
            ]),
          );
        }
    );
  }
}
