import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_availabile_time.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_calendar_availability.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_length.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_price.dart';
import 'package:Buytime/reblox/model/app_state.dart';
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
  var currentStep = 0;
  bool editServiceRequest = false;

  @override
  void initState() {
    super.initState();
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
          currentStep: this.currentStep,
          steps: [
            Step(
              title: Text("Calendar Availability"),
              content: CalendarAvailability(media: media),
              state: currentStep == 0 ? StepState.editing : StepState.indexed,
              isActive: true,
            ),
            Step(
              title: Text("Avilability"),
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
                          currentStep < 3? "NEXT" : "SAVE", //todo: lang
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
                currentStep = 0;
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
        ),
      ],
    );
  }

  List<Widget> getSteppers(Size media) {
    List<Widget> listOfSteppers = [];
    listOfSteppers.add(singleStepper(media));
    return listOfSteppers;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                                  print("Edit slot");
                                }),
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: getSteppers(media),
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
