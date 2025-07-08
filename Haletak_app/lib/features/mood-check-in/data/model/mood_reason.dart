class MoodReason {
  final String id;
  final String name;
  final int usageCount;
  final DateTime? lastUsed;

  MoodReason({
    required this.id,
    required this.name,
    this.usageCount = 0,
    this.lastUsed,
  });

  factory MoodReason.fromMap(Map<String, dynamic> map, String docId) {
    return MoodReason(
      id: docId,
      name: map['name'] ?? '',
      usageCount: map['usageCount'] ?? 0,
      lastUsed:
          map['lastUsed'] != null ? DateTime.parse(map['lastUsed']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'usageCount': usageCount,
      'lastUsed': lastUsed?.toIso8601String(),
    };
  }

  MoodReason copyWith({
    String? id,
    String? name,
    int? usageCount,
    DateTime? lastUsed,
  }) {
    return MoodReason(
      id: id ?? this.id,
      name: name ?? this.name,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodReason && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
