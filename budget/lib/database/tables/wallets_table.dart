import 'package:drift/drift.dart';
import 'converters.dart';

// Character Limits
const int NAME_LIMIT = 250;
const int NOTE_LIMIT = 500;
const int COLOUR_LIMIT = 50;

@DataClassName('TransactionWallet')
class Wallets extends Table {
  TextColumn get walletPk => text().clientDefault(() => uuid.v4())();
  TextColumn get name => text().withLength(max: NAME_LIMIT)();
  TextColumn get colour => text().withLength(max: COLOUR_LIMIT).nullable()();
  TextColumn get iconName => text().nullable()(); // Money symbol
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  IntColumn get order => integer()();
  TextColumn get currency => text().nullable()();
  TextColumn get currencyFormat => text().nullable()();
  IntColumn get decimals => integer().withDefault(Constant(2))();
  TextColumn get homePageWidgetDisplay => text()
      .nullable()
      .withDefault(const Constant(null))
      .map(const HomePageWidgetDisplayListInColumnConverter())();

  @override
  Set<Column> get primaryKey => {walletPk};
}
