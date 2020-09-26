import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

abstract class ServerEvent {
  const ServerEvent();
}

class StatusRequest extends ServerEvent {
  final Server server;

  const StatusRequest({@required this.server});
}
