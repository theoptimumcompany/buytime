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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final Future Function() onPressed;
  final String text;

  const LoadingButton({Key key, @required this.onPressed, @required this.text})
      : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (_isLoading || widget.onPressed == null) ? null : _loadFuture,
      child: _isLoading
          ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator())
          : Text(widget.text),
    );
  }

  Future<void> _loadFuture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed();
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }


  }
}
