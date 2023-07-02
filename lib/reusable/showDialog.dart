import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void showAlertDialog(
    BuildContext context, String title, String content, String type) {
  final Map<String, QuickAlertType> typeMap = {
    'success': QuickAlertType.success,
    'info': QuickAlertType.info,
    'warning': QuickAlertType.warning,
    'error': QuickAlertType.error,
  };
  QuickAlert.show(
    context: context,
    type: typeMap[type] ?? QuickAlertType.info,
    title: title,
    text: content,
    confirmBtnColor: const Color(0xFF8B5FBF),
  );
}
