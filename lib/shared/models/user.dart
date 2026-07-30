class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final int xp;
  final int level;
  final int currentStreak;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.xp,
    required this.level,
    required this.currentStreak,
  });
}