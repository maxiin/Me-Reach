import 'package:MeReach/adapters/blocs/list_events.dart';
import 'package:MeReach/adapters/blocs/list_states.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../list_repository.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository listRepository;

  ListBloc({@required this.listRepository}) : super(ListInitial());

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is ServerInclude) {
      listRepository.addServer(event.server);
      yield ListAdded(server: event.server);
      //yield ListItemLoading(serverUrl: event.server.url);
      final status = await this.listRepository.getStatus(event.server.url);
      yield ListUpdate(serverUrl: event.server.url, newStatus: status);
    }
  }
}
