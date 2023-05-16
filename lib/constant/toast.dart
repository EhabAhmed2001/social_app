import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

  void toastShown({
    required String text,
    required ToastColor state,
})=>
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: chooseToastColor(state),
          textColor: Colors.white,
          fontSize: 16.0
      );

  enum ToastColor { success, error, warning }

  Color chooseToastColor(ToastColor state) {
  Color color;
  switch (state) {
    case ToastColor.success:
      color = Colors.green;
      break;
    case ToastColor.error:
      color = Colors.red;
      break;
    case ToastColor.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

