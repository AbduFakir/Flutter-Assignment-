class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userHandle;
  final String userAvatar;
  final String? imageUrl;
  final String? videoUrl;
  final String caption;
  final List<String> tags;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userHandle,
    required this.userAvatar,
    this.imageUrl,
    this.videoUrl,
    required this.caption,
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
  });

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userHandle,
    String? userAvatar,
    String? imageUrl,
    String? videoUrl,
    String? caption,
    List<String>? tags,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userHandle: userHandle ?? this.userHandle,
      userAvatar: userAvatar ?? this.userAvatar,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userHandle': userHandle,
        'userAvatar': userAvatar,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'caption': caption,
        'tags': tags,
        'likes': likes,
        'comments': comments,
        'shares': shares,
        'isLiked': isLiked,
        'isBookmarked': isBookmarked,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userHandle: json['userHandle'] as String,
        userAvatar: json['userAvatar'] as String,
        imageUrl: json['imageUrl'] as String?,
        videoUrl: json['videoUrl'] as String?,
        caption: json['caption'] as String,
        tags: List<String>.from(json['tags'] ?? []),
        likes: json['likes'] as int? ?? 0,
        comments: json['comments'] as int? ?? 0,
        shares: json['shares'] as int? ?? 0,
        isLiked: json['isLiked'] as bool? ?? false,
        isBookmarked: json['isBookmarked'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
