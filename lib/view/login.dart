import 'package:contacts_app/constants.dart';
import 'package:contacts_app/pods/auth.dart';
import 'package:contacts_app/widgets/h_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              SvgPicture.asset("assets/logo.svg", height: 40.sp),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HText(
                  title: "Contacts",
                  fontSize: 15.sp,
                  color: kSecondaryColor.withOpacity(0.8),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              const LoginButton()
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends ConsumerWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var authPod = ref.watch(authPods);
    return Container(
      width: 75.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kFontColor)),
      child: SocialLoginButton(
          backgroundColor: kPrimaryColor,
          textColor: kSecondaryColor,
          borderRadius: 15,
          mode: SocialLoginButtonMode.multi,
          buttonType: SocialLoginButtonType.google,
          onPressed: () async {
            await authPod.googleSignIn(context);
          }),
    );
  }
}
