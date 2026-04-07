import 'package:flow_log/src/data/services/database_service.dart';
import 'package:flow_log/src/data/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/data/model/meter_entries.dart';

void main() {
  final database = AppDatabase();

  runApp(
    Provider<AppDatabase>(
      create: (context) => database,
      dispose: (context, db) => db.close(),
      child: const FlowLogApp(),
    ),
  );
}

class FlowLogApp extends StatelessWidget {
  const FlowLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowLog Debug',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const TestDataScreen(),
    );
  }
}

class TestDataScreen extends StatefulWidget {
  const TestDataScreen({super.key});

  @override
  State<TestDataScreen> createState() => _TestDataScreenState();
}

class _TestDataScreenState extends State<TestDataScreen> {
  final _controller = TextEditingController();
  MeterCategory _selectedCategory = MeterCategory.electricity;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('FlowLog DB Test')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<MeterCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                    items: MeterCategory.values
                        .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Wert'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_box, color: Colors.green),
                  onPressed: () async {
                    final val = double.tryParse(_controller.text);
                    if (val == null) return;

                    final validator = ValidationService(dbService: database);
                    final result = await validator.validateEntry(val, _selectedCategory);

                    if (!mounted) return;

                    if (result.status == ValidationStatus.errorLowerThanPrevious) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message!),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (result.status == ValidationStatus.warningExtremelyHigh) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message!),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }

                    await database.into(database.meterEntries).insert(
                          MeterEntriesCompanion.insert(
                            value: val,
                            category: _selectedCategory,
                          ),
                        );

                    _controller.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          const Text("DB Inhalt (Live Stream):",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: StreamBuilder<List<MeterEntry>>(
              stream: database.select(database.meterEntries).watch(),
              builder: (context, snapshot) {
                final entries = snapshot.data ?? [];
                if (entries.isEmpty) {
                  return const Center(child: Text("Keine Daten vorhanden"));
                }

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final e = entries[index];
                    return ListTile(
                      leading: Icon(_getIcon(e.category)),
                      title: Text("${e.value} ${e.category.name}"),
                      subtitle: Text(e.timestamp.toIso8601String()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () =>
                            database.delete(database.meterEntries).delete(e),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(MeterCategory cat) {
    switch (cat) {
      case MeterCategory.electricity:
        return Icons.bolt;
      case MeterCategory.waterCold:
        return Icons.water_drop;
      case MeterCategory.waterWarm:
        return Icons.hot_tub;
      case MeterCategory.gas:
        return Icons.local_fire_department;
    }
  }
}