import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'database_service.dart';

abstract class ExportStrategy {
  String get fileExtension;
  String get mimeType;

  Future<File> generateExportFile({required List<MeterEntry> entries});
}

class CsvExportStrategy implements ExportStrategy {
  @override
  String get fileExtension => 'csv';

  @override
  String get mimeType => 'text/csv';

  @override
  Future<File> generateExportFile({required List<MeterEntry> entries}) async {
    final rows = [
      ['id', 'timestamp', 'category', 'value', 'note'],
      ...entries.map(
        (entry) => [
          entry.id,
          entry.timestamp.toIso8601String(),
          entry.category.name,
          entry.value,
          entry.note ?? '',
        ],
      ),
    ];

    final csvData =
        'sep=,\n${const ListToCsvConverter(fieldDelimiter: ',').convert(rows)}';
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/flowlog_export_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
    );
    await file.writeAsString(csvData);

    return file;
  }
}

class JsonExportStrategy implements ExportStrategy {
  @override
  String get fileExtension => 'json';

  @override
  String get mimeType => 'application/json';

  @override
  Future<File> generateExportFile({required List<MeterEntry> entries}) async {
    final exportedAt = DateTime.now().toIso8601String();
    final backup = {
      'version': 1,
      'exportedAt': exportedAt,
      'entries': entries
          .map(
            (entry) => <String, dynamic>{
              'id': entry.id,
              'timestamp': entry.timestamp.toIso8601String(),
              'category': entry.category.name,
              'value': entry.value,
              'note': entry.note,
            },
          )
          .toList(),
    };

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/flowlog_backup_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
    );
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(backup),
    );

    return file;
  }
}

class ExportService {
  final AppDatabase database;

  ExportService(this.database);

  Future<void> exportData({
    required BuildContext context,
    required ExportStrategy strategy,
  }) async {
    final origin = _getSharePositionOrigin(context);

    final query = database.select(database.meterEntries)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.timestamp, mode: OrderingMode.asc),
      ]);
    final entries = await query.get();
    final file = await strategy.generateExportFile(entries: entries);

    await Share.shareXFiles(
      [XFile(file.path)],
      sharePositionOrigin: origin,
      subject: 'FlowLog Export',
    );
  }

  Rect? _getSharePositionOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box != null ? box.localToGlobal(Offset.zero) & box.size : null;
  }
}
