import 'dart:async';

import 'package:MeReach/Drivers/server_api.dart';
import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

class ListRepository {
  List<Server> _servers = [];

  List<Server> getServers() {
    return _servers;
  }

  List<Server> addServer(Server server) {
    this._servers.add(server);
    return _servers;
  }
}
