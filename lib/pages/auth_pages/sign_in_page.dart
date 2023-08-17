import 'package:flutter/material.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/ui_components/authentication_components/auth_app_bar.dart';
import 'package:notes_app/ui_components/authentication_components/auth_button.dart';
import 'package:notes_app/ui_components/authentication_components/customFormField.dart';
import 'package:notes_app/helpers/form_validation.dart';
import 'package:notes_app/helpers/text_control_helpers.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends SignInHelper<SignIn> {
  final _formKey = GlobalKey<FormState>();
  //composition used instead of provider since it seemed as the fitted
  //use for my case since i wouldnt implement all the functions and mixins didnt work
  //didnt know how to implement the text helper as a super class to have access to the instance variables
  //and applying some of its functions as seemed fit which seemed like the best fit
  //yet I didnt know how to implement

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: false,
          appBar: const CustomAppBar(text: "Sign In"),
          backgroundColor: Colors.black54,
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomFormField(
                      controller: emailController,
                      label: 'Email',
                      isPassword: false,
                      validator: Validators.validateEmail,
                      hintText: 'Enter Your Email',
                    ),
                    //could add a linear progress indicator for password strength
                    //but it is useless right now
                    CustomFormField(
                      controller: passwordController,
                      label: 'Password',
                      isPassword: true,
                      validator: Validators.validatePassword,
                      hintText: 'Enter Your Password',
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AuthButton(
                  authFunc: () async {
                    if (_formKey.currentState!.validate()) {
                      await signIn(context);
                      //gotta add either listening to the states
                      //or just use the push replacement and adding a future builder
                      //ill go with whatever is easier
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()),
                          (Route<dynamic> predicate) => false,
                        );
                      }
                    }
                  },
                  text: "Sign In",
                  shadow: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
