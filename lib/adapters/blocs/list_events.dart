import 'package:MeReach/entities/server_entity.dart';

abstract class ListEvent {
  const ListEvent();
}

class ServerInclude extends ListEvent {
  final Server server;

  const ServerInclude({this.server});
}

class InitEvent extends ListEvent {
  final Map<String, Server> servers;

  const InitEvent({this.servers});
}
