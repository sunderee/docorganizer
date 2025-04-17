import 'package:docorganizer/domain/repositories/database_repository.dart';
import 'package:docorganizer/domain/repositories/document_scanner_repository.dart';
import 'package:docorganizer/domain/repositories/mlkit_document_scanner_repository.dart';
import 'package:docorganizer/domain/repositories/sqlite_database_repository.dart';
import 'package:docorganizer/notifiers/database_notifier.dart';
import 'package:docorganizer/notifiers/document_scanner_notifier.dart';
import 'package:docorganizer/shared/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:simplest_logger/simplest_logger.dart';
import 'package:simplest_service_locator/simplest_service_locator.dart';
import 'package:sqflite/sqflite.dart';

final SimplestServiceLocator locator = SimplestServiceLocator.instance();

Future<void> initializeDependencies() async {
  // Setup logger
  SimplestLogger.setLevel(
    kDebugMode ? SimplestLoggerLevel.all : SimplestLoggerLevel.none,
  );
  SimplestLogger.useColors(true);

  // Setup SQLite database
  final databaseInstance = await openDatabase(
    applicationDatabase,
    version: 1,
    onCreate: (Database db, _) async {
      final createTableMap = {
        documentsTable: {
          'id': 'integer primary key autoincrement',
          'file_name': 'text',
          'file_path': 'text',
          'created_at': 'text',
        },
      };
      for (final entry in createTableMap.entries) {
        final columns = entry.value.entries
            .map((e) => '${e.key} ${e.value}')
            .join(', ');
        await db.execute('create table ${entry.key} ($columns)');
      }
    },
  );

  // Repositories
  final IDocumentScannerRepository repositoryInstance =
      MLKitDocumentScannerRepository();
  final IDatabaseRepository databaseRepositoryInstance =
      SQLiteDatabaseRepository(databaseInstance: databaseInstance);

  // Notifiers
  locator.registerSingleton<DocumentScannerNotifier>(
    DocumentScannerNotifier(repositoryInstance: repositoryInstance),
  );
  locator.registerSingleton<DatabaseNotifier>(
    DatabaseNotifier(repositoryInstance: databaseRepositoryInstance),
  );
}
