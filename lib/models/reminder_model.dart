import 'package:firebase_database/firebase_database.dart';

class ReminderModel {
  String idKey;
  String userID;
  String dataTitle;
  String dataDesc;
  String dataTime;

  ReminderModel(this.userID, this.dataTitle, this.dataDesc, this.dataTime);

  ReminderModel.fromSnapshot(DataSnapshot dataSnapshot) {
    idKey = dataSnapshot.key;
    userID = dataSnapshot.value['userID'];
    dataTitle = dataSnapshot.value['title'];
    dataDesc = dataSnapshot.value['description'];
    dataTime = dataSnapshot.value['time'];
  }

  ReminderModel.fromSource(
      String key, String uid, String title, String desc, String time) {
    idKey = key;
    userID = uid;
    dataTitle = title;
    dataDesc = desc;
    dataTime = time;
  }
}
