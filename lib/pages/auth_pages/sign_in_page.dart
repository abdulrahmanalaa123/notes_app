import 'package:flutter/material.dart';
import 'package:notes_app/ui_components/authentication_components/auth_app_bar.dart';
import 'package:notes_app/ui_components/authentication_components/auth_button.dart';
import 'package:notes_app/ui_components/authentication_components/customFormField.dart';
import 'package:notes_app/helpers/form_validation.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          appBar: const CustomAppBar(text: "Sign In"),
          backgroundColor: Colors.black54,
          body: Stack(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  authFunc: () {
                    _formKey.currentState!.validate();
                    Provider.of<AuthController>(context, listen: false)
                        .SignInWithEmailAndPassword(
                            emailController.text, passwordController.text);
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

//Align(
//alignment: AlignmentDirectional.bottomCenter,
//heightFactor: 2,
//child: Padding(
//padding: EdgeInsets.only(
//bottom:
//MediaQuery.of(context).viewPadding.bottom +
//16),
//child: AuthButton(
//authFunc: () {
//_formKey.currentState!.validate();
//},
//text: "Sign In",
//shadow: false,
//),
//),
//)
