import 'package:flutter/material.dart';
import 'package:notes_app/ui_components/authentication_components/indicator.dart';
import 'package:notes_app/constants/style_constants.dart';

class ErrorIndicator extends Indicators {
  static final ErrorIndicator _errorInstance = ErrorIndicator._();

  ErrorIndicator._();

  factory ErrorIndicator() {
    return _errorInstance;
  }

  @override
  show(BuildContext context, {required String text}) {
    if (isDisplayed) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          indContext = context;
          isDisplayed = true;
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  //boxShadow: const [
                  //                   BoxShadow(
                  //                       color: Colors.white,
                  //                       blurStyle: BlurStyle.normal,
                  //                       blurRadius: 4,
                  //                       offset: Offset(0, 0.2),
                  //                       spreadRadius: 2)
                  //                 ]
                  color: Constants.orange,
                ),
                height: 130,
                width: 300,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        text,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'lufga',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              dismiss();
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black),
                            child: const Text('Okay'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
