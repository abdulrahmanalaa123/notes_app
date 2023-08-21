import 'package:flutter/material.dart';
import 'package:notes_app/view_models/auth_view_model/auth_controller_provider.dart';
import 'package:provider/provider.dart';

//just for documentation the first iteration was a changenotifier
//then seen as useless as well as buggy
//it was changed to a composition implementation in both signup and sign in
//then this final implementation seems like the best in seperating concerns but still its a bit useless
//since each helper will be used only used once and wasnt worth the 2 days spent but yet learnign a bit about stateful widget
//and state sharing like this https://medium.com/flutter-community/a-stateset-class-part-1-2891f1a0eea1
//as well as dealing with changenotifier a bit better and understanding how stateful widgets for some fucking reason
//disposes later than the use call and its supposedly a synchronous function that yet i still dont know
//and was solved with changenotifierprovider.value which saves the object which could lead to memory leaks
//so it didnt solve anything and that was the problem wiht changenotifier
//although at second thought the composition model wouldve been better and more fitting yet its of no point
//the whole matter is trivial

//ToDO
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
    } catch (e) {
      rethrow;
    }
  }
}

abstract class SignUpHelper<T extends StatefulWidget> extends State<T> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

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
    } catch (e) {
      rethrow;
    }
  }
}

//this was the old implementation of the composititon model
//class TextHelper {
//  TextEditingController? _nameController;
//  TextEditingController? _emailController;
//  TextEditingController? _passwordController;
//  TextEditingController? _passwordConfirmController;
//  //this doesnt generate unlimited text controllers
//  //plus each use of a controller must be in place because mixing them up
//  //will lead to breaking the interface and further enhancing this would add error
//  //handling to explain why the text interface isnt working
//
//  TextEditingController get nameController =>
//      _nameController = TextEditingController();
//  TextEditingController get emailController =>
//      _emailController = TextEditingController();
//  TextEditingController get passwordController =>
//      _passwordController = TextEditingController();
//  TextEditingController get passwordConfirmController =>
//      _passwordConfirmController = TextEditingController();
//
//  @override
//  void dispose() {
//    _nameController?.dispose();
//    _emailController?.dispose();
//    _passwordController?.dispose();
//    _passwordConfirmController?.dispose();
//  }
//
//  Future<void> signIn(BuildContext context) async {
//    try {
//      await Provider.of<AuthController>(context, listen: false)
//          .SignInWithEmailAndPassword(
//              emailController.text, passwordController.text);
//    } catch (e) {}
//  }
//
//  Future<void> signUp(BuildContext context) async {
//    try {
//      await Provider.of<AuthController>(context, listen: false)
//          .RegisterWithEmailAndPassword(_nameController!.text,
//              _emailController!.text, _passwordController!.text);
//    } catch (e) {}
//  }
//}
