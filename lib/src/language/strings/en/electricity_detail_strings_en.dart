import '../electricity_detail_strings.dart';

class ElectricityDetailStringsEn extends ElectricityDetailStrings {
  const ElectricityDetailStringsEn();

  @override
  String get appBarTitle => 'Electricity Details';

  @override
  String get newReadingSectionTitle => 'Enter New Meter Reading';

  @override
  String get readingFieldLabel => 'Meter Reading';

  @override
  String get unit => 'kWh';

  @override
  String get datePrefix => 'Date: ';

  @override
  String get saveEntryButton => 'Save Entry';

  @override
  String get editDialogTitle => 'Edit Electricity Entry';

  @override
  String get editDialogDateLabel => 'Date of Reading';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get periodLast => 'Since';

  @override
  String get periodDay => 'D';

  @override
  String get periodWeek => 'W';

  @override
  String get periodMonth => 'M';

  @override
  String get periodYear => 'Y';

  @override
  String get latestConsumption => 'Latest Consumption';

  @override
  String get averageConsumption => 'Average Consumption';

  @override
  String get historyTitle => 'History';

  @override
  String get emptyHistoryNotice => 'No entries yet';

  @override
  String get initialEntryLabel => 'Start';

  @override
  String get entryDeletedSnackbar => 'Entry deleted';

  @override
  String get undoAction => 'Undo';
}
