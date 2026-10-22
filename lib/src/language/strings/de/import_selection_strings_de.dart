import '../import_selection_strings.dart';

class ImportSelectionStringsDe extends ImportSelectionStrings {
  const ImportSelectionStringsDe();

  @override
  String get sheetTitle => 'Import auswählen';

  @override
  String get csvOptionTitle => 'Messwerte zusammenführen (CSV)';

  @override
  String get csvOptionSubtitle =>
      'Bestehende Einträge bleiben erhalten, neue werden ergänzt';

  @override
  String get jsonOptionTitle => 'Vollständiges Backup (JSON)';

  @override
  String get jsonOptionSubtitle =>
      'Ersetzt alle bestehenden Daten vollständig (Disaster Recovery)';
}