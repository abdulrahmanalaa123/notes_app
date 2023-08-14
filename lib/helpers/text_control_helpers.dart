import 'package:flutter/material.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'package:provider/provider.dart';

class TextHelper extends ChangeNotifier {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  TextEditingController get nameController =>
      _nameController = TextEditingController();
  TextEditingController get emailController =>
      _emailController = TextEditingController();
  TextEditingController get passwordController =>
      _passwordController = TextEditingController();
  TextEditingController get passwordConfirmController =>
      _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void signIn(BuildContext context) async {
    try {
      await Provider.of<AuthController>(context, listen: false)
          .SignInWithEmailAndPassword(
              _emailController.text, _passwordController.text);
    } catch (e) {}
  }

  void signUp(BuildContext context) async {
    try {
      await Provider.of<AuthController>(context, listen: false)
          .RegisterWithEmailAndPassword(_nameController.text,
              _emailController.text, _passwordController.text);
    } catch (e) {}
  }
}
