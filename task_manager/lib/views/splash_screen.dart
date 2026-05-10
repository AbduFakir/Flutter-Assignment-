import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/session_service.dart';
import 'auth_gate.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ─────────────────────────────────────────────────────────────

  // Logo card: scale + fade in
  late final AnimationController _logoCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // Logo card subtle float
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatOffset;

  // Text block: slide up + fade in
  late final AnimationController _textCtrl;
  late final Animation<double> _textSlide;
  late final Animation<double> _textFade;

  // Bottom section: fade in
  late final AnimationController _bottomCtrl;
  late final Animation<double> _bottomFade;

  // Spinner arc rotation
  late final AnimationController _spinCtrl;

  // Dots pulse
  late final AnimationController _dotsCtrl;

  @override
  void initState() {
    super.initState();

    // ── Logo ──────────────────────────────────────────────────────────────────
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.4, end: 1.0));
    _logoFade = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));

    // ── Float ─────────────────────────────────────────────────────────────────
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _floatOffset = CurvedAnimation(
      parent: _floatCtrl,
      curve: Curves.easeInOut,
    ).drive(Tween(begin: -6.0, end: 6.0));

    // ── Text ──────────────────────────────────────────────────────────────────
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textSlide = CurvedAnimation(
      parent: _textCtrl,
      curve: Curves.easeOutCubic,
    ).drive(Tween(begin: 28.0, end: 0.0));
    _textFade = CurvedAnimation(
      parent: _textCtrl,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));

    // ── Bottom ────────────────────────────────────────────────────────────────
    _bottomCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bottomFade = CurvedAnimation(
      parent: _bottomCtrl,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));

    // ── Spinner ───────────────────────────────────────────────────────────────
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // ── Dots ──────────────────────────────────────────────────────────────────
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Small initial pause so the background renders first.
    await Future.delayed(const Duration(milliseconds: 200));
    await _logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    await _textCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 150));
    await _bottomCtrl.forward();

    // Check local session flag while animations play.
    final isLoggedIn = await SessionService().isLoggedIn();

    // Hold on splash for a minimum total feel.
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    if (isLoggedIn) {
      // Session flag set — go straight to the app shell.
      // Firebase Auth will also have its token refreshed in the background.
      Get.off(
        () => const MainShell(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 600),
      );
    } else {
      // No local session — let AuthGate decide (login or home).
      Get.off(
        () => const AuthGate(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _floatCtrl.dispose();
    _textCtrl.dispose();
    _bottomCtrl.dispose();
    _spinCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0EFFA),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [_backgroundGlow(size), _centreContent(), _bottomSection()],
        ),
      ),
    );
  }

  // ── Background radial glow ───────────────────────────────────────────────────

  Widget _backgroundGlow(Size size) {
    return Positioned(
      top: size.height * 0.15,
      left: size.width * 0.5 - 180,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF4A32E8).withValues(alpha: 0.08),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // ── Centre: logo + text ──────────────────────────────────────────────────────

  Widget _centreContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _animatedLogo(),
          const SizedBox(height: 32),
          _animatedText(),
        ],
      ),
    );
  }

  Widget _animatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoCtrl, _floatCtrl]),
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatOffset.value),
        child: FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(scale: _logoScale, child: _logoCard()),
        ),
      ),
    );
  }

  Widget _logoCard() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A32E8).withValues(alpha: 0.14),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.9),
            blurRadius: 8,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Image.asset('assets/taskFlowLogo.png', fit: BoxFit.contain),
    );
  }

  Widget _animatedText() {
    return AnimatedBuilder(
      animation: _textCtrl,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _textSlide.value),
        child: Opacity(
          opacity: _textFade.value,
          child: Column(
            children: [
              const Text(
                'TaskFlow',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Orchestrate your day with effortless\nprecision.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8D8A9D),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom: spinner + label + dots ───────────────────────────────────────────

  Widget _bottomSection() {
    return Positioned(
      bottom: 52,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _bottomCtrl,
        builder: (_, __) => Opacity(
          opacity: _bottomFade.value,
          child: Column(
            children: [
              _arcSpinner(),
              const SizedBox(height: 18),
              const Text(
                'SYNCHRONIZING WORKSPACE',
                style: TextStyle(
                  color: Color(0xFFB1ADBE),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 10),
              _pulseDots(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _arcSpinner() {
    return AnimatedBuilder(
      animation: _spinCtrl,
      builder: (_, __) => SizedBox(
        width: 36,
        height: 36,
        child: CustomPaint(
          painter: _ArcSpinnerPainter(
            progress: _spinCtrl.value,
            color: const Color(0xFF4A32E8),
          ),
        ),
      ),
    );
  }

  Widget _pulseDots() {
    return AnimatedBuilder(
      animation: _dotsCtrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Stagger each dot by 0.2 of the animation cycle.
            final t = (_dotsCtrl.value + i * 0.25).clamp(0.0, 1.0);
            final opacity = 0.25 + 0.75 * t;
            final scale = 0.7 + 0.3 * t;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A32E8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Arc spinner painter ───────────────────────────────────────────────────────

class _ArcSpinnerPainter extends CustomPainter {
  const _ArcSpinnerPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Track circle.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Spinning arc — 270° sweep rotating around the circle.
    const sweepAngle = 1.5; // radians (~86°)
    final startAngle = progress * 2 * 3.14159265 * 2 - 3.14159265 / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcSpinnerPainter old) => old.progress != progress;
}
