import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

abstract class ListState {
  const ListState();
}

class ListInitial extends ListState {}

class ListAdded extends ListState {
  final List<Server> servers;

  const ListAdded({@required this.servers});
}
