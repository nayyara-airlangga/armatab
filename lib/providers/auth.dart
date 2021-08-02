import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirationDate;
  String _userID;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expirationDate != null &&
        _expirationDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userID {
    return _userID;
  }

  Future<void> _authenticate({
    String email,
    String password,
    String urlSegment,
  }) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD2DyJtr5AxAw-CoUUXem42BROeLML62k8',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expirationDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp({
    String email,
    String password,
  }) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: 'signUp',
    );
  }

  Future<void> login({
    String email,
    String password,
  }) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: 'signInWithPassword',
    );
  }

  void logout() {
    _token = null;
    _userID = null;
    _expirationDate = null;
    notifyListeners();
  }
}
