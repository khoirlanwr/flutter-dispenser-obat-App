import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_getx/models/reminder_model.dart';

class ReminderBloc extends ChangeNotifier {
  final List<ReminderModel> _reminderLists = [];

  List<ReminderModel> get reminderLists => _reminderLists;

  // CREATE
  void createData(ReminderModel reminderModel) async {
    _reminderLists.clear();

    String docID = randomAlphaNumeric(11);
    print('docID Random');
    print(docID);

    await FirebaseDatabase.instance
        .reference()
        .child('reminders')
        .child(reminderModel.userID)
        .child(docID)
        .set({
          'userID': reminderModel.userID,
          'title': reminderModel.dataTitle,
          'description': reminderModel.dataDesc,
          'time': reminderModel.dataTime,
          'timestamps': ServerValue.timestamp
        })
        .then((value) => print('Data added successfully'))
        .catchError((e) {
          print(e);
        });

    notifyListeners();
  }

  // UPDATE
  void updateData(String docKey, ReminderModel updatedModel) async {
    await FirebaseDatabase.instance
        .reference()
        .child('reminders')
        .child(updatedModel.userID)
        .child(docKey)
        .update({
      'title': updatedModel.dataTitle,
      'description': updatedModel.dataDesc,
      'time': updatedModel.dataTime,
      'timestamps': ServerValue.timestamp
    }).then((value) => print('Data updated succesfully'));

    notifyListeners();
  }

  // DELETE
  void deleteData(ReminderModel deletedModel) {
    FirebaseDatabase.instance
        .reference()
        .child('reminders')
        .child(deletedModel.userID)
        .child(deletedModel.idKey)
        .remove();

    notifyListeners();
  }

  // GET LATEST
  Future<List<ReminderModel>> getLatestData(User user) async {
    List<ReminderModel> _listData = [];

    await FirebaseDatabase.instance
        .reference()
        .child('reminders')
        .child(user.uid)
        .once()
        .then((snapshot) {
      print(snapshot.value);

      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        print(key);

        print(value['userID']);
        print(value['title']);

        _listData.add(ReminderModel.fromSource(key, value['userID'],
            value['title'], value['description'], value['time']));
      });
    });

    print(_listData.length);
    return _listData;
  }

  // GET LATEST
  Future<List<ReminderModel>> getDataByID(String id) async {
    List<ReminderModel> _listData = [];

    print('getDataById');
    print(id);

    await FirebaseDatabase.instance
        .reference()
        .child('reminders')
        .child(id)
        .once()
        .then((snapshot) {
      print(snapshot.value);

      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        _listData.add(ReminderModel.fromSource(key, value['userID'],
            value['title'], value['description'], value['time']));
      });
    });

    // print(_listData.length);
    return _listData;
  }
}

ReminderBloc reminderBloc = new ReminderBloc();
