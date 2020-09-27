import 'package:MeReach/entities/server_entity.dart';

abstract class ListEvent {
  const ListEvent();
}

class ServerInclude extends ListEvent {
  final Server server;

  const ServerInclude({this.server});
}

class ServerExclude extends ListEvent {
  final String serverUrl;

  const ServerExclude({this.serverUrl});
}

class ServerUpdate extends ListEvent {
  final String serverUrl;

  const ServerUpdate({this.serverUrl});
}

class ServerUpdateAll extends ListEvent {
  final Map<String, Server> servers;

  const ServerUpdateAll({this.servers});
}

class InitEvent extends ListEvent {
  final Map<String, Server> servers;

  const InitEvent({this.servers});
}
