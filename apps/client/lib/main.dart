import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared/shared.dart';

import 'client_service_locator.dart';
import 'features/todos/view/todos_page.dart';

/// Main entry point for the client application
///
/// This is the mobile client app for end users, supporting iOS and Android platforms.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initServiceLocator();

  // Initialize TodoDataRepository cache
  await sl<TodoDataRepository>().initializeCache();

  runApp(const MainApp());
}

/// Main application widget for the client app
///
/// Configures the app theme, routing, and initial screen.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodosPage(),
    );
  }
}
