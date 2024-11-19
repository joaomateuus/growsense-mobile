import 'package:tcc_app/models/user.dart';
import 'package:tcc_app/repository/auth/user_repository.dart';

abstract class RegisterViewModel {
  Future<bool> createUser();
  void resetFields();
}

class RegisterViewModelImpl extends RegisterViewModel {
  String email = '';
  String username = '';
  String password = '';

  final userRepository = UserRepository();

  @override
  void resetFields() {
    email = '';
    username = '';
    password = '';
  }

  @override
  Future<bool> createUser() async {
    User registerPayload = User(
      email: email,
      username: username,
      password: password,
    );

    final response = await userRepository.createUser(registerPayload);
    return response ? true : false;
  }
}
