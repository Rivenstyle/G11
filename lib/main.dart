import './pages/calendar.dart';
import './pages/clock.dart';
import './pages/weather.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<HomePage> {
  List item = List();

  @override
  void initState() {
    item.add(Clockpage());
    item.add(Calendarpage());
    item.add(Weatherpage());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView.builder(
          itemBuilder: (BuildContext context, int index) {
            return item[index];
          },
          itemCount: item.length,
        ),
      ),
    );
  }
}
