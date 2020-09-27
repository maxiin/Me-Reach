import 'package:MeReach/adapters/list_repository.dart';
import 'package:MeReach/servers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'adapters/blocs/list_bloc.dart';
import 'drivers/server_api.dart';

void main() {
  final ListRepository listRepository = ListRepository(
    serverApiClient: ServerApiClient(
      httpClient: http.Client(),
    ),
  );

  runApp(MeReach(listRepository: listRepository));
}

class MeReach extends StatelessWidget {
  // final ServerRepository serverRepository;
  final ListRepository listRepository;

  MeReach({Key key, @required this.listRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MeReach',
        home: BlocProvider<ListBloc>(
          create: (context) => ListBloc(listRepository: listRepository),
          child: ServerPage(),
        ));
  }
}
