import 'dart:async';

import 'package:MeReach/Drivers/server_api.dart';
import 'package:meta/meta.dart';

class ServerRepository {
  final ServerApiClient serverApiClient;

  ServerRepository({@required this.serverApiClient});

  Future<int> getStatus(String url) async {
    return serverApiClient.getStatus(url);
  }
}
