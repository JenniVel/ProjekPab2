import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projek/tema/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:projek/screens/awalan/daftar_screen.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';
import 'package:projek/screens/awalan/landing_screen.dart';
import 'package:projek/screens/nav_pages/profile.dart';
import 'package:projek/tema/theme_notifier.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MaterialApp(
        title: 'Logo Screen',
        theme: ThemeData(),
        home: const PengaturanProfile(),
        initialRoute: '/',
        routes: {
          '/daftar': (context) => const DaftarScreen(),
          '/masuk': (context) => const MasukScreen(),
          '/tema': (context) => const TemaPage(),
        },
      ),
    );
  }
}
