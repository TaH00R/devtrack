class GithubProfile {
  final String username;
  final int followers;
  final int following;
  final int repositories;
  final int contributions;

  const GithubProfile({
    required this.username,
    required this.followers,
    required this.following,
    required this.repositories,
    required this.contributions,
  });
}