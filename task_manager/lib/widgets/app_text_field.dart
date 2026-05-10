import 'package:flutter/material.dart';

const _primary = Color(0xFF4A32E8);
const _muted = Color(0xFF8D8A9D);
const _border = Color(0xFFE0DDEC);
const _text = Color(0xFF252B3A);

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: _primary,
        style: const TextStyle(
          color: _text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFD4D1DF),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
          prefixIcon: Icon(icon, color: _muted, size: 21),
          suffixIcon: trailing,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: _border_(color: _border),
          focusedBorder: _border_(color: _primary),
          border: _border_(color: _border),
        ),
      ),
    );
  }

  static OutlineInputBorder _border_({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: BorderSide(color: color, width: 1.4),
    );
  }
}
