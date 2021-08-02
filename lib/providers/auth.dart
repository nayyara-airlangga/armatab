import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirationDate;
  String _userID;
  Timer _authTimer;

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
      _autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userID': _userID,
        'expirationDate': _expirationDate.toIso8601String(),
      });
      preferences.setString('userData', userData);
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

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expirationDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timeUntilExpiration =
        _expirationDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeUntilExpiration), logout);
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expirationDate = DateTime.parse(extractedUserData['expirationDate']);

    if (expirationDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userID = extractedUserData['userID'];
    _expirationDate = expirationDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
