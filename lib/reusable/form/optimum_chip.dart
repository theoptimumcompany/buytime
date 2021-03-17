import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef OptimumChipListToDispatch = void Function(List<GenericState>);

class OptimumChip extends StatefulWidget {
  OptimumChipListToDispatch optimumChipListToDispatch;
  List<GenericState> chipList;
  List<GenericState> selectedChoices;

  OptimumChip({@required this.chipList, this.selectedChoices, @required this.optimumChipListToDispatch}) {
    this.chipList = chipList;
    this.selectedChoices = selectedChoices == null ? []: selectedChoices;
    this.optimumChipListToDispatch = optimumChipListToDispatch;
  }

  @override
  _OptimumChipState createState() => _OptimumChipState(chipList: chipList, selectedChoices: selectedChoices, optimumChipListToDispatch: optimumChipListToDispatch);
}

class _OptimumChipState extends State<OptimumChip> {
  List<GenericState> selectedChoices;
  OptimumChipListToDispatch optimumChipListToDispatch;
  List<GenericState> chipList;

  _OptimumChipState({this.chipList, this.selectedChoices, this.optimumChipListToDispatch});

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.chipList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.name),
          selected: selectedChoices.any((element) => element.name == item.name),
          selectedColor: Theme.of(context).accentColor,
          labelStyle: TextStyle(color: selectedChoices.any((element) => element.name == item.name) ? Colors.black : Colors.white),
          onSelected: (selected) {

            setState(() {
              if (selectedChoices.any((element) => element.name == item.name)) {
                selectedChoices.removeWhere((element) => element.name == item.name);
              } else {
                selectedChoices.add(item);
              }
            });

            selectedChoices.forEach((element) {
              print(element.name);
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
          return Wrap(
            children: _buildChoiceList(),
          );
        });
  }
}
