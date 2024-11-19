import 'package:tcc_app/models/user_session.dart';
import 'package:tcc_app/repository/auth/user_repository.dart';

abstract class LoginViewModel {
  Future<bool> login();
  void resetFields();
}

class LoginViewModelImpl extends LoginViewModel {
  String username = '';
  String password = '';

  final userRepository = UserRepository();

  @override
  void resetFields() {
    username = '';
    password = '';
  }

  @override
  Future<bool> login() async {
    final response = await userRepository.login(username, password);

    if (response != null) {
      UserSession.setSession(response);

      return true;
    } else {
      return false;
    }
  }
}
