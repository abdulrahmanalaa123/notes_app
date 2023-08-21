import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth;

  FirebaseService() : _firebaseAuth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return UserModel(id: user.uid, name: user.displayName, email: user.email);
    }
  }

  Future<String?> _tokenFromUser(User? user) async {
    if (user == null) {
      return null;
    } else {
      return user.getIdToken();
    }
  }

  //checking new user jwt
  UserModel? get user => _userFromFirebase(_firebaseAuth.currentUser);
  Future<String?> get jwt async =>
      await _tokenFromUser(_firebaseAuth.currentUser);

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> createAccountWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firebaseAuth.currentUser?.updateDisplayName(name);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //left like this as an interface
  Stream<Future<String?>> tokenStream() {
    return _firebaseAuth.idTokenChanges().map(_tokenFromUser);
  }
}
