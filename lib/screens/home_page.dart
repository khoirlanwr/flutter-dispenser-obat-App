import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo_getx/blocs/auth_status.dart';
import 'package:todo_getx/blocs/medicine_status.dart';

import 'package:todo_getx/blocs/reminder_bloc.dart';
import 'package:todo_getx/models/reminder_model.dart';
import 'package:todo_getx/widgets/reminder_card.dart';

import 'package:provider/provider.dart';
import 'package:todo_getx/blocs/user_authentication.dart';
import 'package:todo_getx/widgets/screensize_config.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _uid;

  StreamSubscription<Event> _onDataMedicineStatusAdded;
  StreamSubscription<Event> _onDataMedicineStatusChanged;

  // Exit account
  exitAccount() {
    userAuthentication.exitAccount();
  }

  _onSaveDataLoggedIn() {
    authStatus.saveData(widget.user.uid);
  }

  @override
  void initState() {
    super.initState();
    _onSaveDataLoggedIn();

    _onDataMedicineStatusAdded = FirebaseDatabase.instance
        .reference()
        .child('medicine_status')
        .onChildAdded
        .listen((event) {
      setState(() {
        print('new data added on medicine_status');
      });
    });

    _onDataMedicineStatusChanged = FirebaseDatabase.instance
        .reference()
        .child('medicine_status')
        .onChildChanged
        .listen((event) {
      setState(() {
        print('data medicine_status changed');
      });
    });
  }

  @override
  void dispose() {
    _onDataMedicineStatusAdded.cancel();
    _onDataMedicineStatusChanged.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);

    var logoutButton = GestureDetector(
      onTap: () {
        exitAccount();
      },
      child: Container(
        width: ScreenSizeConfig.safeBlockHorizontal * 10,
        height: ScreenSizeConfig.safeBlockVertical * 5,
        child: Center(child: Icon(Icons.logout, color: Colors.white)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ScreenSizeConfig.safeBlockHorizontal * 2.0),
            color: Colors.blueAccent),
      ),
    );

    var loggedInUserCard = Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 1.0,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 2.0),
      height: ScreenSizeConfig.safeBlockHorizontal * 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.account_circle_sharp,
            color: Colors.white,
          ),
          SizedBox(
            width: ScreenSizeConfig.safeBlockHorizontal * 3.0,
          ),
          Text(widget.user.email,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(
              ScreenSizeConfig.safeBlockHorizontal * 2.0)),
    );

    var navBar = Padding(
      padding: EdgeInsets.only(
        top: ScreenSizeConfig.safeBlockVertical * 2.0,
        bottom: ScreenSizeConfig.safeBlockVertical * 6.0,
        right: ScreenSizeConfig.safeBlockHorizontal * 4.0,
        left: ScreenSizeConfig.safeBlockHorizontal * 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [loggedInUserCard, logoutButton],
      ),
    );

    var barStatusObat = FutureBuilder(
        future: medicineStatus.retrieveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }

          print(snapshot.data);

          return Padding(
            padding: EdgeInsets.only(
                left: ScreenSizeConfig.safeBlockHorizontal * 5.0,
                right: ScreenSizeConfig.safeBlockHorizontal * 5.0,
                bottom: ScreenSizeConfig.safeBlockHorizontal * 2.5),
            child: Center(
              child: Card(
                child: ListTile(
                  leading: (snapshot.data == 'Tidak ada notifikasi')
                      ? Icon(Icons.album, color: Colors.blue[900])
                      : (snapshot.data == 'Waktunya minum obat')
                          ? Icon(Icons.album, color: Colors.blue[600])
                          : (snapshot.data == 'Obat belum diambil')
                              ? Icon(Icons.album, color: Colors.cyan)
                              : Icon(Icons.album, color: Colors.yellowAccent),
                  title: Text(
                    'Status',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  subtitle: Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        });

    var contentStatus = Padding(
      padding: EdgeInsets.only(
          top: ScreenSizeConfig.safeBlockVertical * 2.0,
          bottom: ScreenSizeConfig.safeBlockVertical * 0.6),
      child: Text('Status Dispenser Obat',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 5.0,
              fontWeight: FontWeight.bold)),
    );

    var content = Padding(
      padding: EdgeInsets.only(
          top: ScreenSizeConfig.safeBlockVertical * 2.0,
          bottom: ScreenSizeConfig.safeBlockVertical * 0.6),
      child: Text('Reminders',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black87,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 5.0,
              fontWeight: FontWeight.bold)),
    );

    var retrieveData = Consumer<ReminderBloc>(
        builder: (context, reminder, child) =>
            FutureBuilder<List<ReminderModel>>(
              future: reminder.getLatestData(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('State: waiting ...');
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  // print(snapshot.data.length);

                  List<ReminderModel> _resultedLists = snapshot.data;

                  if (_resultedLists == null) {
                    return Container(
                      child: Text('Hai, reminder masih kosong'),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ReminderCard(
                            reminderModel: _resultedLists[index],
                          );
                        });
                  }
                }
              },
            ));

    var buttonAddReminder = Positioned(
        bottom: ScreenSizeConfig.safeBlockVertical * 3.0,
        right: ScreenSizeConfig.safeBlockHorizontal * 5.0,
        child: GestureDetector(
          onTap: () {
            print('button add reminder tapped');
            Navigator.pushNamed(context, '/addReminder', arguments: null);
          },
          child: Container(
            width: ScreenSizeConfig.safeBlockHorizontal * 30,
            height: ScreenSizeConfig.safeBlockVertical * 7.0,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(
                    ScreenSizeConfig.safeBlockHorizontal * 1.5)),
            child: Center(
              child: Text('Tambah baru',
                  style: TextStyle(
                      fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    var contentItems = Container(
      child: Column(children: [
        navBar,
        contentStatus,
        barStatusObat,
        content,
        Expanded(child: retrieveData)
      ]),
    );

    var curvedBackground = Positioned(
        bottom: ScreenSizeConfig.safeBlockVertical * 0.0,
        child: Container(
          width: ScreenSizeConfig.safeBlockHorizontal * 100,
          height: ScreenSizeConfig.safeBlockVertical * 75.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(ScreenSizeConfig.safeBlockHorizontal * 2),
                  topRight: Radius.circular(
                      ScreenSizeConfig.safeBlockHorizontal * 2))),
        ));

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Stack(
          children: [
            curvedBackground, // as bottom widget of stack
            contentItems, // as middle widget of stack
            buttonAddReminder, // as top widget of stack
          ],
        ),
      ),
    );
  }
}
