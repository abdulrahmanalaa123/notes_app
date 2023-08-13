import 'package:flutter/material.dart';
import '../../service/auth_firebase.dart';
import '../../enums/login_state.dart';
import '../../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseService _auth;
  UserModel? _currentUser;

  LoginState _loginState = LoginState.signedOut;

  AuthController() : _auth = FirebaseService() {
    //comparator initialized to null
    String? comparator;
    _auth.tokenStream().listen((jwt) async {
      String? jwtVal = await jwt;
      print(jwtVal);
      if (jwtVal != null) {
        if (jwtVal != comparator) {
          _loginState = LoginState.refreshToken;
        } else {
          _loginState = LoginState.loggedIn;
        }
        comparator = await jwt;
      } else {
        _loginState = LoginState.signedOut;
      }
      notifyListeners();
    });
  }

  LoginState get loginState => _loginState;
  UserModel? get currentUser => _currentUser;

  //Login Interface

  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **user-disabled**:
  ///  - Thrown if the user corresponding to the given email has been disabled.
  /// - **user-not-found**:
  ///  - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
  ///  - Thrown if the password is invalid for the given email, or the account
  ///    corresponding to the email does not have a password set.
  ///    errors to deal with in a snackbar or a popup probably maybe in a textfield as well
  Future<void> SignInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _currentUser = _auth.user;
      _loginState = LoginState.loggedIn;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> SignInAnonymous() async {
    try {
      await _auth.signInAnonymously();
      _currentUser = _auth.user;
      _loginState = LoginState.loggedIn;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **operation-not-allowed**:
  ///  - Thrown if email/password accounts are not enabled. Enable
  ///    email/password accounts in the Firebase Console, under the Auth tab.
  /// - **weak-password**:
  ///  - Thrown if the password is not strong enough.
  ///  errors should be handled with the textfields and not a snackbar

  //sign up interface
  Future<UserModel?> RegisterWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      await _auth.createAccountWithEmailAndPassword(
          name: name, email: email, password: password);
      _currentUser = _auth.user;
      _loginState = LoginState.loggedIn;
      notifyListeners();
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  //it changes the current stream subscriber in the constructor
  //but state changing is put in case any error happens with the stream
  Future<void> SignOut() async {
    await _auth.signOut();
    _currentUser = _auth.user;
    _loginState = LoginState.signedOut;
    notifyListeners();
  }
}
