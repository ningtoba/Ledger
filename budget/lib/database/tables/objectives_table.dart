import 'package:drift/drift.dart';
import 'converters.dart';
import 'enums.dart';
import 'wallets_table.dart';

// Objective, savings jars, payment goals, installments, targets etc.
@DataClassName('Objective')
class Objectives extends Table {
  TextColumn get objectivePk => text().clientDefault(() => uuid.v4())();
  IntColumn get type => intEnum<ObjectiveType>().withDefault(Constant(0))();
  TextColumn get name => text().withLength(max: NAME_LIMIT)();
  RealColumn get amount => real()();
  IntColumn get order => integer()();
  TextColumn get colour => text()
      .withLength(max: COLOUR_LIMIT)
      .nullable()(); // if null we are using the themes color
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  TextColumn get iconName => text().nullable()();
  TextColumn get emojiIconName => text().nullable()();
  BoolColumn get income => boolean().withDefault(const Constant(false))();
  BoolColumn get pinned => boolean().withDefault(const Constant(true))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  TextColumn get walletFk =>
      text().references(Wallets, #walletPk).withDefault(const Constant("0"))();

  @override
  Set<Column> get primaryKey => {objectivePk};
}
