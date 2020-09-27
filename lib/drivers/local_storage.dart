import 'dart:convert';
import 'dart:io';

import 'package:MeReach/entities/server_entity.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/server.txt');
  }

  String serverToJsonConvert(Map<String, Server> data) {
    Map<String, Object> saveReady = new Map();
    data.forEach((key, value) {
      saveReady[value.url] = {'url': value.url, 'name': value.name};
    });
    return jsonEncode(saveReady);
  }

  Map<String, Server> jsonToServerConvert(String json) {
    final Map<String, dynamic> dynamicObjJson = jsonDecode(json);
    Map<String, Server> returnValue = new Map();
    dynamicObjJson.forEach((key, value) {
      if (value['url'] != null && value['name'] != null) {
        returnValue[value['url']] =
            new Server(url: value['url'], name: value['name']);
      }
    });
    return returnValue;
  }

  Future<File> writeServers(Map<String, Server> data) async {
    final dataString = serverToJsonConvert(data);
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(dataString);
  }

  Future<Map<String, Server>> readServers() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return jsonToServerConvert(contents);
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }
}
