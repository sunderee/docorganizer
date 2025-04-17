import 'dart:async';

import 'package:docorganizer/shared/app.dart';
import 'package:docorganizer/shared/di.dart';
import 'package:flutter/material.dart';

void main() => runZoned(() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const App());
});
