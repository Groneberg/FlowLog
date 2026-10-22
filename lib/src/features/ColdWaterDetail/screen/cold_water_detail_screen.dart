import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flow_log/src/language/language_service.dart';
import '../../../data/services/database_service.dart';
import '../../../data/services/validation_service.dart';
import '../../../data/model/meter_entries.dart';
import '../../../language/strings/cold_water_detail_strings.dart';

enum TimePeriod { last, day, week, month, year }

class ColdWaterDetailScreen extends StatefulWidget {
  const ColdWaterDetailScreen({super.key});

  @override
  State<ColdWaterDetailScreen> createState() => _ColdWaterDetailScreenState();
}

class _ColdWaterDetailScreenState extends State<ColdWaterDetailScreen> {
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
      return (entries[0].value - entries[1].value).toStringAsFixed(3);
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

    return (dailyAverage * multiplier).toStringAsFixed(3);
  }

  String _getPeriodLabel(ColdWaterDetailStrings strings) {
    switch (_selectedPeriod) {
      case TimePeriod.last:
        return strings.periodLast;
      case TimePeriod.day:
        return strings.periodDay;
      case TimePeriod.week:
        return strings.periodWeek;
      case TimePeriod.month:
        return strings.periodMonth;
      case TimePeriod.year:
        return strings.periodYear;
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    MeterEntry entry,
    AppDatabase database,
    ColdWaterDetailStrings strings,
  ) async {
    final editController = TextEditingController(text: entry.value.toString());
    DateTime editDate = entry.timestamp;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(strings.editDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: strings.readingFieldLabel,
                      suffixText: strings.unit,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(strings.editDialogDateLabel),
                    subtitle: Text("${editDate.toLocal()}".split(' ')[0]),
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
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
                  child: Text(
                    strings.cancelButton,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                  child: Text(strings.saveButton),
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
    const themeColor = Colors.blue;
    final database = Provider.of<AppDatabase>(context);
    final strings = context.watch<LanguageService>().coldWaterDetailStrings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appBarTitle),
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
                Text(
                  strings.newReadingSectionTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: strings.readingFieldLabel,
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: themeColor, width: 2),
                    ),
                    suffixText: strings.unit,
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
                          '${strings.datePrefix}${_selectedDate.toLocal().toString().split(' ')[0]}',
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
                      MeterCategory.coldWater,
                      entryDate: _selectedDate,
                      strings: context.read<LanguageService>().validationStrings,
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

                    if (result.status ==
                        ValidationStatus.warningExtremelyHigh) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message!),
                            backgroundColor: Colors.amber,
                          ),
                        );
                      }
                    }

                    await database
                        .into(database.meterEntries)
                        .insert(
                          MeterEntriesCompanion.insert(
                            value: value,
                            category: MeterCategory.coldWater,
                            timestamp: drift.Value(_selectedDate),
                          ),
                        );

                    _controller.clear();
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                    if (mounted) FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    strings.saveEntryButton,
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
                          (t) =>
                              t.category.equals(MeterCategory.coldWater.index),
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
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
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
                                segments: [
                                  ButtonSegment(
                                    value: TimePeriod.last,
                                    label: Text(strings.periodLast),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.day,
                                    label: Text(strings.periodDay),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.week,
                                    label: Text(strings.periodWeek),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.month,
                                    label: Text(strings.periodMonth),
                                  ),
                                  ButtonSegment(
                                    value: TimePeriod.year,
                                    label: Text(strings.periodYear),
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
                                            ? strings.latestConsumption
                                            : strings.averageConsumption,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_calculateValue(entries)} ${strings.unit}',
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
                                      _getPeriodLabel(strings),
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
                      Text(
                        strings.historyTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (entries.isEmpty)
                        Center(child: Text(strings.emptyHistoryNotice))
                      else
                        ...entries.asMap().entries.map((entryWithIndex) {
                          final entry = entryWithIndex.value;
                          final index = entryWithIndex.key;
                          double? diff;
                          if (index + 1 < entries.length) {
                            diff = entry.value - entries[index + 1].value;
                          }

                          return Dismissible(
                            key: ValueKey(entry.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
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

                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.entryDeletedSnackbar),
                                  action: SnackBarAction(
                                    label: strings.undoAction,
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
                                strings,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: themeColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: const Icon(
                                  Icons.water_drop_rounded,
                                  color: themeColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                '${entry.value.toStringAsFixed(3)} ${strings.unit}',
                              ),
                              subtitle: Text(
                                '${entry.timestamp.year}-${entry.timestamp.month.toString().padLeft(2, '0')}-${entry.timestamp.day.toString().padLeft(2, '0')}',
                              ),
                              trailing: Text(
                                diff != null
                                    ? '+ ${diff.toStringAsFixed(3)}'
                                    : strings.initialEntryLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }),
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
