import 'package:flutter/material.dart';
import 'package:notes_app/ui_components/authentication_components/loading_process_page.dart';
import '../../helpers/form_validation.dart';
import '../../helpers/text_control_helpers.dart';
import '../../ui_components/authentication_components/customFormField.dart';
import '../../ui_components/authentication_components/auth_button.dart';
import '../../ui_components/authentication_components/auth_app_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends SignUpHelper<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final loadingPage = LoadingPage();
  @override
  Widget build(BuildContext context) {
    //want to know if its an expensive operation or not well it works
    //with fixed size so it could be operated once and passed on to the widget
    final screenHeight = MediaQuery.of(context).size.height - kToolbarHeight;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: false,
          appBar: const CustomAppBar(text: "Sign Up"),
          backgroundColor: Colors.black54,
          body: Stack(
            children: [
              //now this works unlike before because the child has a fixed size which is
              //a container filling the whole screen so the scroll view has a certain height to scroll in as i understand
              //it just needs to have a fixed size where its big enough to be touched
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: SizedBox(
                    height: screenHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomFormField(
                          controller: nameController,
                          label: 'Name',
                          isPassword: false,
                          validator: Validators.validateName,
                          hintText: 'Enter Your Password',
                        ),
                        CustomFormField(
                          controller: emailController,
                          label: 'Email',
                          isPassword: false,
                          validator: Validators.validateEmail,
                          hintText: 'Enter Your Email',
                        ),
                        //could add a linearprogress indicator for password strength
                        //but it is useless right now
                        CustomFormField(
                          controller: passwordController,
                          label: 'Password',
                          isPassword: true,
                          validator: Validators.validatePassword,
                          hintText: 'Enter Your Password',
                        ),
                        CustomFormField(
                          controller: passwordConfirmController,
                          label: 'Confirm Your Password',
                          isPassword: true,
                          validator: (val) {
                            if (passwordConfirmController.text !=
                                passwordController.text) {
                              return 'Make sure typing the same password';
                            }
                            return null;
                          },
                          hintText: 'Confirm Your Password',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AuthButton(
                  authFunc: () async {
                    if (_formKey.currentState!.validate()) {
                      //gotta add either listening to the states
                      //or just use the push replacement and adding a future builder
                      //ill go with whatever is easier
                      await loadingPage.signUp(signUp(context), context);
                    }
                  },
                  text: "Sign Up",
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

//http://www.engincode.com/flutter-stack-positioned-column-scroll-doesnt-work
//probable solution to old sign up but this works so fuck it
