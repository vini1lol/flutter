import 'main.dart';
import 'package:flutter/material.dart';
import 'mqttdetails.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Mqttdetail());
      case '/second':
        return MaterialPageRoute(
            builder: (_) => Homepage(
                  data: args,
                ));
      default:
        return _erroRoute();
    }
  }

  static Route<dynamic> _erroRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Erro"),
        ),
        body: Center(
          child: Text("ERRO"),
        ),
      );
    });
  }
}
