import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart';
import 'package:flow_log/src/data/model/meter_entries.dart';
import 'package:flutter/foundation.dart';

import 'database_service.dart';

class ImportService {
  final AppDatabase database;

  ImportService(this.database);

  Future<int> importDataFromCsv() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.first.path == null) {
      return 0;
    }

    final File file = File(result.files.first.path!);
    String csvString = await file.readAsString();

    if (csvString.startsWith('sep=,')) {
      csvString = csvString.replaceFirst(RegExp(r'sep=,\r?\n'), '');
    }

    List<List<dynamic>> rows = const CsvToListConverter(
      fieldDelimiter: ',',
    ).convert(csvString);

    if (rows.length <= 1) return 0;

    rows.removeAt(0);
    int importedCount = 0;

    for (var row in rows) {
      if (row.length < 4) continue;

      try {
        final id = row[0].toString();
        final timestamp = DateTime.parse(row[1].toString());
        final categoryStr = row[2].toString();

        final category = MeterCategory.values.firstWhere(
          (e) => e.name == categoryStr,
          orElse: () => MeterCategory.electricity,
        );

        final sanitizedValue = row[3].toString().trim().replaceAll(',', '.');
        final value = double.parse(sanitizedValue);
        final note = row.length > 4 ? row[4].toString() : null;

        await database
            .into(database.meterEntries)
            .insertOnConflictUpdate(
              MeterEntriesCompanion(
                id: Value(id),
                timestamp: Value(timestamp),
                category: Value(category),
                value: Value(value),
                note: Value(note != null && note.isNotEmpty ? note : null),
              ),
            );
        importedCount++;
      } catch (e) {
        debugPrint('Error importing row $row: $e');
      }
    }

    return importedCount;
  }

  Future<int> restoreFromJson() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.first.path == null) {
      return 0;
    }

    final file = File(result.files.first.path!);
    final decoded = jsonDecode(await file.readAsString());

    if (decoded is! Map<String, dynamic> ||
        decoded['entries'] is! List ||
        (decoded['entries'] as List).isEmpty) {
      throw const FormatException('The selected backup has no entries.');
    }

    final entries = decoded['entries'] as List;

    await database.transaction(() async {
      await database.delete(database.meterEntries).go();

      for (final raw in entries) {
        final item = raw as Map<String, dynamic>;
        await database
            .into(database.meterEntries)
            .insert(
              MeterEntriesCompanion.insert(
                id: Value(item['id'] as String),
                timestamp: Value(DateTime.parse(item['timestamp'] as String)),
                category: MeterCategory.values.firstWhere(
                  (category) => category.name == item['category'],
                  orElse: () => MeterCategory.electricity,
                ),
                value: (item['value'] as num).toDouble(),
                note: Value(item['note'] as String?),
              ),
            );
      }
    });

    return entries.length;
  }
}
