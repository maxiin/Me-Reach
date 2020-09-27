import 'package:MeReach/adapters/blocs/list_events.dart';
import 'package:MeReach/adapters/blocs/list_states.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../list_repository.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository listRepository;

  ListBloc({@required this.listRepository}) : super(ListLoading()) {
    init();
  }

  init() async {
    final servers = await this.listRepository.getServers();
    if (servers != null) {
      this.add(InitEvent(servers: servers));
    } else {
      this.add(InitEvent(servers: new Map()));
    }
  }

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is InitEvent) {
      yield ListInitial(servers: event.servers);
      for (final server in event.servers.values) {
        final status = await this.listRepository.getStatus(server.url);
        yield ListUpdate(serverUrl: server.url, newStatus: status);
      }
    }
    if (event is ServerInclude) {
      listRepository.addServer(event.server);
      yield ListAdded(server: event.server);
      final status = await this.listRepository.getStatus(event.server.url);
      yield ListUpdate(serverUrl: event.server.url, newStatus: status);
    }
    if (event is ServerUpdateAll) {
      for (String key in event.servers.keys) {
        yield ListItemLoading(serverUrl: key);
        final status = await this.listRepository.getStatus(key);
        yield ListUpdate(serverUrl: key, newStatus: status);
      }
    }
    if (event is ServerUpdate) {
      yield ListItemLoading(serverUrl: event.serverUrl);
      final status = await this.listRepository.getStatus(event.serverUrl);
      yield ListUpdate(serverUrl: event.serverUrl, newStatus: status);
    }
    if (event is ServerExclude) {
      listRepository.removeServer(event.serverUrl);
      yield ListRemove(serverUrl: event.serverUrl);
    }
  }
}
