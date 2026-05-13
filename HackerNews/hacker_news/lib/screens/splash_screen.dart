import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // Lock to portrait for splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF6600),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2000), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF6600),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFF6600),
        body: FadeTransition(
          opacity: _fadeIn,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Y Logo — pixel-style white square with bold Y
                _YLogo(),
                const SizedBox(height: 24),
                // App name
                const Text(
                  'Hacker News Reader',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontFamily: 'Verdana',
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'Read. Discuss. Explore.',
                  style: TextStyle(
                    color: Color(0xFFFFD0A0),
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontFamily: 'Verdana',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pixel-faithful recreation of the Y Combinator / Hacker News logo.
/// White square, bold orange "Y" — no images needed.
class _YLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      color: Colors.white,
      child: const Center(
        child: Text(
          'Y',
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontSize: 72,
            fontWeight: FontWeight.bold,
            fontFamily: 'Verdana',
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
