import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt/route.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sensors/sensors.dart';

final MqttClient client = MqttClient('test.mosquitto.org', '');

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT-TEAM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class Homepage extends StatefulWidget {
  final String data;
  var ps = [];
  var x = 0, y = 0, z = 0;

  Homepage({
    Key key,
    @required this.data,
  }) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future processo() async {
    var p = widget.ps;
    widget.x = 2;
    widget.y = 3;
    widget.z = 5;

    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    setState(() {
      p.add('Mosquitto client connecting....');
    });
    client.connectionMessage = connMess;
    try {
      await client.connect();
    } on Exception catch (e) {
      setState(() {
        p.add('client exception - $e');
      });
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      setState(() {
        p.add('Mosquitto client connected');
      });
    } else {
      /// Use status here rather than state if you also want the broker return code.
      setState(() {
        p.add(
            'ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      });
      client.disconnect();
    }

    /// Ok, lets try a subscription
    // setState(() {
    //   p.add('EXAMPLE::Subscribing to the test/lol topic');
    // });
    // const String topic = 'test/lol'; // Not a wildcard topic
    // client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    // client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final MqttPublishMessage recMess = c[0].payload;
    //   final String pt =
    //       MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    //   setState(() {
    //     p.add('Notification: topic is <${c[0].topic}>, payload is <-- $pt -->');
    //     p.add('');
    //   });
    // });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    // client.published.listen((MqttPublishMessage message) {
    //   setState(() {
    //     p.add(
    //         'EXAMPLE::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    //   });
    // });

    /// Lets publish to our topic
    /// Use the payload builder rather than a raw buffer
    /// Our known topic to publish to
    // const String pubTopic = 'Dart/Mqtt_client/testtopic';
    // final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    // builder.addString('Hello/ola');

    /// Subscribe to it
    // setState(() {
    //   p.add('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
    // });
    // client.subscribe(pubTopic, MqttQos.exactlyOnce);

    /// Publish it
    // setState(() {
    //   p.add('EXAMPLE::Publishing our topic');
    // });
    // client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);

    /// Ok, we will now sleep a while, in this gap you will see ping request/response
    /// messages being exchanged by the keep alive mechanism.
    // setState(() {
    //   p.add('EXAMPLE::Sleeping....');
    // });
    // await MqttUtilities.asyncSleep(120);

    // /// Finally, unsubscribe and exit gracefully
    // setState(() {
    //   p.add('EXAMPLE::Unsubscribing');
    // });
    // client.unsubscribe(topic);

    // /// Wait for the unsubscribe message from the broker if you wish.
    // await MqttUtilities.asyncSleep(2);
    // setState(() {
    //   p.add('EXAMPLE::Disconnecting');
    // });
    // await MqttUtilities.asyncSleep(10);
    // client.disconnect();
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    setState(() {
      widget.ps.add('Subscription confirmed for topic $topic');
    });
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    setState(() {
      widget.ps.add('OnDisconnected client callback - Client disconnection');
    });
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      setState(() {
        widget.ps.add('OnDisconnected callback is solicited, this is correct');
      });
    }
  }

  /// The successful connect callback
  void onConnected() {
    widget.ps
        .add('OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    widget.ps.add('Ping response client callback invoked');
  }

  accelerometerEvent(AccelerometerEvent event) {
    print(event);
    setState(() {
      widget.ps.add(event);
    });
    String topic = widget.data;
    final MqttClientPayloadBuilder bd = MqttClientPayloadBuilder();
    bd.addString('Hello from mqtt_client');
    client.publishMessage(topic, MqttQos.exactlyOnce, bd.payload);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("MQTT"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: processo,
            ),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed("/");
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "x =${widget.x}, Y=${widget.y} , Z=${widget.z}  ",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(9.0),
              child: Text(
                "MqttTopic: ${widget.data}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            new Expanded(
              child: ListView.builder(
                itemCount: widget.ps.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  final item = widget.ps[index];
                  return Text(
                    item,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
