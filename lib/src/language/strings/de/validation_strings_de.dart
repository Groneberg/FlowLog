import '../validation_strings.dart';

class ValidationStringsDe extends ValidationStrings {
  const ValidationStringsDe();

  @override
  String errorLowerThanPrevious({
    required double currentValue,
    required double previousValue,
  }) =>
      'Fehler: $currentValue ist niedriger als der Vorwert ($previousValue).';

  @override
  String warningExtremelyHigh({required String delta, required String unit}) =>
      'Warnung: Ungewöhnlich hoher Verbrauch (+$delta $unit).';
}