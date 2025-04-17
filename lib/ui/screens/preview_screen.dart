import 'dart:io';

import 'package:docorganizer/notifiers/database_notifier.dart';
import 'package:docorganizer/shared/di.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

final class PreviewScreen extends StatefulWidget {
  static void navigateTo(
    BuildContext context, {
    required int id,
    required String fileName,
    required String filePath,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return PreviewScreen(id: id, fileName: fileName, filePath: filePath);
        },
      ),
    );
  }

  final int id;
  final String fileName;
  final String filePath;

  const PreviewScreen({
    super.key,
    required this.id,
    required this.fileName,
    required this.filePath,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

final class _PreviewScreenState extends State<PreviewScreen> {
  late final DatabaseNotifier _databaseNotifier;

  @override
  void initState() {
    super.initState();
    _databaseNotifier = locator.get<DatabaseNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          IconButton(
            onPressed: () => _shareDocument(),
            icon: const Icon(Icons.ios_share_outlined),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SfPdfViewer.file(File(widget.filePath)),
    );
  }

  void _shareDocument() {
    Share.shareXFiles([
      XFile(
        widget.filePath,
        mimeType: 'application/pdf',
        name: widget.fileName,
      ),
    ]);
  }

  void _showDeleteDialog() => showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Delete ${widget.fileName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _databaseNotifier.deleteDocument(widget.id);
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
  ).then((deleted) {
    if (deleted == true && mounted) {
      Navigator.pop(context);
    }
  });
}
