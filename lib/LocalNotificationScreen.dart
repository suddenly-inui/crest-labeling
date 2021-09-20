import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RadioValue { FIRST, SECOND, THIRD, FOURTH, FIFTH }
final flnp = FlutterLocalNotificationsPlugin();

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  RadioValue _gValue = RadioValue.THIRD;
  List<DropdownMenuItem<int>> _notificationInterval = [
    DropdownMenuItem(
      child: Text("毎分"),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text("毎時"),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text("毎日"),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text("毎週"),
      value: 3,
    )
  ];
  List<RepeatInterval> intervalList = [
    RepeatInterval.everyMinute,
    RepeatInterval.hourly,
    RepeatInterval.daily,
    RepeatInterval.weekly,
  ];
  int _selectedItem = 0;

  @override
  void initState() {
    loadNotificationInterval();
    prepareNotification();
  }

  var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'alarm_notif',
        'Scheduled notification', //name of the notif channel
        'A scheduled notification', //description of the notif channel
        icon: 'question',
        largeIcon: DrawableResourceAndroidBitmap('question'),
      ),
      iOS: IOSNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true));

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        sendDB(_gValue);
                      },
                      child: Text("送信"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<int>(
                      items: _notificationInterval,
                      value: _selectedItem,
                      onChanged: (value) {
                        setState(
                          () {
                            _selectedItem = value!;
                          },
                        );
                        saveNotificationInterval(value!);
                        prepareNotification();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  //ここをいじってデータベースに送信
  void sendDB(value) {
    print(value);
  }

  void saveNotificationInterval(int num) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("notificationInterval", num);
  }

  void loadNotificationInterval() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _selectedItem = prefs.getInt("notificationInterval") ?? 0;
    });
  }

  void prepareNotification() async {
    flnp
        .initialize(
          InitializationSettings(
            iOS: IOSInitializationSettings(),
          ),
        )
        .then((value) => {
              flnp.periodicallyShow(0, 'Title', 'Body',
                  intervalList[_selectedItem], platformChannelSpecifics)
            });
  }

  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }
}
