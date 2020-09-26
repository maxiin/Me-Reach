import 'package:MeReach/Adapters/server_repository.dart';
import 'package:MeReach/adapters/blocs/server_events.dart';
import 'package:MeReach/adapters/blocs/server_states.dart';
import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final ServerRepository serverRepository;

  ServerBloc({@required this.serverRepository}) : super(ServerInitial());

  @override
  Stream<ServerState> mapEventToState(ServerEvent event) async* {
    if (event is StatusRequest) {
      yield ServerLoading();
      try {
        final responseCode = await serverRepository.getStatus(event.server.url);
        event.server.status = responseCode;
        if (responseCode == 200) {
          event.server.online = true;
        } else {
          event.server.online = false;
        }
        yield ServerLoaded(server: event.server);
      } catch (_) {
        yield ServerFailure();
      }
    }
  }
}
