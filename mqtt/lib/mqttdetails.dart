import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Mqttdetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mqtt Settings"),
        ),
        body: Column(
          children: <Widget>[
            new Text("Mqtt topic"),
            new TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "topic",
              ),
            )
          ],
        ));
  }
}
