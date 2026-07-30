class AppNotification {
  final String id;
  final String title;
  final String message;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.read,
  });
}