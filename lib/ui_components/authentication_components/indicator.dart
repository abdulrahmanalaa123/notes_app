import 'package:flutter/material.dart';

abstract class Indicators {
  //couldve set setters and made the variables private which was before but i feel its of no use
  //indContext is used to transfer the current context to the disimiss function
  late BuildContext indContext;
  //checking if an instance is already displayed or not of the indicator
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
