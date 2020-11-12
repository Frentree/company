import 'package:flutter/material.dart';

class WidgetMain extends StatefulWidget {
  @override
  _WidgetMainState createState() => _WidgetMainState();
}

class _WidgetMainState extends State<WidgetMain> {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text("Widget Main Page"),),
        )

    );
  }
}
