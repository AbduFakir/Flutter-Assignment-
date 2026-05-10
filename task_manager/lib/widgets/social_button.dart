import 'package:flutter/material.dart';

const _text = Color(0xFF252B3A);
const _border = Color(0xFFE0DDEC);

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.mark,
    required this.onPressed,
  });

  final String label;
  final Widget mark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _text,
          side: const BorderSide(color: _border, width: 1.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [mark, const SizedBox(width: 8), Text(label)],
          ),
        ),
      ),
    );
  }
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFFF0EEF6), width: 1),
      ),
      child: Container(
        width: 5,
        height: 5,
        decoration: const BoxDecoration(
          color: Color(0xFFF4A340),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class AppleMark extends StatelessWidget {
  const AppleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'iOS',
      style: TextStyle(
        color: _text,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
    );
  }
}
