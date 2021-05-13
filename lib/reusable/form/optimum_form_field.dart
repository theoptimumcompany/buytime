import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnSaveOrChangedCallback = void Function(String value);

class OptimumFormField extends StatefulWidget {
  int minLength;
  bool validateEmail = false;
  bool required = false;
  //InputDecoration inputDecoration;
  TextInputType textInputType  = TextInputType.text;
  final GlobalKey<FormState> globalFieldKey;
  String val;
  String typeOfValidate;
  String field;
  int indexBusiness;
  OnSaveOrChangedCallback onSaveOrChangedCallback;
  String initialFieldValue;
  TextEditingController controller;
  String label;

  OptimumFormField({
    this.field,
    this.minLength = 2,
    this.validateEmail = false,
    this.required = false,
    this.label,
    this.textInputType,
    this.globalFieldKey,
    this.typeOfValidate,
    this.indexBusiness,
    this.onSaveOrChangedCallback,
    this.initialFieldValue,
    this.controller
  });

  @override
  State<StatefulWidget> createState() => OptimumFormFieldState(onSaveOrChangedCallback: onSaveOrChangedCallback, controller: controller, minLength: minLength);
}

class OptimumFormFieldState extends State<OptimumFormField> {
  FocusNode focusNode = FocusNode();
  bool _autoValidate = false;
  OnSaveOrChangedCallback onSaveOrChangedCallback;
  TextEditingController controller;
  int minLength;

  OptimumFormFieldState({this.onSaveOrChangedCallback, this.controller, this.minLength});

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
    if(widget.required && value.isEmpty) {
      return '~ ' + AppLocalizations.of(context).required;
    }
    /*if (value.length < minLength) {
        return '${AppLocalizations.of(context).nameMustBeMore} '+ minLength.toString() + ' ${AppLocalizations.of(context).characters}';
    }*/
    if (widget.typeOfValidate == "email") {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return AppLocalizations.of(context).enterValidEmail;
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
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Form(
              key: widget.globalFieldKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                focusNode: focusNode,
                controller: widget.controller,
                //initialValue: widget.initialFieldValue,
                onChanged: (value) {
                  onSaveOrChangedCallback(value);
                },
                keyboardType: widget.textInputType,
                validator: validate,
                decoration: InputDecoration(
                  //helperText: widget.required ? '~ ' + AppLocalizations.of(context).required : null,
                  labelText: widget.label,
                  helperStyle: TextStyle(
                      color: BuytimeTheme.AccentRed
                  ),
                  errorStyle: TextStyle(
                    color: BuytimeTheme.AccentRed
                  ),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),),
                onSaved: (value) {
                  onSaveOrChangedCallback(value);
                },
              )),
        );
      },
    );
  }
}
