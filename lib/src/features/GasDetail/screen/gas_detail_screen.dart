import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/services/database_service.dart';
import '../../../data/services/validation_service.dart';
import '../../../data/model/meter_entries.dart';

enum TimePeriod { last, day, week, month, year }

class GasDetailScreen extends StatefulWidget {
  const GasDetailScreen({super.key});

  @override
  State<GasDetailScreen> createState() => _GasDetailScreenState();
}

class _GasDetailScreenState extends State<GasDetailScreen> {
  final _controller = TextEditingController();
  TimePeriod _selectedPeriod = TimePeriod.last;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _calculateValue(List<MeterEntry> entries) {
    if (entries.length < 2) return '--';

    if (_selectedPeriod == TimePeriod.last) {
      return (entries[0].value - entries[1].value).toStringAsFixed(1);
    }

    final newest = entries.first;
    final oldest = entries.last;

    final daysDiff =
        newest.timestamp.difference(oldest.timestamp).inSeconds / 86400.0;
    if (daysDiff <= 0) return '--';

    final totalConsumption = newest.value - oldest.value;
    final dailyAverage = totalConsumption / daysDiff;

    double multiplier;
    switch (_selectedPeriod) {
      case TimePeriod.day:
        multiplier = 1.0;
        break;
      case TimePeriod.week:
        multiplier = 7.0;
        break;
      case TimePeriod.month:
        multiplier = 30.416;
        break;
      case TimePeriod.year:
        multiplier = 365.25;
        break;
      case TimePeriod.last:
        return '';
    }

    return (dailyAverage * multiplier).toStringAsFixed(1);
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case TimePeriod.last:
        return 'Seit';
      case TimePeriod.day:
        return 'T';
      case TimePeriod.week:
        return 'W';
      case TimePeriod.month:
        return 'M';
      case TimePeriod.year:
        return 'J';
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    MeterEntry entry,
    AppDatabase database,
  ) async {
    final editController = TextEditingController(text: entry.value.toString());
    DateTime editDate = entry.timestamp;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Eintrag bearbeiten'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Zählerstand',
                      suffixText: 'm³',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Datum der Messung"),
                    subtitle: Text("${editDate.toLocal()}".split(' ')[0]),
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.orange,
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: editDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => editDate = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Abbrechen',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final newValue = double.tryParse(editController.text);
                    if (newValue != null) {
                      final updatedEntry = entry.copyWith(
                        value: newValue,
                        timestamp: editDate,
                      );
                      await database
                          .update(database.meterEntries)
                          .replace(updatedEntry);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Colors.orange;
    const unit = 'm³';
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gasdetails'),
        backgroundColor: themeColor.withValues(alpha: 0.2),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            color: themeColor.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Neuen Zählerstand eingeben',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Zählerstand',
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: themeColor, width: 2),
                    ),
                    suffixText: unit,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: themeColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Datum: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final value = double.tryParse(_controller.text);
                    if (value == null) return;

                    final validator = ValidationService(dbService: database);
                    final result = await validator.validateEntry(
                      value,
                      MeterCategory.gas,
                    );

                    if (result.status ==
                        ValidationStatus.errorLowerThanPrevious) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      return;
                    }

                    await database
                        .into(database.meterEntries)
                        .insert(
                          MeterEntriesCompanion.insert(
                            value: value,
                            category: MeterCategory.gas,
                            timestamp: drift.Value(_selectedDate),
                          ),
                        );

                    _controller.clear();
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                    if (mounted) FocusScope.of(context).unfocus();
                  },
                  child: const Text(
                    'Eintrag speichern',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MeterEntry>>(
              stream:
                  (database.select(database.meterEntries)
                        ..where(
                          (t) => t.category.equals(MeterCategory.gas.index),
                        )
                        ..orderBy([
                          (t) => drift.OrderingTerm(
                            expression: t.timestamp,
                            mode: drift.OrderingMode.desc,
                          ),
                        ]))
                      .watch(),
              builder: (context, snapshot) {
                final entries = snapshot.data ?? [];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Card(
                        elevation: 0,
                        color: themeColor.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: themeColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SegmentedButton<TimePeriod>(
                                showSelectedIcon: false,
                                segments: const [
                                  ButtonSegment(
                                    value: TimePeriod.last,
                                    label: Text('Seit'),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.day,
                                    label: Text('T'),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.week,
                                    label: Text('W'),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.month,
                                    label: Text('M'),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.year,
                                    label: Text('J'),
                                  ),
                                ],
                                selected: {_selectedPeriod},
                                onSelectionChanged: (newSelection) {
                                  setState(() {
                                    _selectedPeriod = newSelection.first;
                                  });
                                },
                                style: SegmentedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  selectedBackgroundColor: themeColor
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedPeriod == TimePeriod.last
                                            ? 'Letzter Verbrauch'
                                            : 'Durchschnittlicher Verbrauch',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_calculateValue(entries)} $unit',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      _getPeriodLabel(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Verlauf',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: entries.isEmpty
                            ? const Center(child: Text('Noch keine Einträge'))
                            : ListView.separated(
                                itemCount: entries.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final entry = entries[index];
                                  double? diff;
                                  if (index + 1 < entries.length) {
                                    diff =
                                        entry.value - entries[index + 1].value;
                                  }

                                  return Dismissible(
                                    key: ValueKey(entry.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(
                                        right: 20.0,
                                      ),
                                      color: Colors.red.withValues(alpha: 0.8),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onDismissed: (direction) async {
                                      await database
                                          .delete(database.meterEntries)
                                          .delete(entry);

                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Eintrag gelöscht',
                                          ),
                                          action: SnackBarAction(
                                            label: 'Rückgängig',
                                            onPressed: () async {
                                              await database
                                                  .into(database.meterEntries)
                                                  .insert(entry);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      onTap: () => _showEditDialog(
                                        context,
                                        entry,
                                        database,
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: themeColor.withValues(
                                          alpha: 0.2,
                                        ),
                                        child: const Icon(
                                          Icons.local_fire_department_rounded,
                                          color: themeColor,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        '${entry.value.toStringAsFixed(1)} $unit',
                                      ),
                                      subtitle: Text(
                                        '${entry.timestamp.year}-${entry.timestamp.month.toString().padLeft(2, '0')}-${entry.timestamp.day.toString().padLeft(2, '0')}',
                                      ),
                                      trailing: Text(
                                        diff != null
                                            ? '+ ${diff.toStringAsFixed(1)}'
                                            : 'Anfang',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
