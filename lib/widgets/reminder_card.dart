import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_getx/blocs/reminder_bloc.dart';
import 'package:todo_getx/models/reminder_model.dart';
import 'package:todo_getx/widgets/screensize_config.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminderModel;

  ReminderCard({this.reminderModel});

  deleteReminder(BuildContext context) {
    Provider.of<ReminderBloc>(context, listen: false)
        .deleteData(this.reminderModel);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);

    var iconWidget = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 1.0,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 3.0),
      child: Image(
          width: ScreenSizeConfig.safeBlockHorizontal * 12.0,
          image: AssetImage('assets/images/icons-alarm.png')),
    );

    var title = Text(
      this.reminderModel.dataTitle != null
          ? this.reminderModel.dataTitle
          : 'Untitled',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.0),
    );

    var times = Text(
      this.reminderModel.dataTime != null
          ? this.reminderModel.dataTime
          : 'Undefined time',
      style: TextStyle(
          fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.2,
          color: Colors.black45),
    );

    var description = Text(
      this.reminderModel.dataDesc != null
          ? this.reminderModel.dataDesc
          : 'Undefined Description',
      style: TextStyle(
          fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
          fontWeight: FontWeight.bold),
    );

    var informationWidget = Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 1.5,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 2.0),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          SizedBox(height: ScreenSizeConfig.safeBlockVertical * 0.3),
          times,
          SizedBox(height: ScreenSizeConfig.safeBlockVertical * 1.1),
          description
        ],
      ),
    );

    var stackFirstChildren = GestureDetector(
      onTap: () {
        print('Reminder selected');
        Navigator.pushNamed(context, '/addReminder', arguments: reminderModel);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: ScreenSizeConfig.safeBlockVertical * 0.5,
            horizontal: ScreenSizeConfig.safeBlockHorizontal * 5.6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                ScreenSizeConfig.safeBlockHorizontal * 1.2),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.2,
                  blurRadius: 0.5,
                  offset: Offset(0, 3))
            ]),
        child: Row(children: [iconWidget, informationWidget]),
      ),
    );

    var buttonDelete = Positioned(
        right: ScreenSizeConfig.safeBlockHorizontal * 8.0,
        top: ScreenSizeConfig.safeBlockVertical * 2.5,
        child: GestureDetector(
          onTap: () {
            print('delete action');
            deleteReminder(context);
          },
          child: Icon(
            Icons.delete_rounded,
            color: Colors.red[400],
          ),
        ));

    return Stack(
      children: [stackFirstChildren, buttonDelete],
    );
  }
}
