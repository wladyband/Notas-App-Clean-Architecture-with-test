import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:notas/app/domain/either.dart';
import 'package:notas/app/domain/models/enums.dart';


part 'failure.dart';

part 'logs.dart';

part 'parse_response_body.dart';

class Http {
  final String _baseUrl;
  final Client _client;
  String? idUserFind;
  String? alreadyContainsIdUser;
  String? token;
  Map? findId;

  Http({
    required Client client,
    required String baseUrl,
    String? token,
  })
      : _client = client,
        token = token,
        _baseUrl = baseUrl;

  get defaultValue => null;

  Future<Either<HttpFailure, Right>> request<Right>(String path, {
    Right Function(dynamic responseBody)? onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameter = const {},
    Map<String, dynamic> body = const {},
    Right Function(List<Map<String, dynamic>> responseBody)? onSuccessCustom,
  }) async {
    Map<String, dynamic> logs = {};
    StackTrace? stackTraceFull;
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
        'Authorization': 'Bearer $token',
        ...headers,
      };
      late final Response response;
      final bodyString = jsonEncode(body);

      logs = {
        'url': url.toString(),
        'method': method.name,
        'body': body,
      };

      await Future.delayed(const Duration(milliseconds: 500));
      switch (method) {
        case HttpMethod.get:
          response = await _client.get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          print('VALOR $response.body');
          break;
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
          print('VALOR $response.body');
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

//await Future.delayed(Duration(milliseconds:5000));
      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(
        response.body,
      );

      if (responseBody is Map) {
        findId = responseBody['user'];
        if (findId != null) {
          alreadyContainsIdUser = responseBody['id'];
          if ( alreadyContainsIdUser  == null) {
            idUserFind = findId!.values.first['id'];
            token = responseBody['user']['token'];
          }
        }
      }

      logs = {
        ...logs,
        'startTime': DateTime.now().toString(),
        'statusCode': statusCode,
        'responseBody': responseBody,
      };

      responseBody;

      if (statusCode >= 200 && statusCode < 300) {
        if (responseBody is Map) {
          return Either.right(
            onSuccess!(responseBody),
          );
        }

        if (responseBody is List<dynamic>) {
          final List<Map<String, dynamic>> responseBodyList =
          responseBody.map((item) => item as Map<String, dynamic>).toList();
          int value = responseBodyList.length;

          if (value != 0) {
            return Either.right(onSuccessCustom!(responseBodyList));
          }
        }
        /* else {
          return Either.right(
            onSuccessCustom!(responseBody),
          );
        }*/
      }
      return Either.left(
        HttpFailure(statusCode: statusCode),
      );
    } catch (erro, strackTrace) {
      stackTraceFull = strackTrace;
      logs = {
        ...logs,
        'exception': erro.runtimeType.toString(),
      };
      if (erro is SocketException || erro is ClientException) {
        logs = {
          ...logs,
          'exception': 'NetworkException',
        };
        return Either.left(
          HttpFailure(exception: NetworkException()),
        );
      }

      return Either.left(
        HttpFailure(exception: erro),
      );
    } finally {
      logs = {
        ...logs,
        'endTime': DateTime.now().toString(),
      };
      _printLogs(logs, stackTraceFull);
    }
  }

  String? getIdUser() {
    idUserFind!;
    return idUserFind!;
  }
}
