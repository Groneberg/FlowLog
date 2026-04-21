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

        final value = double.parse(row[3].toString());
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
        debugPrint('Fehler bei Zeile $row: $e');
      }
    }

    return importedCount;
  }
}
