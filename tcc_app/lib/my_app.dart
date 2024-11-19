// import 'package:first_project_dio/model/user_session.dart';
// import 'package:first_project_dio/pages/home_page.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_app/screens/auth/login.dart';
import 'package:tcc_app/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/screens/home/cultivation/index.dart';
import 'package:tcc_app/screens/home/device/form.dart';
import 'package:tcc_app/screens/home/device/index.dart';
import 'package:tcc_app/screens/home/index.dart';
import 'package:tcc_app/screens/home/plants/form.dart';
import 'package:tcc_app/screens/home/plants/index.dart';
import 'package:tcc_app/screens/home/cultivation/form.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/plants': (context) => const PlantsPage(),
        '/plants/form': (context) => const PlantFormPage(),
        '/cultivation': (context) => const CultivationPage(),
        '/cultivation/form': (context) => const CultivationFormPage(),
        '/devices': (context) => const DevicePage(),
        '/devices/form': (context) => const DeviceFormPage()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      // home: UserSession.hasSession() ? const HomePage() : const Login(),
    );
  }
}
