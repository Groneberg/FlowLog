import 'package:flow_log/src/data/services/database_service.dart';
import 'package:flow_log/src/data/services/export_service.dart';
import 'package:flow_log/src/data/services/import_service.dart';
import 'package:flow_log/src/features/Home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => database,
          dispose: (_, db) => db.close(),
        ),
        ProxyProvider<AppDatabase, ExportService>(
          update: (_, db, __) => ExportService(db),
        ),
        ProxyProvider<AppDatabase, ImportService>(
          update: (_, db, __) => ImportService(db),
        ),
      ],
      child: const FlowLogApp(),
    ),
  );
}

class FlowLogApp extends StatelessWidget {
  const FlowLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
