import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'database_service.dart';

class ExportService {
  final AppDatabase database;

  ExportService(this.database);

  Future<void> exportAllDataToCsv() async {
    final allEntries = await database.select(database.meterEntries).get();

    List<List<dynamic>> rows = [
      ["ID", "Datum", "Kategorie", "Zählerstand", "Notiz"],
    ];

    for (var entry in allEntries) {
      rows.add([
        entry.id,
        entry.timestamp.toIso8601String(),
        entry.category.name,
        entry.value,
        entry.note ?? "",
      ]);
    }

    String csvData = const ListToCsvConverter(
      fieldDelimiter: ';',
    ).convert(rows);

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/flowlog_export_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csvData);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'FlowLog Datenexport',
      text: 'Hier sind deine exportierten Zählerstände von FlowLog.',
    );
  }
}
