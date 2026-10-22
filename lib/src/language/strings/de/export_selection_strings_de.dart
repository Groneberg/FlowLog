import '../export_selection_strings.dart';

class ExportSelectionStringsDe extends ExportSelectionStrings {
  const ExportSelectionStringsDe();

  @override
  String get sheetTitle => 'Export auswählen';

  @override
  String get csvOptionTitle => 'Tabellendaten (CSV)';

  @override
  String get csvOptionSubtitle => 'Für Excel, Tabellen und Auswertungen';

  @override
  String get jsonOptionTitle => 'Vollständiges Backup (JSON)';

  @override
  String get jsonOptionSubtitle =>
      'Vollständige Datensicherung zur Wiederherstellung';
}