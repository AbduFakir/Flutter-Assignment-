import 'package:flutter/material.dart';

import '../../models/home_life_event.dart';
import '../../models/life_event.dart';

abstract final class MockData {
  static const homeLifeEvents = <HomeLifeEvent>[
    HomeLifeEvent(
      title: 'Welcoming a Baby',
      description: 'Every ritual from conception to naming, guided with love.',
      iconAsset: 'assets/home/welcomeBabyIcon.png',
    ),
    HomeLifeEvent(
      title: 'Marriage & Union',
      description: 'Sacred ceremonies that unite two souls in Dharmic tradition.',
      iconAsset: 'assets/home/marriageUnionIcon.png',
    ),
    HomeLifeEvent(
      title: 'New Property',
      description: 'Bless your new dwelling from foundation to first step.',
      iconAsset: 'assets/home/newPropertyIcon.png',
    ),
    HomeLifeEvent(
      title: 'Remembering Loved Ones',
      description: 'Sacred rites that bring peace to those who have passed.',
      iconAsset: 'assets/home/remLovedOnesIcon.png',
    ),
    HomeLifeEvent(
      title: 'Life Milestones',
      description: "Mark life's important transitions the sacred way.",
      iconAsset: 'assets/home/lifeMylestoneIcon.png',
    ),
    HomeLifeEvent(
      title: 'Community Events',
      description: 'Sacred gatherings that bring your community together.',
      iconAsset: 'assets/home/communityEventsIcon.png',
    ),
  ];

  static final featuredEvents = <LifeEvent>[
    LifeEvent(
      title: 'Griha Pravesh',
      subtitle: 'Auspicious home blessing',
      date: DateTime(2026, 5, 18),
      duration: '45 min',
      price: '₹2,499',
      icon: Icons.home_rounded,
      gradient: const [Color(0xFF6E2453), Color(0xFFB05B72)],
      inclusions: const [
        'Personalized sankalpam',
        'Priest-guided puja sequence',
        'Digital checklist and muhurat notes',
      ],
    ),
    LifeEvent(
      title: 'Satyanarayan Katha',
      subtitle: 'Prosperity and gratitude ritual',
      date: DateTime(2026, 5, 22),
      duration: '60 min',
      price: '₹1,899',
      icon: Icons.auto_stories_rounded,
      gradient: const [Color(0xFF7A531A), Color(0xFFD8AD49)],
      inclusions: const [
        'Complete vrat katha',
        'Offerings preparation guide',
        'Family participation prompts',
      ],
    ),
    LifeEvent(
      title: 'Naamkaran',
      subtitle: 'Sacred naming ceremony',
      date: DateTime(2026, 6, 3),
      duration: '50 min',
      price: '₹2,199',
      icon: Icons.child_care_rounded,
      gradient: const [Color(0xFF4C5878), Color(0xFFA7B2D7)],
      inclusions: const [
        'Nakshatra-based guidance',
        'Ceremony flow and mantras',
        'Blessing card keepsake',
      ],
    ),
  ];

  static const calendarItems = [
    'Ekadashi vrat',
    'Pradosham',
    'Monthly sankashti',
    'Family ancestor prayer',
  ];

  static const bundleItems = [
    'Wedding rituals',
    'New home bundle',
    'Baby milestones',
    'Wellness and peace',
  ];
}
