import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/business/optimum_business_card_medium_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Struttura {
  String nome;
  String immagine;
  String comune;

  Struttura(this.nome, this.immagine, this.comune);
}

class UI_U_BusinessList extends StatefulWidget {
  final String title = 'Business List';

  @override
  State<StatefulWidget> createState() => UI_U_BusinessListState();
}

class UI_U_BusinessListState extends State<UI_U_BusinessList> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            onInit: (store) {
              store.state.businessList.businessListState.clear();
              store.dispatch(BusinessListRequest("any", store.state.user.getRole(), 150));
            },
            builder: (context, snapshot) {
              return Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                        child: Text(
                          AppLocalizations.of(context).welcomeToBuytime,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.035,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: StoreConnector<AppState, AppState>(
                              converter: (store) => store.state,
                              builder: (context, snapshot) {
                                List<BusinessState> businessListState = snapshot.businessList.businessListState;

                                return businessListState != null && businessListState.length > 0
                                    ? GridView.count(
                                        crossAxisCount: 1,
                                        childAspectRatio: 3.0,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: List.generate(businessListState.length, (index) {
                                          debugPrint('UI_U_business_list => BUSINESS NAME: ${businessListState[index].name}');
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: OptimumBusinessCardMediumUser(
                                              onBusinessCardTap: (BusinessState businessState) {
                                                StoreProvider.of<AppState>(context).dispatch(new ClickOnBusinessState());
                                                StoreProvider.of<AppState>(context).dispatch(new SetBusiness(businessListState[index]));
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ServiceList(businessListState[index])),
                                                );
                                              },
                                              imageUrl: businessListState[index].profile,
                                              businessState: businessListState[index],
                                              mediaSize: media,
                                            ),
                                          );
                                        }),
                                      )
                                    : SizedBox();
                              }),
                        ),
                      ),
                    ],
                  ));
            });
  }
}
