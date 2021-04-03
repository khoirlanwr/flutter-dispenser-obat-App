import 'package:firebase_database/firebase_database.dart';

class AuthStatus {
  // SAVE DATA
  void saveData(String uid) {
    FirebaseDatabase.instance
        .reference()
        .child('auth_status')
        .set({'loggedIn': uid}).then((value) {
      print('save data success');
    });
  }

  // RETRIEVE DATA
  Future<String> retrieveData() async {
    String result = "err";
    await FirebaseDatabase.instance
        .reference()
        .child('auth_status')
        .once()
        .then((value) {
      Map<dynamic, dynamic> res = value.value;
      res.forEach((key, value) {
        print(value);
        result = value;
      });
    });

    return result;
  }
}

AuthStatus authStatus = new AuthStatus();
