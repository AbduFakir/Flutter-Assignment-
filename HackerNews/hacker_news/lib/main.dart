import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HackerNewsApp());
}

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Verdana',
        scaffoldBackgroundColor: const Color(0xFFF6F6EF),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6600)),
      ),
      home: const SplashScreen(),
    );
  }
}
