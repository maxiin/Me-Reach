import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

abstract class BaseApi {
  Future<int> getStatus(String url);
}

class ServerApiClient implements BaseApi {
  final http.Client httpClient;

  ServerApiClient({@required this.httpClient});

  @override
  Future<int> getStatus(String url) async {
    if (!url.startsWith('http://') || !url.startsWith('https://')) {
      // using http not https for compatibility;
      url = 'http://' + url;
    }

    http.Response request;
    try {
      request = await this.httpClient.get(url);
    } catch (_) {
      return 0;
    }
    return request.statusCode;
  }
}
