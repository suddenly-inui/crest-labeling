import 'package:feeling_label/LocalNotificationScreen.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadioButton Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LocalNotificationScreen(),
    );
  }
}
