import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/services/database_service.dart';
import '../../../data/services/validation_service.dart';
import '../../../data/model/meter_entries.dart';

enum TimePeriod { last, day, week, month, year }

class ElectricityDetailScreen extends StatefulWidget {
  const ElectricityDetailScreen({super.key});

  @override
  State<ElectricityDetailScreen> createState() =>
      _ElectricityDetailScreenState();
}

class _ElectricityDetailScreenState extends State<ElectricityDetailScreen> {
  final _controller = TextEditingController();
  TimePeriod _selectedPeriod = TimePeriod.last;

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
        return 'Since Last';
      case TimePeriod.day:
        return 'Avg / Day';
      case TimePeriod.week:
        return 'Avg / Week';
      case TimePeriod.month:
        return 'Avg / Month';
      case TimePeriod.year:
        return 'Avg / Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Colors.amber;
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Details'),
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
                  'Enter New Reading',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Reading',
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: themeColor, width: 2),
                    ),
                    suffixText: 'kWh',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.black87,
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
                      MeterCategory.electricity,
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
                            category: MeterCategory.electricity,
                          ),
                        );

                    _controller.clear();
                    if (mounted) FocusScope.of(context).unfocus();
                  },
                  child: const Text(
                    'Save Entry',
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
                          (t) => t.category.equals(
                            MeterCategory.electricity.index,
                          ),
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
                                segments: const [
                                  ButtonSegment(
                                    value: TimePeriod.last,
                                    label: Text('Last'),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.day,
                                    label: Text('D'),
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
                                    label: Text('Y'),
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
                                            ? 'Latest Consumption'
                                            : 'Average Consumption',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_calculateValue(entries)} kWh',
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
                        'History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: entries.isEmpty
                            ? const Center(child: Text('No entries yet'))
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

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: themeColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      child: const Icon(
                                        Icons.bolt,
                                        color: themeColor,
                                      ),
                                    ),
                                    title: Text(
                                      '${entry.value.toStringAsFixed(1)} kWh',
                                    ),
                                    subtitle: Text(
                                      '${entry.timestamp.year}-${entry.timestamp.month.toString().padLeft(2, '0')}-${entry.timestamp.day.toString().padLeft(2, '0')}',
                                    ),
                                    trailing: Text(
                                      diff != null
                                          ? '+ ${diff.toStringAsFixed(1)}'
                                          : 'Start',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
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
