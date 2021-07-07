import 'package:Buytime/UI/user/category/UI_U_filter_by_category.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DiscoverCardWidget extends StatefulWidget {

  double width;
  double heigth;
  CategoryState categoryState;
  List<String> categoryListIds;
  bool fromBookingPage;
  DiscoverCardWidget(this.width, this.heigth,this.categoryState, this.fromBookingPage, this.categoryListIds);

  @override
  _DiscoverCardWidgetState createState() => _DiscoverCardWidgetState();
}

class _DiscoverCardWidgetState extends State<DiscoverCardWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  CachedNetworkImage(
      imageUrl: Utils.version200(widget.categoryState.categoryImage),
      imageBuilder: (context, imageProvider) => Container(
        margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.0),
        //width: double.infinity,
        //height: double.infinity,
        width: widget.width, ///SizeConfig.safeBlockVertical * widget.width
        height: widget.heigth, ///SizeConfig.safeBlockVertical * widget.width
        decoration: BoxDecoration(
            color: BuytimeTheme.BackgroundWhite,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            )
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black.withOpacity(.3),
            onTap: (){
              List<ServiceListSnippetState> serviceListSnippetListState = StoreProvider.of<AppState>(context).state.serviceListSnippetListState.serviceListSnippetListState;
              for (var z = 0; z < serviceListSnippetListState.length; z++) {
                  if(widget.categoryState.businessId == serviceListSnippetListState[z].businessId)
                  {
                    StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetRequestResponse(serviceListSnippetListState[z]));
                  }
              }
              widget.fromBookingPage ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: true, categoryState: widget.categoryState, tourist: true, categoryListIds: widget.categoryListIds,))) :
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: false,categoryState: widget.categoryState, tourist: true, categoryListIds: widget.categoryListIds,)));
            },
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Container(
              width: widget.width,
              height: widget.heigth,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.black.withOpacity(.4)
              ),
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 1, bottom: SizeConfig.safeBlockVertical * 1),
                child: Text(
                  widget.categoryState.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: widget.width, ///SizeConfig.safeBlockVertical * widget.width
        height: widget.heigth, ///SizeConfig.safeBlockVertical * widget.width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

