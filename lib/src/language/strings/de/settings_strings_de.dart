import '../settings_strings.dart';

class SettingsStringsDe extends SettingsStrings {
  const SettingsStringsDe();

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get sectionDataManagement => 'DATENVERWALTUNG';

  @override
  String get sectionLanguage => 'SPRACHE';

  @override
  String get sectionAbout => 'ÜBER FLOWLOG';

  @override
  String get actionExport => 'Exportieren';

  @override
  String get actionImport => 'Importieren';

  @override
  String get exportInProgress => 'Daten werden exportiert...';

  @override
  String get importCsvEmpty => 'Keine gültigen Einträge gefunden.';

  @override
  String get restoreDialogTitle => 'Datenbank überschreiben?';

  @override
  String get restoreDialogContent =>
      'Beim Wiederherstellen eines Backups werden alle aktuellen '
      'Zählerstände gelöscht und durch das Backup ersetzt.';

  @override
  String get restoreDialogCancel => 'Abbrechen';

  @override
  String get restoreDialogBackupFirst => 'Vorher sichern';

  @override
  String get restoreDialogOverwrite => 'Überschreiben & Wiederherstellen';

  @override
  String get restoreEmpty => 'Das Backup enthält keine Einträge.';

  @override
  String get aboutTitle => 'FlowLog v1.0.0';

  @override
  String get aboutSubtitle =>
      '100% Offline & Local-First. Deine Verbrauchsdaten '
      'verlassen niemals dieses Gerät.';

  @override
  String exportError(String error) => 'Fehler beim Export: $error';

  @override
  String importCsvSuccess(int count) => count == 1
      ? '1 Eintrag erfolgreich importiert!'
      : '$count Einträge erfolgreich importiert!';

  @override
  String importCsvError(String error) => 'Fehler beim Import: $error';

  @override
  String restoreSuccess(int count) => count == 1
      ? '1 Eintrag erfolgreich wiederhergestellt!'
      : '$count Einträge erfolgreich wiederhergestellt!';

  @override
  String restoreError(String error) => 'Fehler beim Wiederherstellen: $error';
}
