import 'package:drift/drift.dart';

@DataClassName('AppSetting')
class AppSettings extends Table {
  // We can keep it as an IntColumn, there will only ever be one entry at id 0
  IntColumn get settingsPk => integer().autoIncrement()();
  TextColumn get settingsJSON =>
      text()(); // This is the JSON stored as a string for shared prefs 'userSettings'
  DateTimeColumn get dateUpdated =>
      dateTime().clientDefault(() => new DateTime.now())();
}
