abstract class SettingsStrings {
  const SettingsStrings();

  String get settingsTitle;
  String get sectionDataManagement;
  String get sectionLanguage;
  String get sectionAbout;
  String get actionExport;
  String get actionImport;
  String get exportInProgress;
  String get importCsvEmpty;
  String get restoreDialogTitle;
  String get restoreDialogContent;
  String get restoreDialogCancel;
  String get restoreDialogBackupFirst;
  String get restoreDialogOverwrite;
  String get restoreEmpty;
  String get aboutTitle;
  String get aboutSubtitle;

  String exportError(String error);
  String importCsvSuccess(int count);
  String importCsvError(String error);
  String restoreSuccess(int count);
  String restoreError(String error);
}
