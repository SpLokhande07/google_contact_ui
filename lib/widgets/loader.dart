import 'package:contacts_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:sizer/sizer.dart';

class Loader {
  ProgressDialog? pr;
  Loader();
  showLoader(context, [String? msg]) {
    pr = ProgressDialog(context);
    pr!.style(
        backgroundColor: kPrimaryColor,
        progressTextStyle: TextStyle(height: 3.h),
        progressWidget: const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(
              color: kSecondaryColor,
            )),
        message: msg ?? "Please wait",
        messageTextStyle: TextStyle(color: kFontColor, fontSize: 14.sp));
    pr!.show();
  }

  updateLoader([String? msg]) {
    pr!.update(
        message: msg ?? "Please wait",
        messageTextStyle: TextStyle(color: kFontColor, fontSize: 14.sp));
  }

  hideLoader() {
    if (pr != null) pr!.hide();
  }
}
