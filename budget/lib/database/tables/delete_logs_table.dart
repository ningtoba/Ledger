import 'package:drift/drift.dart';
import 'enums.dart';

@DataClassName('DeleteLog')
class DeleteLogs extends Table {
  TextColumn get deleteLogPk => text().clientDefault(() => uuid.v4())();
  TextColumn get entryPk => text()();
  IntColumn get type => intEnum<DeleteLogType>()();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now()))();

  @override
  Set<Column> get primaryKey => {deleteLogPk};
}
