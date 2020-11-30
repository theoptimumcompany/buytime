import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
typedef OptimumDropDownToDispatch = void Function(ObjectState);

class OptimumDropdown extends StatefulWidget {
   OptimumDropDownToDispatch optimumDropdownToDispatch;
   dynamic value;
   List<DropdownMenuItem<ObjectState>> items;
   List<ObjectState> list;
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
  ObjectState value;
  List<DropdownMenuItem<ObjectState>> items;
  List<ObjectState> list;

  _OptimumDropdownState({this.value, this.items, this.list, this.optimumDropdownToDispatch});

  List<DropdownMenuItem<ObjectState>> buildDropActions(List listItems) {
    List<DropdownMenuItem<ObjectState>> items = List();
    for (ObjectState listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
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
            child: DropdownButtonFormField<ObjectState>(
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
