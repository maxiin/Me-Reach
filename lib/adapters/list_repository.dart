import 'package:MeReach/drivers/local_storage.dart';
import 'package:MeReach/drivers/server_api.dart';
import 'package:MeReach/entities/server_entity.dart';
import 'package:flutter/widgets.dart';

class ListRepository {
  Map<String, Server> _servers = new Map();
  final ServerApiClient serverApiClient;
  LocalStorage _localStorage;

  ListRepository({@required this.serverApiClient}) {
    _localStorage = new LocalStorage();
  }

  Future<Map<String, Server>> getServers() async {
    final loaded = await _localStorage.readServers();
    if (loaded != null) {
      _servers = loaded;
    }
    return _servers;
  }

  bool addServer(Server server) {
    this._servers[server.url] = server;
    _localStorage.writeServers(_servers);
    return this._servers.containsKey(server.url);
  }

  void removeServer(String url) {
    this._servers.remove(url);
    _localStorage.writeServers(_servers);
  }

  Future<int> getStatus(String url) async {
    return serverApiClient.getStatus(url);
  }
}
