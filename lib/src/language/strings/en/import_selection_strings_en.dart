import '../import_selection_strings.dart';

class ImportSelectionStringsEn extends ImportSelectionStrings {
  const ImportSelectionStringsEn();

  @override
  String get sheetTitle => 'Choose Import Format';

  @override
  String get csvOptionTitle => 'Merge Readings (CSV)';

  @override
  String get csvOptionSubtitle =>
      'Existing entries are kept, new ones will be added';

  @override
  String get jsonOptionTitle => 'Full Backup (JSON)';

  @override
  String get jsonOptionSubtitle =>
      'Overwrites all existing data completely (Disaster Recovery)';
}