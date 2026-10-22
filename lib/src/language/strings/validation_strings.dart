abstract class ValidationStrings {
  const ValidationStrings();

  String errorLowerThanPrevious({
    required double currentValue,
    required double previousValue,
  });

  String warningExtremelyHigh({required String delta, required String unit});
}