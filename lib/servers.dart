import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'adapters/blocs/list_bloc.dart';
import 'adapters/blocs/list_events.dart';
import 'adapters/blocs/list_states.dart';
import 'entities/server_entity.dart';

class ServerPage extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final urlCtrl = TextEditingController();
  final Map<String, Server> _servers = new Map();

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
          print(state);
          print(_servers.length);
          if (state is ListAdded) {
            _servers[state.server.url] = state.server;
          }
          if (state is ListItemLoading) {
            try {
              final found = _servers[state.serverUrl];
              found.loading = true;
              _servers[state.serverUrl] = found;
            } catch (_) {}
          }
          if (state is ListUpdate) {
            try {
              final found = _servers[state.serverUrl];
              found.status = state.newStatus;
              found.loading = false;
              _servers[state.serverUrl] = found;
            } catch (_) {}
          }
          _servers.values.forEach((element) {
            List<Widget> cardContent;
            Color statusColor = Colors.blueAccent;
            if (element.loading) {
              cardContent = [CircularProgressIndicator()];
            } else {
              cardContent = [
                Text(element.name),
                SizedBox(
                  height: 16,
                ),
                Text(
                  element.status.toString(),
                  style: TextStyle(fontSize: 20),
                )
              ];
              if (element.status == 200) {
                statusColor = Colors.greenAccent;
              } else if (element.status == 0) {
                statusColor = Colors.redAccent;
              } else {
                statusColor = Colors.yellowAccent;
              }
            }

            children.add(Card(
              child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                        child: Container(
                          color: statusColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 0, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cardContent),
                      )
                    ],
                  )),
            ));
          });
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
