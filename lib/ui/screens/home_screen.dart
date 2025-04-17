import 'package:docorganizer/notifiers/database_notifier.dart';
import 'package:docorganizer/notifiers/document_scanner_notifier.dart';
import 'package:docorganizer/shared/di.dart';
import 'package:docorganizer/ui/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class HomeScreen extends StatefulWidget {
  static void navigateTo(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
    );
  }

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  late final DocumentScannerNotifier _documentScannerNotifier;
  late final DatabaseNotifier _databaseNotifier;

  @override
  void initState() {
    super.initState();
    _documentScannerNotifier = locator.get<DocumentScannerNotifier>();
    _databaseNotifier = locator.get<DatabaseNotifier>();

    _documentScannerNotifier.addListener(_documentScannerNotifierListener);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _databaseNotifier.fetchDocuments(),
    );
  }

  @override
  void dispose() {
    _documentScannerNotifier.removeListener(_documentScannerNotifierListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOCOrganizer')),
      body: ListenableBuilder(
        listenable: _databaseNotifier,
        builder:
            (context, child) => ListView.builder(
              itemCount: _databaseNotifier.documents.length,
              itemBuilder: (context, index) {
                final item = _databaseNotifier.documents.elementAt(index);

                final (title, subtitle) = (
                  item.fileName,
                  DateFormat.yMd().add_Hm().format(item.createdAt),
                );

                return ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  onTap: () {
                    PreviewScreen.navigateTo(
                      context,
                      id: item.id,
                      fileName: item.fileName,
                      filePath: item.filePath,
                    );
                  },
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _documentScannerNotifier.startScanning(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _documentScannerNotifierListener() {
    final document = _documentScannerNotifier.document;
    if (document != null) {
      _databaseNotifier.insertDocument(document);
    }
  }
}
