import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Mqttdetail extends StatefulWidget {
  @override
  _MqttdetailState createState() => _MqttdetailState();
}

class _MqttdetailState extends State<Mqttdetail> {
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mqtt Settings"),
      ),
      body: Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Mqtt topic",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "topic",
              ),
              controller: myController,
            ),
          ),
          new RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              Navigator.of(context).pushNamed(
                "/second",
                arguments: myController.text,
              );
            },
          )
        ],
      ),
    );
  }
}
