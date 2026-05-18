import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/app_colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.hasStory = false,
    this.isOwn = false,
  });

  final String imageUrl;
  final double radius;
  final bool hasStory;
  final bool isOwn;

  bool get _isLocalFile => imageUrl.isNotEmpty && !imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceLight,
      backgroundImage: imageUrl.isEmpty
          ? null
          : _isLocalFile
              ? FileImage(File(imageUrl)) as ImageProvider
              : CachedNetworkImageProvider(imageUrl),
      child: imageUrl.isEmpty
          ? Icon(Icons.person_rounded, size: radius, color: AppColors.textHint)
          : null,
    );

    if (!hasStory) return avatar;

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isOwn
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              )
            : AppColors.primaryGradient,
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.background,
        ),
        child: avatar,
      ),
    );
  }
}
