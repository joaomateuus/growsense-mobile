import 'package:flutter/material.dart';
import 'package:tcc_app/viewmodel/auth/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginViewmodel = LoginViewModelImpl();

  String username = '';
  String password = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void login(BuildContext context, String username, String password) async {
    loginViewmodel.username = username;
    loginViewmodel.password = password;

    final response = await loginViewmodel.login();

    if (response) {
      Navigator.pushNamed(context, '/home');
    } else {
      _showSnackBar("Não foi possível fazer o login");
    }
  }

  void handleSignUpRedirect() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Faz com que o Stack ocupe toda a tela
        children: [
          // Imagem de fundo
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/bg.jpg"), // Certifique-se do caminho correto
                fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
              ),
            ),
          ),
          Container(
            color: Colors.black
                .withOpacity(0.5), // Ajuste a opacidade conforme necessário
          ),
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
                        // const SizedBox(
                        //     height: 100), // Ajuste o espaçamento superior
                        Image.asset(
                          'assets/logo.png', // Certifique-se do caminho correto
                          height: 200, // Ajuste a altura conforme necessário
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            // color: Colors.blue.shade700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 13),
                            filled: true,
                            fillColor: Colors.white,
                            // border: OutlineInputBorder(),
                            // Fundo branco para legibilidade
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            // color: Colors.blue.shade700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 13),
                            filled: true,
                            fillColor:
                                Colors.white, // Fundo branco para legibilidade
                            // border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => login(
                                context,
                                _usernameController.text,
                                _passwordController.text),
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            handleSignUpRedirect();
                          },
                          child: const Text(
                            'Registe-se',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            // Implement forgot password functionality
                          },
                          child: const Text(
                            'Esqueceu a senha ?',
                            style: TextStyle(color: Colors.white),
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
