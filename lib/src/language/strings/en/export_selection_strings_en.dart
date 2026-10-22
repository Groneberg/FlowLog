import '../export_selection_strings.dart';

class ExportSelectionStringsEn extends ExportSelectionStrings {
  const ExportSelectionStringsEn();

  @override
  String get sheetTitle => 'Choose Export Format';

  @override
  String get csvOptionTitle => 'Spreadsheet Data (CSV)';

  @override
  String get csvOptionSubtitle =>
      'For Excel, spreadsheets, and custom analysis';

  @override
  String get jsonOptionTitle => 'Full Backup (JSON)';

  @override
  String get jsonOptionSubtitle =>
      'Complete data backup for full disaster recovery';
}