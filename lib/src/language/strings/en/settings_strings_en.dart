import '../settings_strings.dart';

class SettingsStringsEn extends SettingsStrings {
  const SettingsStringsEn();

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionDataManagement => 'DATA MANAGEMENT';

  @override
  String get sectionLanguage => 'LANGUAGE';

  @override
  String get sectionAbout => 'ABOUT FLOWLOG';

  @override
  String get actionExport => 'Export';

  @override
  String get actionImport => 'Import';

  @override
  String get exportInProgress => 'Exporting data...';

  @override
  String get importCsvEmpty => 'No valid entries found.';

  @override
  String get restoreDialogTitle => 'Overwrite database?';

  @override
  String get restoreDialogContent =>
      'Restoring a backup will delete all current meter readings and replace '
      'them with the backup.';

  @override
  String get restoreDialogCancel => 'Cancel';

  @override
  String get restoreDialogBackupFirst => 'Back up first';

  @override
  String get restoreDialogOverwrite => 'Overwrite & Restore';

  @override
  String get restoreEmpty => 'The backup contains no entries.';

  @override
  String get aboutTitle => 'FlowLog v1.0.0';

  @override
  String get aboutSubtitle =>
      '100% Offline & Local-First. Your consumption data never leaves this '
      'device.';

  @override
  String exportError(String error) => 'Export error: $error';

  @override
  String importCsvSuccess(int count) => count == 1
      ? '1 entry imported successfully!'
      : '$count entries imported successfully!';

  @override
  String importCsvError(String error) => 'Import error: $error';

  @override
  String restoreSuccess(int count) => count == 1
      ? '1 entry restored successfully!'
      : '$count entries restored successfully!';

  @override
  String restoreError(String error) => 'Restore error: $error';
}
