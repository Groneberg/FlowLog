import 'package:drift/drift.dart';
import '../model/meter_entries.dart';
import 'database_service.dart';

enum ValidationStatus {
  valid,
  errorLowerThanPrevious,
  warningExtremelyHigh,
  initial,
}

class ValidationResult {
  final ValidationStatus status;
  final String? message;
  final double? delta;

  ValidationResult(this.status, {this.message, this.delta});
}

class ValidationService {
  final AppDatabase _db;

  // WICHTIG: Nutze geschweifte Klammern für den benannten Parameter
  ValidationService({required AppDatabase dbService}) : _db = dbService;

  Future<ValidationResult> validateEntry(
    double newValue,
    MeterCategory category, {
    DateTime? entryDate,
  }) async {
    final lastEntry =
        await (_db.select(_db.meterEntries)
              ..where(
                entryDate == null
                    ? (t) => t.category.equals(category.index)
                    : (t) =>
                          t.category.equals(category.index) &
                          t.timestamp.isSmallerOrEqualValue(entryDate),
              )
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.timestamp,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (lastEntry == null) {
      return ValidationResult(ValidationStatus.initial);
    }

    final lastValue = lastEntry.value;
    final delta = newValue - lastValue;

    if (newValue < lastValue) {
      return ValidationResult(
        ValidationStatus.errorLowerThanPrevious,
        message:
            "Fehler: $newValue ist niedriger als der Vorwert ($lastValue).",
        delta: delta,
      );
    }

    final threshold = switch (category) {
      MeterCategory.electricity => 500.0,
      MeterCategory.gas => 250.0,
      MeterCategory.coldWater || MeterCategory.hotWater => 20.0,
    };
    final unit = switch (category) {
      MeterCategory.electricity => 'kWh',
      MeterCategory.gas ||
      MeterCategory.coldWater ||
      MeterCategory.hotWater => 'm³',
    };

    if (delta > threshold) {
      return ValidationResult(
        ValidationStatus.warningExtremelyHigh,
        message:
            "Warnung: Ungewöhnlich hoher Verbrauch (+${delta.toStringAsFixed(category == MeterCategory.electricity ? 1 : 3)} $unit).",
        delta: delta,
      );
    }

    return ValidationResult(ValidationStatus.valid, delta: delta);
  }
}
