import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _web_api = 'AIzaSyAldAv5wWKSvR3772cVdQNOdW2NlxjRNk8';

  Future<void> signUp(String email, String password) async {
    String endPoint =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_web_api';

    final url = Uri.parse(endPoint);

    final response = await http.post(url,
        body: json.encode({
          'email': email,
          "password": password,
          'returnSecureToken': true,
        }));

    print(json.decode(response.body));
    print(response.runtimeType);
  }
}
