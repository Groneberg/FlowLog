import 'package:drift/drift.dart';
import '../model/meter_entries.dart';
import 'database_service.dart';

enum ValidationStatus { valid, errorLowerThanPrevious, warningExtremelyHigh, initial }

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

  Future<ValidationResult> validateEntry(double newValue, MeterCategory category) async {
    final lastEntry = await (_db.select(_db.meterEntries)
          ..where((t) => t.category.equals(category.index))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])
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
        message: "Fehler: $newValue ist niedriger als der Vorwert ($lastValue).",
        delta: delta,
      );
    }

    if (delta > 500) {
      return ValidationResult(
        ValidationStatus.warningExtremelyHigh,
        message: "Warnung: Hoher Verbrauch (+${delta.toStringAsFixed(2)}).",
        delta: delta,
      );
    }

    return ValidationResult(ValidationStatus.valid, delta: delta);
  }
}