import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/tab_availability_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/utils/size_config.dart';

import 'package:Buytime/utils/theme/buytime_theme.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnFilePickedCallback = void Function();

class TimeSlot extends StatefulWidget {
  TimeSlot({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => TimeSlotState();
}

class TimeSlotState extends State<TimeSlot> {

  var currentStep = 0;

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
          return Stepper(
            currentStep: this.currentStep,
            steps: [
              Step(
                title: Text("Uno"),
                content: Container(),
                state: currentStep == 0 ? StepState.editing : StepState.indexed,
                isActive: true,
              ),
              Step(
                title: Text("Due"),
                content: Container(),
                state: currentStep == 1 ? StepState.editing : StepState.indexed,
                isActive: true,
              ),
              Step(
                title: Text("Tre"),
                content: Container(),
                state: StepState.complete,
                isActive: true,
              ),
            ],
            type: StepperType.horizontal,
            onStepTapped: (step) {
              setState(() {
                currentStep = step;
              });
            },
            onStepContinue: () {
              setState(() {
                if (currentStep < 2) {
                  if (currentStep == 0) {
                    currentStep = currentStep + 1;
                  } else if (currentStep == 1) {
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
          );
        });
  }
}
