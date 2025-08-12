enum ConquestStatus { pending, inProgress, completed }

class Conquest {
  final int? id;
  final String title;
  final String? details;
  final int difficulty; // 1..5
  final ConquestStatus status;
  final DateTime? dueAt;

  const Conquest({
    this.id,
    required this.title,
    this.details,
    required this.difficulty,
    required this.status,
    this.dueAt,
  });

  Conquest copyWith({
    int? id,
    String? title,
    String? details,
    int? difficulty,
    ConquestStatus? status,
    DateTime? dueAt,
  }) {
    return Conquest(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      dueAt: dueAt ?? this.dueAt,
    );
  }

  factory Conquest.fromMap(Map<String, Object?> map) {
    return Conquest(
      id: map['id'] as int?,
      title: map['title'] as String,
      details: map['details'] as String?,
      difficulty: map['difficulty'] as int,
      status: ConquestStatus.values.firstWhere(
        (s) => s.name == (map['status'] as String),
        orElse: () => ConquestStatus.pending,
      ),
      dueAt: map['dueAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['dueAt'] as int),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'difficulty': difficulty,
      'status': status.name,
      'dueAt': dueAt?.millisecondsSinceEpoch,
    };
  }
}
