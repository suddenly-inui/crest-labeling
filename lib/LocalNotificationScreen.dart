import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:numberpicker/numberpicker.dart';

enum RadioValue { FIRST, SECOND, THIRD, FOURTH, FIFTH }
final flnp = FlutterLocalNotificationsPlugin();

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  RadioValue _gValue = RadioValue.THIRD;

  int t1 = 9;
  int t2 = 12;
  int t3 = 18;
  int t4 = 21;

  @override
  void initState() {
    loadNotificationInterval();
    flnp.initialize(
      InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    );
    timeNotification(t1, t2, t3, t4);
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      sendDB(_gValue);
                    } catch (e) {
                      print("server not connected...");
                    }
                  },
                  child: Text("送信"),
                ),
              ),
              Text(
                "--通知感覚の指定--",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: t1,
                    onChanged: (value) {
                      setState(() {
                        t1 = value;
                      });
                      timeNotification(t1, t2, t3, t4);
                      saveNotificationInterval(t1, t2, t3, t4);
                    },
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: t2,
                    onChanged: (value) {
                      setState(() {
                        t2 = value;
                      });
                      timeNotification(t1, t2, t3, t4);
                      saveNotificationInterval(t1, t2, t3, t4);
                    },
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: t3,
                    onChanged: (value) {
                      setState(() {
                        t3 = value;
                      });
                      timeNotification(t1, t2, t3, t4);
                      saveNotificationInterval(t1, t2, t3, t4);
                    },
                  ),
                  NumberPicker(
                    minValue: 0,
                    maxValue: 23,
                    value: t4,
                    onChanged: (value) {
                      setState(() {
                        t4 = value;
                      });
                      timeNotification(t1, t2, t3, t4);
                      saveNotificationInterval(t1, t2, t3, t4);
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  //デバッグ//
                  print("$t1, $t2, $t3, $t4");

                  //デバッグ//
                },
                child: Text("Debug"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendDB(value) async {
    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Map<RadioValue, String> label = {
      RadioValue.FIRST: "-2",
      RadioValue.SECOND: "-1",
      RadioValue.THIRD: "0",
      RadioValue.FOURTH: "1",
      RadioValue.FIFTH: "2",
    };

    final body = json.encode({
      "device_id": "a28a128d-afa9-4eb5-ab51-0e059e9aadb9",
      "label": label[value]
    });

    final uri = Uri.http('minami.jn.sfc.keio.ac.jp:80', "/");
    final res = await http.post(
      uri,
      headers: header,
      body: body,
    );
  }

  void saveNotificationInterval(int t1, int t2, int t3, int t4) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("t1", t1);
    prefs.setInt("t2", t2);
    prefs.setInt("t3", t3);
    prefs.setInt("t4", t4);
  }

  void loadNotificationInterval() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      t1 = prefs.getInt("t1") ?? 9;
      t2 = prefs.getInt("t2") ?? 12;
      t3 = prefs.getInt("t3") ?? 18;
      t4 = prefs.getInt("t4") ?? 21;
    });
  }

  void timeNotification(int t1, int t2, int t3, int t4) {
    void sendNotification(int id, int hour, int addday) {
      tz.initializeTimeZones();
      tz.TZDateTime dt = tz.TZDateTime.now(tz.getLocation("Asia/Tokyo"));
      if (hour <= dt.hour) {
        addday += 1;
      }
      flnp.zonedSchedule(
        id,
        "時間です",
        "今の感情を入力してください",
        tz.TZDateTime(
          tz.getLocation("Asia/Tokyo"),
          dt.year,
          dt.month,
          dt.day,
          hour,
        ).add(Duration(days: addday)),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }

    sendNotification(0, t1, 0);
    sendNotification(1, t2, 0);
    sendNotification(2, t3, 0);
    sendNotification(3, t4, 0);
    sendNotification(4, t1, 1);
    sendNotification(5, t2, 1);
    sendNotification(6, t3, 1);
    sendNotification(7, t4, 1);
    sendNotification(8, t1, 2);
    sendNotification(9, t2, 2);
    sendNotification(10, t3, 2);
    sendNotification(11, t4, 2);
  }

  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }
}
