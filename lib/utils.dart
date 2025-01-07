import 'package:flutter/material.dart';

class Utils {
  static showMsg(
      {required String content,
      required BuildContext context,
      Color? snackColor}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: snackColor,
    ));
  }
}
