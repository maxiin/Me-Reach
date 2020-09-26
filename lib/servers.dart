import 'dart:convert';

import 'package:MeReach/adapters/blocs/server_bloc.dart';
import 'package:MeReach/adapters/blocs/server_events.dart';
import 'package:MeReach/adapters/blocs/server_states.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'adapters/blocs/list_bloc.dart';
import 'adapters/blocs/list_events.dart';
import 'adapters/blocs/list_states.dart';
import 'entities/server_entity.dart';

class ServerPage extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final urlCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _showDialog() async {
      return await showDialog<String>(
        context: context,
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new TextField(
                        controller: nameCtrl,
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: 'name', hintText: 'eg. Google'),
                      ),
                      new TextField(
                        controller: urlCtrl,
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: 'Url',
                            hintText: 'eg. http://google.com.br'),
                      ),
                    ],
                  ))
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('CREATE'),
                onPressed: () {
                  final name = nameCtrl.text;
                  final url = urlCtrl.text;
                  Navigator.pop(
                      context, jsonEncode({'name': name, 'url': url}));
                })
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Weather'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () async {
          //       final city = await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => CitySelection(),
          //         ),
          //       );
          //       if (city != null) {
          //         BlocProvider.of<WeatherBloc>(context)
          //             .add(WeatherRequested(city: city));
          //       }
          //     },
          //   )
          // ],
        ),
        body: BlocBuilder<ListBloc, ListState>(builder: (context, state) {
          List<Widget> children = [];
          if (state is ListAdded) {
            state.servers.forEach((element) {
              children.add(Center(
                child: BlocBuilder<ServerBloc, ServerState>(
                  builder: (context, state) {
                    if (state is ServerInitial) {
                      BlocProvider.of<ServerBloc>(context)
                          .add(StatusRequest(server: element));
                    }
                    if (state is ServerLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ServerLoaded) {
                      final server = state.server;

                      return Column(
                        children: <Widget>[
                          Text(server.name),
                          Text(server.status.toString()),
                        ],
                      );
                    }
                    if (state is ServerFailure) {
                      return Text(
                        'Something went wrong!',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    return Text('');
                  },
                ),
              ));
            });
          }
          children.add(RaisedButton(
              child: Text('add'),
              onPressed: () async {
                final res = await _showDialog();
                if (res != null) {
                  try {
                    final obj = jsonDecode(res);
                    final Server srv =
                        new Server(name: obj['name'], url: obj['url']);
                    BlocProvider.of<ListBloc>(context)
                        .add(ServerInclude(server: srv));
                  } catch (e) {
                    print(e);
                  }
                }
              }));
          return ListView(children: children);
        }));
  }
}
