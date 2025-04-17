import 'dart:typed_data';

import 'package:docorganizer/domain/repositories/document_scanner_repository.dart';
import 'package:mlkit_document_scanner/mlkit_document_scanner.dart';

final class MLKitDocumentScannerRepository
    implements IDocumentScannerRepository {
  final MlkitDocumentScannerPlugin _mlkitDocumentScannerPlugin;

  MLKitDocumentScannerRepository()
    : _mlkitDocumentScannerPlugin = MlkitDocumentScannerPlugin(
        token: 'MLKitDocumentScannerRepository',
      );

  @override
  Stream<Uint8List?> get scanResultsStream =>
      _mlkitDocumentScannerPlugin.pdfScanResults;

  @override
  void startScanning({int maxNumberOfPages = 10}) {
    _mlkitDocumentScannerPlugin.startDocumentScanner(
      maximumNumberOfPages: maxNumberOfPages,
      galleryImportAllowed: true,
      scannerMode: MlkitDocumentScannerMode.full,
      resultMode: DocumentScannerResultMode.pdfFile,
    );
  }
}
