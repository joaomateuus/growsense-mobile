import 'dart:convert';
import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user_session.dart';
import 'package:tcc_app/services/api_service.dart';

class BaseService<T> {
  T? data;
  Map<String, dynamic>? errors;

  BaseService({this.data, this.errors});
}

class UserService {
  final ApiService apiService = ApiService();

  Future<bool> createUser(User userData) async {
    final response = await apiService.post(
      '/api/users/',
      {
        'email': userData.email,
        'username': userData.username,
        'password': userData.password ?? '',
      },
    );

    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserSession?> login(String username, String password) async {
    final response = await apiService.post(
      '/api/token/',
      {
        'username': username,
        'password': password,
      },
    );

    if (response != null) {
      final parsedJson = jsonDecode(response.body);
      final userSession = UserSession.fromJson(parsedJson);

      UserSession.setSession(userSession);
      return userSession;
    } else {
      return null;
    }
  }
}
