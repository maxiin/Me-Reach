import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

abstract class ListEvent {
  const ListEvent();
}

class ServerInclude extends ListEvent {
  final Server server;

  const ServerInclude({this.server});
}
