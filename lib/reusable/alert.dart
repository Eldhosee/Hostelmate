import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

Future<bool> showConfirmationDialog(
    BuildContext context, String title, String message) {
  Completer<bool> completer = Completer<bool>();

  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    text: message,
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Colors.green,
    onConfirmBtnTap: () {
      Navigator.of(context).pop();
      completer.complete(true);
    },
    onCancelBtnTap: () {
      Navigator.of(context).pop();
      completer.complete(false);
    },
  );

  return completer.future;
}
