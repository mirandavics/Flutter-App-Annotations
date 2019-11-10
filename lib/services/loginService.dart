import 'dart:async';
import 'package:flutter_app/common/api.dart';
import 'package:http/http.dart' as http;

Future<http.Response> login(String email, String password) async {
  http.Response response = await registerLogin(email, password);
  return response;
}
