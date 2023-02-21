import 'package:http/http.dart';
import 'package:notas/app/domain/models/enums.dart';

class Http {
  final String _baseUrl;
  final String _apiKey;
  final Client _client;

  Http(this._baseUrl, this._apiKey, this._client);
  request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameter = const {},
  }) async {
    Uri url = Uri.parse(
      path.startsWith('http') ? path : '$_baseUrl$path',
    );
    if (queryParameter.isNotEmpty) {
      url = url.replace(
        queryParameters: queryParameter,
      );
    }
    headers = {
      'Content-Type': 'application/json',
      ...headers,
    };
    late final Response response;
    switch (method) {
      case HttpMethod.get:
        response = await _client.get(url);
        break;
      case HttpMethod.post:
        response = await _client.post(
          url,
          headers: headers,
        );
        break;
      case HttpMethod.patch:
        response = await _client.patch(
          url,
          headers: headers,
        );
        break;
      case HttpMethod.delete:
        response = await _client.delete(
          url,
          headers: headers,
        );
        break;
      case HttpMethod.put:
        response = await _client.put(
          url,
          headers: headers,
        );
        break;
    }
  }
}
