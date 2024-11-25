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
// import 'package:tcc_app/screens/home/device_data/index.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/plants': (context) => const PlantsPage(),
        '/plants/form': (context) => const PlantFormPage(),
        '/cultivation': (context) => const CultivationPage(),
        '/cultivation/form': (context) => const CultivationFormPage(),
        // '/cultivation/device_data/': (context) => const PlantDataPage(),
        '/devices': (context) => const DevicePage(),
        '/devices/form': (context) => const DeviceFormPage()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
