import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserAuthentication extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User savedUser;
  String _userID = "nulls";

  String _errorProne;

  String get errorProne => _errorProne;
  String get userID => _userID;

  setUserID(String uid) {
    print('setUserID(String uid)');
    _userID = uid;

    print(_userID);
  }

  void initialAuthStateChanges() {
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is not signed in');
      } else {
        print('User is signed in');
      }
    });
  }

  // login
  void loginAccount(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  // register
  Future<String> registerAccount(String email, String password) async {
    String _result = "";

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _result = "register-success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('Email already used');
      }
      _result = e.code;
    } catch (e) {
      print(e);
      _result = e.code;
    }

    return _result;
  }

  // signout
  void exitAccount() async {
    await FirebaseAuth.instance.signOut();
  }

  // get userID
  Future<String> getUserID() async {
    String result = "null";

    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      result = user.uid;
    }
    print('getUserID');

    print(result);
    return result;
  }
}

UserAuthentication userAuthentication = new UserAuthentication();
