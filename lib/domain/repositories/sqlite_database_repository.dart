import 'dart:io';

import 'package:docorganizer/domain/entities/document_entity.dart';
import 'package:docorganizer/domain/repositories/database_repository.dart';
import 'package:docorganizer/shared/constants.dart';
import 'package:simplest_logger/simplest_logger.dart';
import 'package:sqflite/sqflite.dart';

final class SQLiteDatabaseRepository
    with SimplestLoggerMixin
    implements IDatabaseRepository {
  final Database _database;

  SQLiteDatabaseRepository({required Database databaseInstance})
    : _database = databaseInstance;

  @override
  Future<Iterable<DocumentEntity>> getAllDocuments() async {
    logger.info('Getting all documents from the database...');
    final rawQueryResults = await _database.rawQuery(
      'select * from $documentsTable order by created_at desc',
    );
    logger.info('Found ${rawQueryResults.length} documents');

    final documentCandidates = rawQueryResults.map(
      (item) => DocumentEntity.fromMap(item),
    );
    logger.info('Deserialized ${documentCandidates.length} documents');
    for (final candidate in documentCandidates) {
      final fileExists = await File(candidate.filePath).exists();
      if (!fileExists) {
        logger.info('File ${candidate.filePath} does not exist, deleting...');
        await deleteDocument(candidate.id);
      }
    }

    logger.info('Returning ${documentCandidates.length} documents');
    return documentCandidates;
  }

  @override
  Future<void> insertDocument(String fileName, String filePath) async {
    logger.info('Inserting document $fileName into the database...');
    final newDocumentID = await _database.insert(
      documentsTable,
      DocumentEntity.toMap(
        fileName: fileName,
        filePath: filePath,
        createdAt: DateTime.now(),
      ),
    );
    logger.info('Newly inserted document with ID $newDocumentID');
  }

  @override
  Future<void> deleteDocument(int id) async {
    logger.info('Deleting document with ID $id from the database...');
    await _database.execute('delete from $documentsTable where id = $id');
    logger.info('Deleted document with ID $id');
  }
}
