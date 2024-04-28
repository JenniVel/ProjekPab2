import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projek/screens/awalan/daftar_screen.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logo Screen',
      theme: ThemeData(),
      home: const MasukScreen(),
      initialRoute: '/',
      routes: {
        '/daftar': (context) => const DaftarScreen(),
        '/masuk': (context) => const MasukScreen(),
      },
    );
  }
}
