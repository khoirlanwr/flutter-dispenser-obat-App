import 'package:date_format/date_format.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_getx/blocs/reminder_bloc.dart';
import 'package:todo_getx/blocs/user_authentication.dart';
import 'package:todo_getx/models/reminder_model.dart';
import 'package:todo_getx/widgets/screensize_config.dart';

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  String _hour, _minute, _time;
  String _setTime;

  String _uid;

  ReminderModel reminderModel;

  bool _alreadyChecked = false;

  String _docKey;

  // function to convert format time
  DateTime parseData(String time) {
    String date = "2021-02-20 ";
    String completeTime = date + time + ":00Z";

    var createdDate = DateTime.parse(completeTime);
    return createdDate;
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;

        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;

        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2021, 02, 20, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  updateData(String userID, String title, String description,
      TimeOfDay selectedTime, BuildContext context) {
    // pre-processing time
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (selectedTime.hour < 10) _preHourTime = "0";
    if (selectedTime.minute < 10) _preMinuteTime = "0";

    String timer = _preHourTime +
        selectedTime.hour.toString() +
        ":" +
        _preMinuteTime +
        selectedTime.minute.toString();

    ReminderModel updatedModel =
        new ReminderModel(userID, title, description, timer);

    Provider.of<ReminderBloc>(context, listen: false)
        .updateData(_docKey, updatedModel);
    Navigator.pop(context);
  }

  createData(String userID, String title, String description,
      TimeOfDay selectedTime, BuildContext context) {
    // pre-processing time
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (selectedTime.hour < 10) _preHourTime = "0";
    if (selectedTime.minute < 10) _preMinuteTime = "0";

    String timer = _preHourTime +
        selectedTime.hour.toString() +
        ":" +
        _preMinuteTime +
        selectedTime.minute.toString();

    ReminderModel reminderModel =
        new ReminderModel(userID, title, description, timer);

    Provider.of<ReminderBloc>(context, listen: false).createData(reminderModel);

    Navigator.pop(context);
  }

  _onCheckCondition(ReminderModel reminderModel) {
    if (reminderModel != null) {
      _docKey = reminderModel.idKey;

      _titleController.text = reminderModel.dataTitle;
      _descController.text = reminderModel.dataDesc;

      _timeController.text = reminderModel.dataTime;

      var timeFromDB = parseData(_timeController.text);
      selectedTime =
          TimeOfDay(hour: timeFromDB.hour, minute: timeFromDB.minute);
    }
    _alreadyChecked = true;
  }

  void _onCurrentUser() async {
    _uid = await userAuthentication.getUserID();
  }

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2021, 02, 20, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    _onCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);

    reminderModel = ModalRoute.of(context).settings.arguments;
    if (_alreadyChecked == false) _onCheckCondition(reminderModel);

    var titleField = TextField(
      controller: _titleController,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black54,
                  width: ScreenSizeConfig.safeBlockHorizontal * 0.3)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black54,
                  width: ScreenSizeConfig.safeBlockHorizontal * 0.3)),
          border: InputBorder.none,
          hintText: 'judul reminder.'),
      style: TextStyle(
          fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
          fontWeight: FontWeight.bold),
    );

    var descriptionField = Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 0.4,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 2.6),
      height: ScreenSizeConfig.safeBlockVertical * 25.0,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          color: Colors.white,
          borderRadius: BorderRadius.circular(
              ScreenSizeConfig.safeBlockHorizontal * 1.0)),
      child: TextField(
        controller: _descController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'deskripsi reminder',
        ),
        style: TextStyle(
            fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
            fontWeight: FontWeight.bold),
      ),
    );

    var timeField = InkWell(
      onTap: () {
        _selectTime(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: ScreenSizeConfig.safeBlockVertical * 1),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.1,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(6)),
        child: TextFormField(
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 6.0),
          textAlign: TextAlign.center,
          onSaved: (String value) {
            _setTime = value;
          },
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _timeController,
          decoration: InputDecoration(
              disabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );

    var addReminderContent = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 3.0,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 10.0),
      child: Center(
          child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 3.0,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 4.0,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                ScreenSizeConfig.safeBlockHorizontal * 3.0)),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.65,
        child: ListView(
          children: [
            Text(
              'Tambah reminder baru.',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w800,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 9.5,
              ),
            ),
            Divider(
              height: ScreenSizeConfig.safeBlockVertical * 1.5,
            ),
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 1.0,
            ),
            titleField,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 1.0,
            ),
            descriptionField,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 1.0,
            ),
            timeField
          ],
        ),
      )),
    );

    var saveData = Positioned(
        bottom: ScreenSizeConfig.safeBlockVertical * 5.0,
        right: ScreenSizeConfig.safeBlockHorizontal * 6.0,
        child: GestureDetector(
          onTap: () {
            if (reminderModel == null) {
              createData(_uid, _titleController.text, _descController.text,
                  selectedTime, context);
            } else {
              updateData(_uid, _titleController.text, _descController.text,
                  selectedTime, context);
            }
          },
          child: Container(
            width: ScreenSizeConfig.safeBlockHorizontal * 21,
            height: ScreenSizeConfig.safeBlockVertical * 6.0,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(
                    ScreenSizeConfig.safeBlockHorizontal * 1.5)),
            child: Center(
              child: Text('Simpan',
                  style: TextStyle(
                      fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ));

    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white38),
        child: Stack(
          children: [addReminderContent, saveData],
        ),
      ),
    ));
  }
}
