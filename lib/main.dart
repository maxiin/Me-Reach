import 'package:MeReach/Adapters/server_repository.dart';
import 'package:MeReach/Drivers/server_api.dart';
import 'package:MeReach/adapters/list_repository.dart';
import 'package:MeReach/servers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'adapters/blocs/list_bloc.dart';
import 'adapters/blocs/server_bloc.dart';

void main() {
  final ServerRepository serverRepository = ServerRepository(
    serverApiClient: ServerApiClient(
      httpClient: http.Client(),
    ),
  );
  final ListRepository listRepository = ListRepository();

  runApp(MeReach(
      serverRepository: serverRepository, listRepository: listRepository));
}

class MeReach extends StatelessWidget {
  final ServerRepository serverRepository;
  final ListRepository listRepository;

  MeReach(
      {Key key, @required this.serverRepository, @required this.listRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MeReach',
        home: BlocProvider<ServerBloc>(
            create: (context) => ServerBloc(serverRepository: serverRepository),
            child: BlocProvider<ListBloc>(
              create: (context) => ListBloc(listRepository: listRepository),
              child: ServerPage(),
            )));
  }
}
