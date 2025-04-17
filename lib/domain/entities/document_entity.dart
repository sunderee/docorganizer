import 'package:flutter/foundation.dart';

@immutable
final class DocumentEntity {
  static Map<String, dynamic> toMap({
    required String fileName,
    required String filePath,
    required DateTime createdAt,
  }) {
    return {
      'file_name': fileName,
      'file_path': filePath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  final int id;
  final String fileName;
  final String filePath;
  final DateTime createdAt;

  const DocumentEntity({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
  });

  factory DocumentEntity.fromMap(Map<String, dynamic> map) => DocumentEntity(
    id: map['id'] as int,
    fileName: map['file_name'] as String,
    filePath: map['file_path'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  @override
  bool operator ==(Object other) {
    if (other is! DocumentEntity) {
      return false;
    }

    if (identical(this, other)) {
      return true;
    }

    return id == other.id &&
        fileName == other.fileName &&
        filePath == other.filePath &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode => Object.hash(id, fileName, filePath, createdAt);
}
