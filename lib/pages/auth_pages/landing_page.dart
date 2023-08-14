import 'package:flutter/material.dart';
import 'package:notes_app/pages/auth_pages/sign_in_page.dart';
import 'package:notes_app/ui_components/authentication_components/auth_button.dart';
import 'sign_up_page.dart';
import '../../constants/style_constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Expanded(
              child: SizedBox(
            child: Center(
              child: Text(
                'Welcome to \nNotes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
          )),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(70)),
              color: Constants.beige,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthButton(
                  authFunc: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignIn()));
                  },
                  text: 'Login',
                  shadow: false,
                  borderColor: Constants.backGround,
                  bodyColor: Constants.backGround,
                  textColor: Constants.textColor,
                ),
                AuthButton(
                  authFunc: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignUp()));
                  },
                  text: 'Sign Up',
                  shadow: false,
                  borderColor: Colors.black,
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
