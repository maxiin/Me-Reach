import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

abstract class ListState {
  const ListState();
}

class ListInitial extends ListState {}

class ListAdded extends ListState {
  final Server server;

  const ListAdded({@required this.server});
}

class ListUpdate extends ListState {
  final String serverUrl;
  final int newStatus;

  const ListUpdate({@required this.serverUrl, @required this.newStatus});
}

class ListItemLoading extends ListState {
  final String serverUrl;

  const ListItemLoading({@required this.serverUrl});
}
