import 'package:flutter/material.dart';
import 'package:notes_app/helpers/form_validation.dart';
import 'package:notes_app/ui_components/authentication_components/customFormField.dart';
import 'package:notes_app/ui_components/authentication_components/auth_button.dart';
import 'package:notes_app/constants/style_constants.dart';
import 'package:notes_app/ui_components/authentication_components/auth_app_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
  }

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
        appBar: const CustomAppBar(
          text: 'Register',
        ),
        backgroundColor: Colors.black54,
        body: Center(
          //the first element if selected its label will be cut by the clip edge
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            primary: false,
            clipBehavior: Clip.hardEdge,
            reverse: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            //could refactor to a separate Widget and input a list and use a builder it's such a hassle for a two time use so I would rather not
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomFormField(
                    controller: nameController,
                    label: 'Name',
                    isPassword: false,
                    validator: Validators.validateName,
                    hintText: 'Enter Your Whole Name',
                    labelColor: Constants.beige,
                    borderColor: Constants.beige,
                    cursorColor: Constants.beige,
                    activeBorderColor: Constants.yellow,
                  ),
                  CustomFormField(
                    controller: emailController,
                    label: 'Email',
                    isPassword: false,
                    validator: Validators.validateEmail,
                    hintText: 'Enter Your Email',
                    labelColor: Constants.beige,
                    borderColor: Constants.beige,
                    cursorColor: Constants.beige,
                    activeBorderColor: Constants.yellow,
                  ),
                  //could add a linearprogress indicator for password strength
                  //but it is useless right now
                  CustomFormField(
                    controller: passwordController,
                    label: 'Password',
                    isPassword: true,
                    validator: Validators.validatePassword,
                    hintText: 'Enter Your Password',
                    labelColor: Constants.beige,
                    borderColor: Constants.beige,
                    cursorColor: Constants.beige,
                    activeBorderColor: Constants.yellow,
                  ),
                  //it breaks if i add more fields than to fill the page and then i wouldn't know how to solve
                  //maybe with list view but i don't know how in general as a root solution to this problem
                  // all i know is a solution for this case
                  CustomFormField(
                    controller: passwordConfirmController,
                    label: 'Confirm Password',
                    isPassword: true,
                    validator: (val) {
                      if (val != passwordController.text) {
                        return 'Please check your password';
                      }
                      return null;
                    },
                    hintText: 'Confirm Your Password',
                    labelColor: Constants.beige,
                    borderColor: Constants.beige,
                    cursorColor: Constants.beige,
                    activeBorderColor: Constants.yellow,
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    heightFactor: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewPadding.bottom + 16),
                      child: AuthButton(
                        authFunc: () {
                          _formKey.currentState!.validate();
                        },
                        text: "Sign up",
                        shadow: false,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
