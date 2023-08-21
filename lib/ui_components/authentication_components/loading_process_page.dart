import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'error_indicator.dart';
import 'loading_indicator.dart';
import 'package:notes_app/models/error_mapping.dart';
import 'package:notes_app/main.dart';

//this needs to be called and not built not extending neither stateless or stateful since i want them to appear
// in the same page
//This first implementation is a class and being called as an instance with a sign in and sign up fucntion
//later iterations would probably be better or the base is bad logic maybe.

class LoadingPage {
  ErrorIndicator errorIndicator = ErrorIndicator();
  LoadingIndicator loadingIndicator = LoadingIndicator();
  LoadingPage();

  //assigning future void to enable awaiting the method ipresume if i dont it wouldnt be waited as tried before
  //or maybe it is some sort of mistake on my hand
  Future<void> signIn(Future<void> func, BuildContext context) async {
    loadingIndicator.show(context, text: 'Loading....');
    try {
      //single point of failure so if the rest runs then we successfuly finished this block
      //first iteration was flags but it turns out to of no need
      await func;
      loadingIndicator.dismiss();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          (Route<dynamic> predicate) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      loadingIndicator.dismiss();
      //using the code to get my custom error messages what is easier is to get Firebase error message right away using e.message
      WidgetsBinding.instance.addPostFrameCallback((_) async =>
          await errorIndicator.show(context,
              text: ExceptionMapping.exceptionErrorMessages[
                  ExceptionMapping.signInExceptionMapper[e.code]]!));
    }
  }

//this is 90% useless with a simple bool or using the default error message its completely redundant but its here why not
  Future<void> signUp(Future<void> func, BuildContext context) async {
    loadingIndicator.show(context, text: 'Loading....');
    try {
      await func;

      if (context.mounted) {
        loadingIndicator.dismiss();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          (Route<dynamic> predicate) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      loadingIndicator.dismiss();
      //using the code to get my custom error messages what is easier is to get Firebase error message right away using e.message
      WidgetsBinding.instance.addPostFrameCallback((_) async =>
          await errorIndicator.show(context,
              text: ExceptionMapping.exceptionErrorMessages[
                  ExceptionMapping.signUpExceptionMapper[e.code]]!));
    }
  }
}
