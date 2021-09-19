import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum RadioValue { FIRST, SECOND, THIRD, FOURTH, FIFTH }
final flnp = FlutterLocalNotificationsPlugin();

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  RadioValue _gValue = RadioValue.THIRD;

  @override
  void initState() {
    flnp.initialize(
      InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    );

    notification();

    // flnp.zonedSchedule(
    //   0,
    //   'title',
    //   'body',
    //   tz.TZDateTime.now(tz.local).add(Duration(seconds: 20)),
    //   NotificationDetails(),
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
    // //FlutterLocalNotificationsPlugin.periodicallyShow()
    // print(tz.TZDateTime.now(tz.UTC).add(Duration(seconds: 20)));
  }

  void notification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'Scheduled notification', //name of the notif channel
      'A scheduled notification', //description of the notif channel
      icon: 'question',
      largeIcon: DrawableResourceAndroidBitmap('question'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flnp.periodicallyShow(0, 'Title', 'Body', RepeatInterval.everyMinute,
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("feelings"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                child: Text(
                  "現在の気分に最も近しいものを選んで送信ボタンを押してください。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              RadioListTile(
                title: Text('とても気分がいい'),
                value: RadioValue.FIRST,
                groupValue: _gValue,
                onChanged: (value) => _onRadioSelected(value),
              ),
              RadioListTile(
                title: Text('気分がいい'),
                value: RadioValue.SECOND,
                groupValue: _gValue,
                onChanged: (value) => _onRadioSelected(value),
              ),
              RadioListTile(
                title: Text('普通'),
                value: RadioValue.THIRD,
                groupValue: _gValue,
                onChanged: (value) => _onRadioSelected(value),
              ),
              RadioListTile(
                title: Text('気分が悪い'),
                value: RadioValue.FOURTH,
                groupValue: _gValue,
                onChanged: (value) => _onRadioSelected(value),
              ),
              RadioListTile(
                title: Text('とても気分が悪い'),
                value: RadioValue.FIFTH,
                groupValue: _gValue,
                onChanged: (value) => _onRadioSelected(value),
              ),
              SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                onPressed: () {
                  // send to DB. the value is in _gValue.
                  print(_gValue);
                },
                child: Text("送信"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }
}