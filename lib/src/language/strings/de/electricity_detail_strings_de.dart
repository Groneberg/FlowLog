import '../electricity_detail_strings.dart';

class ElectricityDetailStringsDe extends ElectricityDetailStrings {
  const ElectricityDetailStringsDe();

  @override
  String get appBarTitle => 'Stromdetails';

  @override
  String get newReadingSectionTitle => 'Neuen Zählerstand eingeben';

  @override
  String get readingFieldLabel => 'Zählerstand';

  @override
  String get unit => 'kWh';

  @override
  String get datePrefix => 'Datum: ';

  @override
  String get saveEntryButton => 'Eintrag speichern';

  @override
  String get editDialogTitle => 'Strom-Eintrag bearbeiten';

  @override
  String get editDialogDateLabel => 'Datum der Messung';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get saveButton => 'Speichern';

  @override
  String get periodLast => 'Seit';

  @override
  String get periodDay => 'T';

  @override
  String get periodWeek => 'W';

  @override
  String get periodMonth => 'M';

  @override
  String get periodYear => 'J';

  @override
  String get latestConsumption => 'Letzter Verbrauch';

  @override
  String get averageConsumption => 'Durchschnittlicher Verbrauch';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get emptyHistoryNotice => 'Noch keine Einträge';

  @override
  String get initialEntryLabel => 'Anfang';

  @override
  String get entryDeletedSnackbar => 'Eintrag gelöscht';

  @override
  String get undoAction => 'Rückgängig';
}
