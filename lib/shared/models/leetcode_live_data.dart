class LeetcodeLiveData {
  final String username;
  final String? avatarUrl;

  final int totalSolved;
  final int easySolved;
  final int mediumSolved;
  final int hardSolved;

  final double? contestRating;

  final Map<DateTime, int> submissions;

  const LeetcodeLiveData({
    required this.username,
    this.avatarUrl,
    required this.totalSolved,
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved,
    required this.contestRating,
    required this.submissions,
  });
}