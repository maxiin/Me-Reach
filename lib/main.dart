import 'package:MeReach/adapters/blocs/timer_bloc.dart';
import 'package:MeReach/adapters/list_repository.dart';
import 'package:MeReach/servers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'adapters/blocs/list_bloc.dart';
import 'drivers/server_api.dart';
import 'drivers/ticker.dart';

void main() {
  final ListRepository listRepository = ListRepository(
    serverApiClient: ServerApiClient(
      httpClient: http.Client(),
    ),
  );
  final Ticker ticker = Ticker();

  runApp(MeReach(listRepository: listRepository, ticker: ticker));
}

class MeReach extends StatelessWidget {
  // final ServerRepository serverRepository;
  final ListRepository listRepository;
  final Ticker ticker;

  MeReach({Key key, @required this.listRepository, @required this.ticker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MeReach',
        home: BlocProvider<TimerBloc>(
          create: (context) => TimerBloc(ticker: ticker),
          child: BlocProvider<ListBloc>(
            create: (context) => ListBloc(listRepository: listRepository),
            child: ServerPage(),
          ),
        ));
  }
}
