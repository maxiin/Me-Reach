// entity
import 'package:flutter/material.dart';

class Server {
  Server({@required this.url, @required this.name, this.color}) {}

  String url;
  String name;
  Color color = Colors.blueAccent;
  int status = 0;
  bool loading = true;
}
