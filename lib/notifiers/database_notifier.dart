import 'dart:io';
import 'dart:typed_data';

import 'package:docorganizer/domain/entities/document_entity.dart';
import 'package:docorganizer/domain/repositories/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplest_logger/simplest_logger.dart';

final class DatabaseNotifier extends ChangeNotifier with SimplestLoggerMixin {
  final IDatabaseRepository _repository;

  Iterable<DocumentEntity> _documents = [];
  Iterable<DocumentEntity> get documents => _documents;

  DatabaseNotifier({required IDatabaseRepository repositoryInstance})
    : _repository = repositoryInstance;

  Future<void> fetchDocuments() async {
    logger.info('Fetching documents from the database...');
    _documents = await _repository.getAllDocuments();
    logger.info('Fetched ${_documents.length} documents');

    notifyListeners();
  }

  Future<void> insertDocument(Uint8List document) async {
    final fileName = [
      DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
      'scan',
      '${document.length}',
      'pdf',
    ].join('.');
    logger.info('File name: $fileName');

    final baseDirectoryPath = await getApplicationDocumentsDirectory();
    final filePath = join(baseDirectoryPath.path, fileName);
    logger.info('File path: $filePath');

    final file = File(filePath);
    await file.writeAsBytes(document);
    logger.info('File written to $filePath');

    await _repository.insertDocument(fileName, filePath);
    logger.info('Inserted document $fileName into the database');

    await fetchDocuments();
  }

  Future<void> deleteDocument(int id) async {
    logger.info('Deleting document with ID $id from the database...');
    await _repository.deleteDocument(id);
    logger.info('Deleted document with ID $id from the database');

    await fetchDocuments();
  }
}
