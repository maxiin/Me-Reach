import 'dart:async';
import 'dart:io';

// import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

abstract class BaseApi {
  Future<int> getStatus(String url);
}

class ServerApiClient implements BaseApi {
  final Client httpClient;

  ServerApiClient({@required this.httpClient});

  @override
  Future<int> getStatus(String url) async {
    if (!url.startsWith('http://') || !url.startsWith('https://')) {
      // using http not https for compatibility;
      url = 'http://' + url;
    }

    Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 5));
      if (response == null) {
        return 408;
      }
    } on TimeoutException catch (_) {
      return 408;
    } on SocketException catch (_) {
      return 0;
    }
    return response.statusCode;
  }
}
