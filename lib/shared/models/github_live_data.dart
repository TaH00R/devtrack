class GithubLiveData {
  final String username;
  final String avatarUrl;
  final String profileUrl;
  final int publicRepos;
  final int followers;
  final Map<DateTime, int> contributions;

  const GithubLiveData({
    required this.username,
    required this.avatarUrl,
    required this.profileUrl,
    required this.publicRepos,
    required this.followers,
    required this.contributions,
  });
}