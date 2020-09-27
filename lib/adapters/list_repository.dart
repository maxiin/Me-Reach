import 'package:MeReach/drivers/server_api.dart';
import 'package:MeReach/entities/server_entity.dart';
import 'package:flutter/widgets.dart';

class ListRepository {
  Map<String, Server> _servers = new Map();
  final ServerApiClient serverApiClient;

  ListRepository({@required this.serverApiClient});

  Map<String, Server> getServers() {
    return _servers;
  }

  Map<String, Server> addServer(Server server) {
    this._servers[server.name] = server;
    return _servers;
  }

  Future<int> getStatus(String url) async {
    return serverApiClient.getStatus(url);
  }
}
