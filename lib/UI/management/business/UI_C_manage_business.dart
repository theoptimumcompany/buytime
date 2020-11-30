import 'package:BuyTime/UI/management/business/UI_M_business.dart';
import 'package:BuyTime/UI/management/business/UI_M_business_list.dart';
import 'package:BuyTime/UI/management/old_design/UI_M_Tabs.dart';
import 'package:BuyTime/UI/management/business/UI_C_create_business.dart';
import 'package:BuyTime/UI/management/business/UI_C_edit_business.dart';
import 'package:BuyTime/UI/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/business/UI_U_business_list.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:BuyTime/reusable/appbar/user_buytime_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'UI_C_business_list.dart';

class UI_ManageBusiness extends StatefulWidget {
  UI_ManageBusiness(int indexBusiness) {
    this.indexBusiness = indexBusiness;
  }

  int indexBusiness;

  @override
  State<StatefulWidget> createState() => UI_ManageBusinessState();
}

class UI_ManageBusinessState extends State<UI_ManageBusiness> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UI_M_Business()),
        );
        return false;
      },
      child: Scaffold(
          appBar: BuyTimeAppbarManager(
            width: media.width,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite, size: media.width * 0.1),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          widget.indexBusiness == -1 ? UI_M_BusinessList() : UI_M_Business()),
                ),
              ),
              Text(
                widget.indexBusiness == -1 ? "Creazione Business" : "Modifica Business",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: media.height * 0.035,
                  color: BuytimeTheme.TextWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 40.0,
              )
            ],
          ),
          body: widget.indexBusiness == -1 ? UI_CreateBusiness() : UI_EditBusiness()),
    );
  }
}
