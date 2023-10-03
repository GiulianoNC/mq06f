import 'package:flutter/material.dart';
import 'package:mq06f/Herramientas/SplashScreen.dart';
import 'package:mq06f/Layouts/Primera.dart';
import 'package:mq06f/Layouts/login_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => const SplashScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/congrats': ( context) => Primera(),
      },
    );
  }
}
