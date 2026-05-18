import '../models/post_model.dart';

class MockData {
  MockData._();

  static List<PostModel> get samplePosts => [
        PostModel(
          id: '1',
          userId: 'u1',
          userName: 'Sophia Chen',
          userHandle: '@sophiachen',
          userAvatar: 'https://i.pravatar.cc/150?img=47',
          imageUrl: 'https://picsum.photos/seed/post1/800/600',
          caption:
              'Golden hour never disappoints 🌅 Chasing sunsets and good vibes.',
          tags: ['sunset', 'photography', 'travel'],
          likes: 2847,
          comments: 134,
          shares: 56,
          isLiked: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        PostModel(
          id: '2',
          userId: 'u2',
          userName: 'Marcus Webb',
          userHandle: '@marcuswebb',
          userAvatar: 'https://i.pravatar.cc/150?img=12',
          imageUrl: 'https://picsum.photos/seed/post2/800/1000',
          caption:
              'New setup, who dis? 🖥️ Finally upgraded the battlestation.',
          tags: ['setup', 'tech', 'gaming'],
          likes: 1203,
          comments: 89,
          shares: 23,
          isLiked: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        PostModel(
          id: '3',
          userId: 'u3',
          userName: 'Priya Sharma',
          userHandle: '@priyasharma',
          userAvatar: 'https://i.pravatar.cc/150?img=32',
          imageUrl: 'https://picsum.photos/seed/post3/800/800',
          caption:
              'Weekend brunch hits different when you make it yourself 🥑🍳',
          tags: ['food', 'brunch', 'cooking'],
          likes: 4521,
          comments: 267,
          shares: 112,
          isLiked: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        PostModel(
          id: '4',
          userId: 'u4',
          userName: 'Jordan Lee',
          userHandle: '@jordanlee',
          userAvatar: 'https://i.pravatar.cc/150?img=60',
          imageUrl: 'https://picsum.photos/seed/post4/800/600',
          caption: 'Trail run at 5am. Worth every step. 🏃‍♂️🌄',
          tags: ['running', 'fitness', 'outdoors'],
          likes: 987,
          comments: 45,
          shares: 18,
          isLiked: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        PostModel(
          id: '5',
          userId: 'u5',
          userName: 'Aisha Okonkwo',
          userHandle: '@aishaokonkwo',
          userAvatar: 'https://i.pravatar.cc/150?img=25',
          imageUrl: 'https://picsum.photos/seed/post5/800/1000',
          caption: 'Art is not what you see, but what you make others see. ✨🎨',
          tags: ['art', 'creative', 'design'],
          likes: 6732,
          comments: 412,
          shares: 234,
          isLiked: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PostModel(
          id: '6',
          userId: 'u6',
          userName: 'Luca Rossi',
          userHandle: '@lucarossi',
          userAvatar: 'https://i.pravatar.cc/150?img=8',
          imageUrl: 'https://picsum.photos/seed/post6/800/600',
          caption:
              'Exploring the streets of Rome. Every corner tells a story 🏛️',
          tags: ['travel', 'rome', 'architecture'],
          likes: 3156,
          comments: 198,
          shares: 87,
          isLiked: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

  static List<Map<String, String>> get stories => [
        {'name': 'Your Story', 'avatar': '', 'isOwn': 'true'},
        {
          'name': 'Sophia',
          'avatar': 'https://i.pravatar.cc/150?img=47',
          'isOwn': 'false'
        },
        {
          'name': 'Marcus',
          'avatar': 'https://i.pravatar.cc/150?img=12',
          'isOwn': 'false'
        },
        {
          'name': 'Priya',
          'avatar': 'https://i.pravatar.cc/150?img=32',
          'isOwn': 'false'
        },
        {
          'name': 'Jordan',
          'avatar': 'https://i.pravatar.cc/150?img=60',
          'isOwn': 'false'
        },
        {
          'name': 'Aisha',
          'avatar': 'https://i.pravatar.cc/150?img=25',
          'isOwn': 'false'
        },
        {
          'name': 'Luca',
          'avatar': 'https://i.pravatar.cc/150?img=8',
          'isOwn': 'false'
        },
      ];
}
