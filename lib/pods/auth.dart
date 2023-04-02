import 'package:contacts_app/splash_screen.dart';
import 'package:contacts_app/view/login.dart';
import 'package:contacts_app/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

var authPods = ChangeNotifierProvider((ref) => AuthPod(ref));

class AuthPod extends ChangeNotifier {
  Ref ref;
  AuthPod(this.ref);
  Loader loader = Loader();
  googleSignIn(context) async {
    try {
      loader.showLoader(context);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        loader.hideLoader();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false);
      });
    } catch (e) {
      loader.hideLoader();
    }
  }

  logout(context) async {
    loader.showLoader(context);
    await FirebaseAuth.instance.signOut().then((value) {
      loader.hideLoader();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    });
  }
}
