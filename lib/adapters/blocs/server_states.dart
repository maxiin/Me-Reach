import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';

abstract class ServerState {
  const ServerState();
}

class ServerInitial extends ServerState {}

class ServerLoading extends ServerState {}

class ServerLoaded extends ServerState {
  final Server server;

  const ServerLoaded({@required this.server});
}

class ServerFailure extends ServerState {}
