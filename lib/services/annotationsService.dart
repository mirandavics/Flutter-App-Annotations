import 'dart:async';
import 'package:flutter_app/common/api.dart';
import 'package:flutter_app/models/http-response.dart';
import 'package:http/http.dart' as http;

Future<HttpResponse> getAllAnnotations(token) async {
  HttpResponse response = await get('/notes?token=$token');
  return response;
}

Future<http.Response> saveAnnotation(id, data) async {
  var response;
  response = id != null ? await put('/notes/$id', data) : await post('/notes', data);

  return response;
}

Future<http.Response> deleteAnnotation(id, token) async {
  var response = await delete('/notes/$id?token=$token');

  return response;
}