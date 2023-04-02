import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

const Color kPrimaryColor = Colors.black54;
const Color kSecondaryColor = Colors.blueAccent;
const Color kFontColor = Colors.white70;
const Color kHintColor = Colors.white38;

///collections
const String colContact = "contacts";

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kSecondaryColor,
      textColor: kFontColor,
      fontSize: 12.sp);
}
