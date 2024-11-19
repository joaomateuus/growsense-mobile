import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/models/user_session.dart';
import 'package:tcc_app/services/user_service.dart';

class UserRepository {
  final userService = UserService();

  Future<bool> createUser(User userData) async {
    final response = await userService.createUser(userData);

    return response ? true : false;
  }

  Future<UserSession?> login(String username, String password) async {
    final response = await userService.login(username, password);

    return response != null ? response : null;
  }
}
