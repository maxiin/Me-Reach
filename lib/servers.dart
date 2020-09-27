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

  @override
  Widget build(BuildContext context) {
    Map<String, Server> _servers = new Map();

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
          title: Text('Me Reach'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final res = await _showDialog();
            if (res != null) {
              try {
                final obj = jsonDecode(res);
                final Server srv =
                    new Server(name: obj['name'], url: obj['url']);
                BlocProvider.of<ListBloc>(context)
                    .add(ServerInclude(server: srv));
              } catch (_) {}
            }
          },
        ),
        body: BlocBuilder<ListBloc, ListState>(builder: (context, state) {
          List<Widget> children = [];
          if (state is ListLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ListInitial) {
            if (state.servers != null && _servers.length == 0) {
              _servers = state.servers;
            }
          }
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
            String statusText = element.status.toString();

            if (element.loading) {
              cardContent = [CircularProgressIndicator()];
            } else {
              if (element.status == 200) {
                statusText = "Online";
                statusColor = Colors.greenAccent;
              } else if (element.status == 0) {
                statusText = "Offline";
                statusColor = Colors.redAccent;
              } else {
                statusText = "Com Erro";
                statusColor = Colors.amberAccent;
              }
              cardContent = [
                Text(element.name),
                SizedBox(
                  height: 16,
                ),
                Text(
                  statusText,
                  style: TextStyle(fontSize: 20),
                )
              ];
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
          return ListView(children: children);
        }));
  }
}
