import 'package:flutter/material.dart';

abstract class Indicators {
  //couldve set setters and made the variables private which was before but i feel its of no use
  late BuildContext indContext;
  bool isDisplayed = false;

  show(BuildContext context, {required String text}) {}
  dismiss() {
    if (isDisplayed) {
      Navigator.pop(indContext);
      //this ensures one time use and since its the same instance
      //it needs to be reset after each use
      isDisplayed = false;
    }
  }
}
