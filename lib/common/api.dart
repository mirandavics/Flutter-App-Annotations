import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_app/models/LoginPayload.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/http-response.dart';

const String _baseUrl = "https://services.premiersoft.net/hero";
var token;

getToken() {
  return token;
}

Future<HttpResponse> get(String serviceName) async {
  HttpResponse responseBody = new HttpResponse();
  http.Response response;

  try {
    response = await http.get(_baseUrl + serviceName,
        headers: {
            'content-type': 'application/json'
        }
    );

    responseBody.status = response.statusCode;

    if (response.statusCode == 200 || response.statusCode == 204)
      responseBody.data = response.body;

  } catch (e) {
    responseBody.message = 'Erro';
  }

  return responseBody;
}

Future<http.Response> post(String serviceName, Map data) async {
  http.Response response;

  try {
    response = await http.post(_baseUrl + serviceName,
      body: jsonEncode(data),
      headers: {
        'content-type': 'application/json'
      }
    );
  } catch (e) {
    print(e);
  }

  return response;
}

Future<http.Response> put(String serviceName, Map data) async {
  http.Response response;

  try {
    response = await http.put(_baseUrl + serviceName,
      body: jsonEncode(data),
      headers: {
        'content-type': 'application/json'
      }
    );
  } catch (e) {
    print(e);
  }

  return response;
}

Future<http.Response> delete(String serviceName) async {
  http.Response response;

  try {
    response = await http.delete(_baseUrl + serviceName,
        headers: {
          'Content-Type': 'application/json'
        }
    );

  } catch (e) {
    print(e);
  }

  return response;
}

Future<http.Response> registerLogin(String email, String password) async {
  var payload = new LoginPayload();
  payload.username = email;
  payload.password = md5.convert(utf8.encode(password)).toString();

  var responseJson;

  http.Response response = await http.post(_baseUrl + "/login",
    body: jsonEncode(payload.toMap()),
    headers: {
      'content-type': 'application/json'
    }
  );

  if(response.statusCode == 200) {
    responseJson = json.decode(response.body);
    token = responseJson["token"];
  }

  return response;
}