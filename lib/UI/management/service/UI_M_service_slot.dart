import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_availabile_time.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_calendar_availability.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_length.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_price.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class UI_M_ServiceSlot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_ServiceSlotState();
}

class UI_M_ServiceSlotState extends State<UI_M_ServiceSlot> {
  List<int> currentStep = [0]; //todo: deve essere una lista in base al numero di totale step
  bool editServiceRequest = false;
  List<Widget> listOfSteppers = [];
  int indexStepper = 0;
  bool caseZero = true;
  List<Widget> list;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> getTabs(Size media) {
     list = [];
    list.add(singleStepper(media));
    return list;
  }

  Widget singleStepper(Size media) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: Row(
            children: [
              Text(
                //(i + 1).toString() + ". Available time",
                "1. Available time",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: media.height * 0.018,
                  color: BuytimeTheme.TextBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Stepper(
          physics: const NeverScrollableScrollPhysics(),
          currentStep: currentStep[indexStepper],
          steps: [
            Step(
              title: Text("Calendar Availability"),
              content: CalendarAvailability(media: media),
              state: currentStep[indexStepper] == 0 ? StepState.editing : StepState.indexed,
              isActive: true,
            ),
            Step(
              title: Text("Avilability"),
              content: StepAvailableTime(media: media),
              state: currentStep[indexStepper] == 1 ? StepState.editing : StepState.indexed,
              isActive: true,
            ),
            Step(
              title: Text("Length"),
              content: StepLength(media: media),
              state: currentStep[indexStepper] == 2 ? StepState.editing : StepState.indexed,
              //state: StepState.complete,
              isActive: true,
            ),
            Step(
              title: Text("Price"),
              content: StepPrice(media: media),
              state: currentStep[indexStepper] == 3 ? StepState.editing : StepState.indexed,
              isActive: true,
            ),
          ],
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              print("Step " + step.toString());
              currentStep[indexStepper] = step;
            });
          },
          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Container(
                    width: media.width * 0.50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: BuytimeTheme.ManagerPrimary,
                      ),
                      onPressed: onStepContinue,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          currentStep[indexStepper] < 3 ? "NEXT" : "SAVE", //todo: lang
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.023,
                            color: BuytimeTheme.TextWhite,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          onStepContinue: () {
            print("index step " + indexStepper.toString());
            print("Current step " + currentStep[indexStepper].toString());
            setState(() {
              if (currentStep[indexStepper] < 3) {
                if (currentStep[indexStepper] == 0) {
                  currentStep[indexStepper] = currentStep[indexStepper] + 1;
                } else if (currentStep[indexStepper] == 1) {
                  currentStep[indexStepper] = currentStep[indexStepper] + 1;
                } else if (currentStep[indexStepper] == 2) {
                  currentStep[indexStepper] = currentStep[indexStepper] + 1;
                }
              } else {
                currentStep[indexStepper] = 0;
              }
              print("index step2 " + indexStepper.toString());
              print("Current step2 " + currentStep[indexStepper].toString());
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep[indexStepper] > 0) {
                currentStep[indexStepper] = currentStep[indexStepper] - 1;
              } else {
                currentStep[indexStepper] = 0;
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    indexStepper = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.actualSlotIndex;
    var media = MediaQuery.of(context).size;
    if (caseZero) {
      caseZero = false;
      listOfSteppers.add(singleStepper(media));
    }
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        //    onInit: (store) => store.dispatch(CategoryTreeRequest()),
        builder: (context, snapshot) {
          return Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Scaffold(
                      appBar: BuytimeAppbar(
                        width: media.width,
                        children: [
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.09),
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Slot Management",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: media.height * 0.028,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                                icon: Icon(Icons.check, color: Colors.white, size: media.width * 0.07),
                                onPressed: () {
                                  print("Salva nuovo Servizio");
                                  StoreProvider.of<AppState>(context).dispatch(CreateService(snapshot.serviceState));
                                }),
                          ),
                        ],
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          print("ADD STEP");

                          setState(() {
                            List<GlobalKey<FormState>>  listGlobalPrice = snapshot.serviceState.serviceSlot.formSlotPriceKey;
                            listGlobalPrice.add(GlobalKey<FormState>());
                            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotFormSlotPriceKey(listGlobalPrice));

                            List<GlobalKey<FormState>>  listGlobalTime = snapshot.serviceState.serviceSlot.formSlotTimeKey;
                            listGlobalTime.add(GlobalKey<FormState>());
                            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotFormSlotTimeKey(listGlobalTime));

                            List<GlobalKey<FormState>>  listGlobalLength = snapshot.serviceState.serviceSlot.formSlotLengthKey;
                            listGlobalLength.add(GlobalKey<FormState>());
                            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotFormSlotLengthKey(listGlobalLength));

                            currentStep.add(0);
                            indexStepper = indexStepper + 1;
                            print("Lunghezza Steppers " + listOfSteppers.length.toString());
                            listOfSteppers.add(singleStepper(media));
                            print("Lunghezza Steppers dopo " + listOfSteppers.length.toString());
                            getTabs(media);
                          });

                          // indexStepper = indexStepper + 1;
                        },
                        child: Icon(Icons.add),
                        backgroundColor: BuytimeTheme.Secondary,
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: Column(
                                children: [
                                  Column(mainAxisSize: MainAxisSize.min, children: getTabs(media)),

                                  ///Divider under n stepper
                                  Container(
                                    child: Divider(
                                      indent: 0.0,
                                      color: BuytimeTheme.DividerGrey,
                                      thickness: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),

              ///Ripple Effect
              editServiceRequest
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                            height: SizeConfig.safeBlockVertical * 100,
                            decoration: BoxDecoration(
                              color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: SpinKitRipple(
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )
                  : Container()
            ],
          );
        });
  }
}
