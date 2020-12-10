import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reblox/reducer/business_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:BuyTime/UI/management/business/UI_C_manage_business.dart';
import 'package:BuyTime/UI/management/category/UI_manage_category.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:BuyTime/reusable/business/optimum_business_card_medium_manager.dart';
import 'package:BuyTime/reusable/business/optimum_business_card_medium_user.dart';
import 'package:BuyTime/UI/user/cart/UI_U_stripe_payment.dart';
import 'package:BuyTime/services/business_service_epic.dart';
import 'package:BuyTime/services/category_snippet_service_epic.dart';
import 'package:BuyTime/UI/user/business/UI_U_business_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';

import '../service/UI_manage_service.dart';

class UI_C_BusinessList extends StatefulWidget {
  final String title = 'Salesman Landing';

  UI_C_BusinessList({this.edited = false, this.created = false});

  bool edited;
  bool created;
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => UI_C_BusinessListState();
}

class UI_C_BusinessListState extends State<UI_C_BusinessList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => openSnackbar());
  }

  void openSnackbar() {
    setState(() {
      if (widget.created) {
        final snackBar = SnackBar(
          backgroundColor: BuytimeTheme.UserPrimary,
          elevation: 5,
          duration: Duration(seconds: 3),
          content: Text(
            'Business Created!',
            style: TextStyle(color: BuytimeTheme.TextWhite),
          ),
        );
        widget._keyScaffold.currentState.showSnackBar(snackBar);
      } else if (widget.edited) {
        final snackBar = SnackBar(
          elevation: 5,
          backgroundColor: BuytimeTheme.UserPrimary,
          duration: Duration(seconds: 3),
          content: Text(
            'Business Edited!',
            style: TextStyle(color: BuytimeTheme.TextWhite),
          ),
        );
        widget._keyScaffold.currentState.showSnackBar(snackBar);
      }
      widget.edited = false;
      widget.created = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return WillPopScope(
        // onWillPop: () async {
        //   FocusScope.of(context).unfocus();
        //   return false;
        // },
        child: Scaffold(
            key: widget._keyScaffold,
            appBar: AppBar(
              title: StoreConnector<AppState, UserState>(
                  converter: (store) => store.state.user,
                  builder: (context, snapshot) {
                    return snapshot.name != null ? Text('Salesman ' + snapshot.name) : Text("");
                  }),
            ),
            drawer: StoreConnector<AppState, UserState>(
                converter: (store) => store.state.user,
                builder: (context, snapshot) {
                  return Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                            accountName: snapshot.name != null ? Text(snapshot.name) : Text(""),
                            accountEmail: Text(snapshot.email),
                            decoration: new BoxDecoration(
                              color: BuytimeTheme.UserPrimary,
                            ),
                            currentAccountPicture: CircleAvatar(
                              radius: 30.0,
                              //  backgroundImage: snapshot.photo == null? null : NetworkImage("${snapshot.photo}"),
                              backgroundColor: Colors.transparent,
                            )),
                        ListTile(
                          leading: Icon(Icons.send),
                          title: Text('Invite an User'),
                          onTap: () {
                            Share.share("https://buytime.page.link/?link=https://buytime.page.link/welcome&apn=com.theoptimumcompany.buytime&isi=1508552491&ibi=com.theoptimumcompany.buytime&ifl=https://beta.itunes.apple.com/v1/app/1508552491");
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.message),
                          title: Text('Test Payment'),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => UI_U_StripePayment()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.change_history),
                          title: Text('Back to User'),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => UI_U_BusinessList()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UI_ManageBusiness(-1)),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: BuytimeTheme.UserPrimary,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(children: <Widget>[
                  Container(
                    height: media.height * 0.9,
                    child: StoreConnector<AppState, AppState>(
                        onInit: (store) => store.dispatch(new BusinessListRequest(store.state.user.uid, store.state.user.getRole())),
                        rebuildOnChange: true,
                        converter: (store) => store.state,
                        builder: (context, snapshot) {
                          List<BusinessState> businessListState = snapshot.businessList.businessListState;
                          return GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: 3.1,
                            children: List.generate(businessListState.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  child: businessListState.length > 0
                                      ? OptimumBusinessCardMediumManager(
                                          onBusinessCardTap: (BusinessState businessState) {},
                                          imageUrl: businessListState[index].profile,
                                          businessState: snapshot.business,
                                          mediaSize: media,
                                          rowWidget1: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    StoreProvider.of<AppState>(context).dispatch(new SetBusiness(snapshot.businessList.businessListState[index]));
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => UI_ManageBusiness(index)),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          rowWidget2: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.category),
                                                  onPressed: () {
                                                    StoreProvider.of<AppState>(context).dispatch(new SetBusiness(snapshot.businessList.businessListState[index]));
                                                    if (StoreProvider.of<AppState>(context).state.categorySnippet.categoryNodeList == null) {
                                                      StoreProvider.of<AppState>(context)
                                                          .dispatch(new CategorySnippetCreateIfNotExists(snapshot.businessList.businessListState[index].id_firestore, context));
                                                    }

                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => UI_ManageCategory()),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          rowWidget3: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.room_service),
                                                  onPressed: () {
                                                    StoreProvider.of<AppState>(context).dispatch(new SetBusiness(snapshot.businessList.businessListState[index]));
                                                    StoreProvider.of<AppState>(context).dispatch(new CategorySnippetRequest());
                                                    StoreProvider.of<AppState>(context).dispatch(new RequestListPipeline());
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => UI_ManageService(false)),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ))
                                      : Center(
                                          child: Text("Nessun elemento"),
                                        ),
                                ),
                              );
                            }),
                          );
                        }),
                  )
                ]),
              ),
            )));
  }
}
