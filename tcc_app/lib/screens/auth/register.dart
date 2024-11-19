import 'package:flutter/material.dart';
import 'package:tcc_app/viewmodel/auth/register_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registertViewModel = RegisterViewModelImpl();

  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  void handleSubmit(String username, String email, String confirmPassword,
      String password) async {
    if (confirmPassword != password) {
      print('Passwords do not match');
      return;
    }

    registertViewModel.username = username;
    registertViewModel.email = email;
    registertViewModel.password = password;

    bool was_successfull = await registertViewModel.createUser();

    if (was_successfull) {
      print("Usuario cadastrado com sucesso");
    } else {
      print("Não foi possivel cadastrar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Define a altura do AppBar
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Cadastro'),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand, // Faz com que o Stack ocupe toda a tela
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          constraints.maxWidth > 600 ? 400 : double.infinity,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 40),
                        TextField(
                          controller: usernameController,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            // color: Colors.blue.shade700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                            // border: OutlineInputBorder(),
                            // Fundo branco para legibilidade
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            // color: Colors.blue.shade700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                            // border: OutlineInputBorder(),
                            // Fundo branco para legibilidade
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(fontSize: 13),
                            fillColor:
                                Colors.white, // Fundo branco para legibilidade
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: confirmPasswordController,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Confirme Senha',
                            labelStyle: TextStyle(fontSize: 13),
                            fillColor: Colors.white,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => handleSubmit(
                                usernameController.text,
                                emailController.text,
                                confirmPasswordController.text,
                                passwordController.text),
                            child: const Text('Cadastrar-se'),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
