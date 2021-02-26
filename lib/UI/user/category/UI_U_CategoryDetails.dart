import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryDetails extends StatefulWidget {

  static String route = '/categoryDetails';
  bool fromConfirm;
  CategoryDetails({Key key, this.fromConfirm}) : super(key: key);
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: BuytimeAppbar(
          background: BuytimeTheme.BackgroundCerulean,
          width: media.width,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    tooltip: AppLocalizations.of(context).comeBack,
                    onPressed: () {
                      //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Buytime', //TODO Make it Global
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                        color: BuytimeTheme.TextWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
                  width: double.infinity,
                  color: BuytimeTheme.DividerGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}