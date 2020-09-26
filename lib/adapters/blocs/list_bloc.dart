import 'dart:convert';

import 'package:MeReach/Adapters/server_repository.dart';
import 'package:MeReach/adapters/blocs/list_events.dart';
import 'package:MeReach/adapters/blocs/list_states.dart';
import 'package:MeReach/adapters/blocs/server_events.dart';
import 'package:MeReach/adapters/blocs/server_states.dart';
import 'package:MeReach/entities/server_entity.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../list_repository.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ListRepository listRepository;

  ListBloc({@required this.listRepository}) : super(ListInitial());

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is ServerInclude) {
      List<Server> list = listRepository.addServer(event.server);
      yield ListAdded(servers: list);
    }
  }
}
