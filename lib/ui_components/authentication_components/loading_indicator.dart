import 'package:flutter/material.dart';
import 'package:notes_app/ui_components/authentication_components/indicator.dart';
import 'package:notes_app/constants/style_constants.dart';

class LoadingIndicator extends Indicators {
  static final LoadingIndicator _singleton = LoadingIndicator._();

  LoadingIndicator._();

  factory LoadingIndicator() {
    return _singleton;
  }
  @override
  show(BuildContext context, {required String? text}) {
    if (isDisplayed) {
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          indContext = context;
          isDisplayed = true;
          //will popscope is here to make unpobbable unless the dismiss function is called
          //or the back button is pressed
          return WillPopScope(
              child: const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: Constants.yellow,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Loading....",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontFamily: 'lufga',
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }
}
