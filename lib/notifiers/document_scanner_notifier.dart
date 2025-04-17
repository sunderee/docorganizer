import 'dart:typed_data';

import 'package:docorganizer/domain/repositories/document_scanner_repository.dart';
import 'package:flutter/material.dart';
import 'package:simplest_logger/simplest_logger.dart';

final class DocumentScannerNotifier extends ChangeNotifier
    with SimplestLoggerMixin {
  final IDocumentScannerRepository _repository;

  Uint8List? _document;
  Uint8List? get document => _document;

  DocumentScannerNotifier({
    required IDocumentScannerRepository repositoryInstance,
  }) : _repository = repositoryInstance {
    _repository.scanResultsStream.listen((result) {
      result != null
          ? logger.info('Obtained scan result (${result.length} bytes)')
          : logger.warning('Obtained null scan result');
      _document = result;
      notifyListeners();
    });
  }

  void startScanning() {
    logger.info('Starting the MLKit Document Scanner...');
    _repository.startScanning();
  }
}
