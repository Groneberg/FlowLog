import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

@DataClassName('MeterEntry') 
class MeterEntries extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  
  RealColumn get value => real()();
  
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  
  IntColumn get category => intEnum<MeterCategory>()();
  
  TextColumn get photoUri => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

enum MeterCategory {
  electricity,
  gas,
  coldWater, // Neu für Kaltwasser
  hotWater,  // Neu für Warmwasser
}