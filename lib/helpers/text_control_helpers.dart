import 'package:flutter/material.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'package:provider/provider.dart';

//they might extned the same class but fuck it
//need to look up more on extending state<T>
//and mixins + abstract classes
abstract class SignInHelper<T extends StatefulWidget> extends State<T> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    passwordController = TextEditingController();
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    try {
      await Provider.of<AuthController>(context, listen: false)
          .SignInWithEmailAndPassword(
              emailController.text, passwordController.text);
    } catch (e) {}
  }
}

abstract class SignUpHelper<T extends StatefulWidget> extends State<T> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;
  //this doesnt generate unlimited text controllers
  //plus each use of a controller must be in place because mixing them up
  //will lead to breaking the interface and further enhancing this would add error
  //handling to explain why the text interface isnt working

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> signUp(BuildContext context) async {
    try {
      await Provider.of<AuthController>(context, listen: false)
          .RegisterWithEmailAndPassword(nameController.text,
              emailController.text, passwordController.text);
    } catch (e) {}
  }
}
