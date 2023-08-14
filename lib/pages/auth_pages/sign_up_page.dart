import 'package:flutter/material.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'package:provider/provider.dart';
import '../../helpers/form_validation.dart';
import '../../ui_components/authentication_components/customFormField.dart';
import '../../ui_components/authentication_components/auth_button.dart';
import '../../ui_components/authentication_components/auth_app_bar.dart';

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
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  authFunc: () {
                    _formKey.currentState!.validate();
                    Provider.of<AuthController>(context, listen: false)
                        .RegisterWithEmailAndPassword(nameController.text,
                            emailController.text, passwordController.text);
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
