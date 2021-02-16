import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class UI_M_ManageBusiness extends StatefulWidget {
  UI_M_ManageBusiness(int indexBusiness) {
    this.indexBusiness = indexBusiness;
  }

  int indexBusiness;

  @override
  State<StatefulWidget> createState() => UI_M_ManageBusinessState();
}

class UI_M_ManageBusinessState extends State<UI_M_ManageBusiness> {
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
          appBar: BuytimeAppbar(
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
                widget.indexBusiness == -1 ? AppLocalizations.of(context).businessCreation : AppLocalizations.of(context).businessEdit,
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
          body: widget.indexBusiness == -1 ? UI_M_CreateBusiness() : UI_M_EditBusiness()),
    );
  }
}
