class MoodEntry {
  final int? id;
  final int value; // 0..100
  final String? note;
  final DateTime createdAt;

  const MoodEntry({this.id, required this.value, this.note, required this.createdAt});

  factory MoodEntry.fromMap(Map<String, Object?> map) => MoodEntry(
        id: map['id'] as int?,
        value: map['value'] as int,
        note: map['note'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'value': value,
        'note': note,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}
