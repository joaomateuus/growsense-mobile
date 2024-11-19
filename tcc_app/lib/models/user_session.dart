// import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user.dart';

class UserSession {
  final String refresh;
  final dynamic access;
  final User user;

  UserSession(
      {required this.refresh, required this.access, required this.user});

  static UserSession? _currentSession;

  static void setSession(UserSession data) {
    _currentSession = data;
  }

  static UserSession? getSession() {
    return _currentSession;
  }

  static bool hasSession() {
    return _currentSession != null;
  }

  static void clearSession() {
    _currentSession = null;
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      refresh: json['refresh'],
      access: json['access'],
      user: User.fromJson(json['user']),
    );
  }
}
