import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:holbegram/screens/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Méthode pour construire le widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holbegram',
      theme: ThemeData(),
      home: const LoginScreen(),
    );
  }
}
