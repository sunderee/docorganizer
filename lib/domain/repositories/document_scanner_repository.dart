import 'dart:typed_data';

abstract interface class IDocumentScannerRepository {
  Stream<Uint8List?> get scanResultsStream;

  void startScanning({int maxNumberOfPages = 10});
}
