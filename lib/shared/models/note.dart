class Note {
  final String id;
  final String title;
  final String content;
  final bool pinned;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.pinned = false,
  });
}