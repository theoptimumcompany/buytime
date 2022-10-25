/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:flutter/material.dart';

enum CheckboxType {
  Parent,
  Child,
}

@immutable
class CustomLabeledCheckbox extends StatelessWidget {
  const CustomLabeledCheckbox({
    @required this.label,
    @required this.value,
    @required this.onChanged,
    this.checkboxType: CheckboxType.Child,
    this.activeColor,
  })  : assert(label != null),
        assert(checkboxType != null),
        assert(
        (checkboxType == CheckboxType.Child && value != null) ||
            checkboxType == CheckboxType.Parent,
        ),
        tristate = checkboxType == CheckboxType.Parent ? true : false;

  final String label;
  final bool value;
  final bool tristate;
  final ValueChanged<bool> onChanged;
  final CheckboxType checkboxType;
  final Color activeColor;

  void _onChanged() {
    if (value != null) {
      onChanged(!value);
    } else {
      onChanged(value);
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return InkWell(
      onTap: _onChanged,
      child: Row(
        children: <Widget>[
          checkboxType == CheckboxType.Parent
              ? SizedBox(width: 0)
              : SizedBox(width: 32),
          SizedBox(
            width: 20,
            child: Checkbox(
              tristate: tristate,
              value: value,
              onChanged: (_) {
                _onChanged();
              },
              activeColor: activeColor ?? themeData.toggleableActiveColor,
            ),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: themeData.textTheme.subtitle1,
          )
        ],
      ),
    );
  }
}