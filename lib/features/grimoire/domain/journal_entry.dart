class JournalEntry {
  final int? id;
  final String title;
  final String body;
  final String? tags;
  final DateTime createdAt;

  const JournalEntry({this.id, required this.title, required this.body, this.tags, required this.createdAt});

  factory JournalEntry.fromMap(Map<String, Object?> map) => JournalEntry(
        id: map['id'] as int?,
        title: map['title'] as String,
        body: map['body'] as String,
        tags: map['tags'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'tags': tags,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}
