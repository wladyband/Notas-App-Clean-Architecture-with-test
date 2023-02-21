import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:notas/app/data/http/failure.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';

class Http {
  final String _baseUrl;

  final Client _client;

  Http({
    required Client client,
    required String baseUrl,
  })  : _client = client,
        _baseUrl = baseUrl;
  Future<Either<HttpFailure, String>> request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameter = const {},
    Map<String, dynamic> body = const {},
  }) async {
    try {
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
      final bodyString = jsonEncode(body);
      switch (method) {
        case HttpMethod.get:
          response = await _client.get(url);
          break;
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
          print('VALOR $response');
          break;
        case HttpMethod.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
      }
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(response.body);
      }
      return Either.left(
        HttpFailure(statusCode: statusCode),
      );
    } catch (erro) {
      if (erro is SocketException || erro is ClientException) {
        return Either.left(
          HttpFailure(exception: NetworkException()),
        );
      }
      return Either.left(
        HttpFailure(exception: erro),
      );
    }
  }
}
