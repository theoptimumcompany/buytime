import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef OptimumChipListToDispatch = void Function(String);

class OptimumChip extends StatefulWidget {
  OptimumChipListToDispatch optimumChipListToDispatch;
  List<String> chipList;
  String selectedChoices;

  OptimumChip({@required this.chipList, this.selectedChoices, @required this.optimumChipListToDispatch}) {
    this.chipList = chipList;
    this.selectedChoices = selectedChoices == null ? []: selectedChoices;
    this.optimumChipListToDispatch = optimumChipListToDispatch;
  }

  @override
  _OptimumChipState createState() => _OptimumChipState(chipList: chipList, selectedChoices: selectedChoices, optimumChipListToDispatch: optimumChipListToDispatch);
}

class _OptimumChipState extends State<OptimumChip> {
  String selectedChoices;
  OptimumChipListToDispatch optimumChipListToDispatch;
  List<String> chipList;

  _OptimumChipState({this.chipList, this.selectedChoices, this.optimumChipListToDispatch});

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.chipList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices == item? true : false,
          selectedColor: Theme.of(context).accentColor,
          labelStyle: TextStyle(color: selectedChoices == item? Colors.black : Colors.white),
          onSelected: (selected) {
            setState(() {
                selectedChoices = item;
            });
            optimumChipListToDispatch(selectedChoices);
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Container(
            width: SizeConfig.safeBlockHorizontal * 80,
            child: Wrap(
              children: _buildChoiceList(),
            ),
          );
        });
  }
}
