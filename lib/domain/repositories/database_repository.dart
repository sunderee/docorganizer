import 'package:docorganizer/domain/entities/document_entity.dart';

abstract interface class IDatabaseRepository {
  Future<Iterable<DocumentEntity>> getAllDocuments();
  Future<void> insertDocument(String fileName, String filePath);
  Future<void> deleteDocument(int id);
}
