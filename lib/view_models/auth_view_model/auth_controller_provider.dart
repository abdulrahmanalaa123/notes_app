import 'package:flutter/material.dart';
import 'package:notes_app/helpers/sp_helper.dart';
import 'package:notes_app/repo/notes_repo.dart';
import '../../repo/auth_firebase.dart';
import '../../enums/login_state.dart';
import '../../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseService _auth;
  UserModel? _currentUser;
  //this is considered coupling as well
  //dont know how to do it any other way atm
  //no way to seperate except make the repo listen to the controller
  //or make the shared pref a provider and listen
  //which is layers of complexity so fk it stay like this for now
  //so i could listen to changes
  //how this works is i made the noterepo a singleton
  //just to access the same repo and updating would edit in the view model as well

  //couldve made a sp provider with a watcher for the userId and injecting it into the notesViewModel when instantiating it
  //which would seperate concerns and detach the _noteRepo from the authcontroller and not needing to update after each operation
  //but ill stick to this implementation because this application has took too long and has gotten way too complex for no reason

  final SharedPreferenceHelper _storageHelper;
  final NoteRepo _noteRepo;
  LoginState _loginState = LoginState.signedOut;

  AuthController()
      : _auth = FirebaseService(),
        _storageHelper = SharedPreferenceHelper(),
        _noteRepo = NoteRepo() {
    //comparator initialized to null
    //comparator is the past token
    String? comparator;

    _auth.tokenStream().listen((jwt) async {
      String? jwtVal = await jwt;
      //solving the hot restart bug in firebase
      print('we are hjere stream subscriber');
      print('the user is ${_currentUser?.id}');
      if (jwtVal != null) {
        if (jwtVal != comparator) {
          //this means that the token is reset but it gives issues so its logged in as well
          _loginState = LoginState.loggedIn;
        } else {
          _loginState = LoginState.loggedIn;
        }
        //this would happen if the user is null but the token is valid so dont change user
        //sign out would register
        //updating the repo gives some wierd interaction where it would take longer before it notifies users of the current
        //still valid token
      } else {
        _loginState = LoginState.signedOut;
      }
      comparator = jwtVal;

      notifyListeners();
    });
  }

  LoginState get loginState => _loginState;
  UserModel? get currentUser => _currentUser;

  //Future voids are there to enable awaiting

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
      await _updateRepo(false);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> SignInAnonymous() async {
    try {
      await _auth.signInAnonymously();
      _currentUser = _auth.user;
      await _updateRepo(false);
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
  Future<void> RegisterWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      await _auth.createAccountWithEmailAndPassword(
          name: name, email: email, password: password);
      _currentUser = _auth.user;
      await _updateRepo(false);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //it changes the current stream subscriber in the constructor
  //but state changing is put in case any error happens with the stream
  Future<void> SignOut() async {
    await _auth.signOut();
    _currentUser = _auth.user;
    await _updateRepo(true);
    notifyListeners();
  }

  Future<void> _updateRepo(bool remove) async {
    if (remove) {
      await _storageHelper.remove('currentUser');
    } else {
      await _storageHelper.set(_currentUser?.id, 'currentUser');
    }
    print('updating');
    await _noteRepo.updateUserId();
  }
}
