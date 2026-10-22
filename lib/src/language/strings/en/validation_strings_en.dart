import '../validation_strings.dart';

class ValidationStringsEn extends ValidationStrings {
  const ValidationStringsEn();

  @override
  String errorLowerThanPrevious({
    required double currentValue,
    required double previousValue,
  }) =>
      'Error: $currentValue is lower than previous reading ($previousValue).';

  @override
  String warningExtremelyHigh({required String delta, required String unit}) =>
      'Warning: Unusually high consumption (+$delta $unit).';
}