import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:todo_getx/blocs/auth_status.dart';
import 'package:todo_getx/blocs/bloc_notification.dart';
import 'package:todo_getx/blocs/medicine_status.dart';
import 'package:todo_getx/blocs/reminder_bloc.dart';

import 'package:todo_getx/models/reminder_model.dart';
import 'package:todo_getx/services/counter.dart';

class CounterService {
  factory CounterService.instance() => _instance;

  CounterService._internal();

  static final _instance = CounterService._internal();

  final _counter = Counter();

  ValueListenable<int> get count => _counter.count;

  void startCounting() {
    Stream.periodic(Duration(seconds: 5)).listen((_) async {
      _counter.increment();
      print('Counter Incremented: ${_counter.count.value}');

      // let your function here
      // firedNotification();
      conditionRequiredReminder();
    });
  }

  String preProcessGetTime(TimeOfDay time) {
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (time.hour < 10) _preHourTime = "0";
    if (time.minute < 10) _preMinuteTime = "0";

    return _preHourTime +
        time.hour.toString() +
        ":" +
        _preMinuteTime +
        time.minute.toString();
  }

  String timeNow() {
    TimeOfDay _timeNow = TimeOfDay.now();
    return preProcessGetTime(_timeNow);
  }

  void conditionRequiredReminder() async {
    // initial firebase
    Firebase.initializeApp().whenComplete(() {
      print("------------------------> firebase initial completed");
    });

    // get logged in account
    String id = await authStatus.retrieveData();
    print(id);

    if (id != "null-login") {
      // ambil data waktu sekarang
      String timenow = timeNow();
      print(timenow);

      String _medicineStatus = await medicineStatus.retrieveData();
      print(_medicineStatus);

      if (_medicineStatus != 'Tidak ada notifikasi') {
        // ambil data waktu yang ada di record user
        List<ReminderModel> dataStored = await reminderBloc.getDataByID(id);
        print(dataStored.length);

        // iterasi tiap data
        dataStored.forEach((element) {
          print(element.dataTime);
          if (timenow == element.dataTime) {
            print('Alarm Fired!!!');
            blocNotificationInstance.showNotification(_medicineStatus);
            // blocNotificationInstance.showNotification(element.dataTitle);
          }
        });
      }
    }
  }
}
