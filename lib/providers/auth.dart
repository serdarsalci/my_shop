import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/http_exception.dart';

import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  String _apiKey = dotenv.env['API_KEY'];

  // final _apiKey = 'AIzaSyAldAv5wWKSvR3772cVdQNOdW2NlxjRNk8';

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final endPoint =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_apiKey';

    final url = Uri.parse(endPoint);

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            "password": password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }

    // print(response.body.toString());
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
