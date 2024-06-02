import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projek/screens/awalan/landing_screen.dart';
import 'package:projek/screens/home/home_screen.dart';
import 'package:projek/tema/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:projek/tema/light_theme.dart';
import 'package:projek/tema/dark_theme.dart';
import 'package:projek/tema/theme_notifier.dart';
import 'package:projek/screens/awalan/daftar_screen.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';
import 'package:flutter_config/flutter_config.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FlutterConfig.loadEnvVariables();
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, child) {
          return MaterialApp(
            title: 'Logo Screen',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: theme.currentTheme,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User? user = snapshot.data;
                  return HomePage(
                    user: user,
                  );
                } else {
                  return const LandingScreen();
                }
              },
            ),
            initialRoute: '/',
            routes: {
              '/daftar': (context) => const DaftarScreen(),
              '/masuk': (context) => const MasukScreen(),
              '/tema': (context) => const TemaPage(),
            },
          );
        },
      ),
    );
  }
}
