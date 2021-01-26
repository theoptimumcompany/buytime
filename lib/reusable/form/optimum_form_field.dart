import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef OnSaveOrChangedCallback = void Function(String value);

class OptimumFormField extends StatefulWidget {
  int minLength;
  bool validateEmail = false;
  InputDecoration inputDecoration;
  TextInputType textInputType  = TextInputType.text;
  final GlobalKey<FormState> globalFieldKey;
  String val;
  String typeOfValidate;
  String field;
  int indexBusiness;
  OnSaveOrChangedCallback onSaveOrChangedCallback;
  String initialFieldValue;

  OptimumFormField({
    this.field,
    this.minLength = 2,
    this.validateEmail = false,
    this.inputDecoration,
    this.textInputType,
    this.globalFieldKey,
    this.typeOfValidate,
    this.indexBusiness,
    this.onSaveOrChangedCallback,
    this.initialFieldValue
  });

  @override
  State<StatefulWidget> createState() => OptimumFormFieldState(onSaveOrChangedCallback: onSaveOrChangedCallback, initialFieldValue: initialFieldValue, minLength: minLength);
}

class OptimumFormFieldState extends State<OptimumFormField> {
  FocusNode focusNode = FocusNode();
  bool _autoValidate = false;
  OnSaveOrChangedCallback onSaveOrChangedCallback;
  String initialFieldValue;
  int minLength;

  OptimumFormFieldState({this.onSaveOrChangedCallback, this.initialFieldValue, this.minLength});

  @override
  void initState() {
    focusNode.addListener(() {
      // TextField lost focus
      if (!focusNode.hasFocus) {
        _validateInputs();
        focusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String validate(String value) {
    if (value.length < minLength) {
        return 'Name must be more than ' + minLength.toString() + ' characters';
    }
    if (widget.typeOfValidate == "email") {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Enter Valid Email';
      }
    }
    return null;
  }

  void _validateInputs() {
    if (widget.globalFieldKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      widget.globalFieldKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BusinessState>(
      converter: (store) => store.state.business,
      builder: (context, snapshot) {
        return Form(
            key: widget.globalFieldKey,
            autovalidate: _autoValidate,
            child: TextFormField(
              focusNode: focusNode,
              initialValue: widget.initialFieldValue,
              onChanged: (value) {
                onSaveOrChangedCallback(value);
              },
              keyboardType: widget.textInputType,
              validator: validate,
              decoration: widget.inputDecoration,
              onSaved: (value) {
                onSaveOrChangedCallback(value);
              },
            ));
      },
    );
  }
}
