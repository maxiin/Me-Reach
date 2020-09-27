import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

abstract class ListState {
  const ListState();
}

class ListUpdate extends ListState {
  final Map<String, Server> servers;

  const ListUpdate({@required this.servers});
}

class ListLoading extends ListState {}

class ListAdded extends ListState {
  final Server server;

  const ListAdded({@required this.server});
}

class ListItemUpdate extends ListState {
  final String serverUrl;
  final int newStatus;

  const ListItemUpdate({@required this.serverUrl, @required this.newStatus});
}

class ListRemove extends ListState {
  final String serverUrl;

  const ListRemove({@required this.serverUrl});
}

class ListItemLoading extends ListState {
  final String serverUrl;

  const ListItemLoading({@required this.serverUrl});
}
