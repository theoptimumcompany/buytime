import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/snippet/generic.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
typedef OptimumDropDownToDispatch = void Function(GenericState);

class OptimumDropdown extends StatefulWidget {
   OptimumDropDownToDispatch optimumDropdownToDispatch;
   dynamic value;
   List<DropdownMenuItem<GenericState>> items;
   List<GenericState> list;
   OptimumDropdown({@required this.value, @required this.items, @required this.list, @required this.optimumDropdownToDispatch}){
    this.value = value;
    this.items = items;
    this.list = list;
    this.optimumDropdownToDispatch = optimumDropdownToDispatch;
  }

  @override
  _OptimumDropdownState createState() => _OptimumDropdownState(value: value, items: items, list: list, optimumDropdownToDispatch: optimumDropdownToDispatch);
}

class _OptimumDropdownState extends State<OptimumDropdown> {

  OptimumDropDownToDispatch optimumDropdownToDispatch;
  GenericState value;
  List<DropdownMenuItem<GenericState>> items;
  List<GenericState> list;

  _OptimumDropdownState({this.value, this.items, this.list, this.optimumDropdownToDispatch});

  List<DropdownMenuItem<GenericState>> buildDropActions(List listItems) {
    List<DropdownMenuItem<GenericState>> items = List();
    for (GenericState listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.content),
          value: listItem,
        ),
      );
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    widget.items = buildDropActions(widget.list);
    widget.value = (widget.value != null && widget.value != '')? widget.value :  widget.items[0].value;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return DropdownButtonHideUnderline(
            child: DropdownButtonFormField<GenericState>(
                value: widget.value,
                items: widget.items,
                decoration: InputDecoration(labelText: '', enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                onChanged: (value) {
                  setState(() {
                    widget.value = value;
                    optimumDropdownToDispatch(value);
                  });
                }),
          );
        });
  }
}
