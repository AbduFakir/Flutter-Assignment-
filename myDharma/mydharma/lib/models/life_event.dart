import 'package:flutter/material.dart';

class LifeEvent {
  const LifeEvent({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.duration,
    required this.price,
    required this.icon,
    required this.gradient,
    required this.inclusions,
  });

  final String title;
  final String subtitle;
  final DateTime date;
  final String duration;
  final String price;
  final IconData icon;
  final List<Color> gradient;
  final List<String> inclusions;
}
