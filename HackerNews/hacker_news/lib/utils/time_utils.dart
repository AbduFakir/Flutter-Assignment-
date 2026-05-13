String timeAgo(int unixTime) {
  final now = DateTime.now();
  final then = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
  final diff = now.difference(then);

  if (diff.inDays >= 365) {
    final y = (diff.inDays / 365).floor();
    return '$y year${y > 1 ? 's' : ''} ago';
  } else if (diff.inDays >= 30) {
    final m = (diff.inDays / 30).floor();
    return '$m month${m > 1 ? 's' : ''} ago';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'just now';
  }
}
