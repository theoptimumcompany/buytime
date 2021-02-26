import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_availabile_time.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_calendar_availability.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_length.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_price.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
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
  int currentStep = 0;
  bool rippleLoading = false;
  int numberOfInterval = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
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
                              onPressed: () => Navigator.pop(context),
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
                          SizedBox(
                            width: 30.0,
                          ),
                        ],
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Stepper(
                                  physics: const NeverScrollableScrollPhysics(),
                                  currentStep: currentStep,
                                  steps: [
                                    Step(
                                      title: Text("Calendar Availability"),
                                      content: CalendarAvailability(media: media),
                                      state: currentStep == 0 ? StepState.editing : StepState.indexed,
                                      isActive: true,
                                    ),
                                    Step(
                                      title: Text("Availability"),
                                      content: StepAvailableTime(media: media),
                                      state: currentStep == 1 ? StepState.editing : StepState.indexed,
                                      isActive: true,
                                    ),
                                    Step(
                                      title: Text("Length"),
                                      content: StepLength(media: media),
                                      state: currentStep == 2 ? StepState.editing : StepState.indexed,
                                      //state: StepState.complete,
                                      isActive: true,
                                    ),
                                    Step(
                                      title: Text("Price"),
                                      content: StepPrice(media: media),
                                      state: currentStep == 3 ? StepState.editing : StepState.indexed,
                                      isActive: true,
                                    ),
                                  ],
                                  type: StepperType.vertical,
                                  onStepTapped: (step) {
                                    setState(() {
                                      print("Step " + step.toString());
                                      currentStep = step;
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
                                                  currentStep < 3 ? "NEXT" : "SAVE", //todo: lang
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
                                    setState(() {
                                      if (currentStep < 3) {
                                        if (currentStep == 0) {
                                          currentStep = currentStep + 1;
                                        } else if (currentStep == 1) {
                                          currentStep = currentStep + 1;
                                        } else if (currentStep == 2) {
                                          currentStep = currentStep + 1;
                                        }
                                      } else {
                                        ///TODO: Validazione
                                        ///Aggiungo uno slot alla lista del service
                                        StoreProvider.of<AppState>(context).dispatch(AddServiceSlot(snapshot.serviceSlot));
                                       // Navigator.pop(context);
                                      }
                                    });
                                  },
                                  onStepCancel: () {
                                    setState(() {
                                      if (currentStep > 0) {
                                        currentStep = currentStep - 1;
                                      } else {
                                        currentStep = 0;
                                      }
                                    });
                                  },
                                )),
                          ),
                        ),
                      )),
                ),
              ),

              ///Ripple Effect
              rippleLoading
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
