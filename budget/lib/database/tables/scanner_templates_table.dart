import 'package:drift/drift.dart';
import 'converters.dart';
import 'enums.dart';
import 'wallets_table.dart';
import 'categories_table.dart';

@DataClassName('ScannerTemplate')
class ScannerTemplates extends Table {
  TextColumn get scannerTemplatePk => text().clientDefault(() => uuid.v4())();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  TextColumn get templateName => text().withLength(max: NAME_LIMIT)();
  TextColumn get contains => text().withLength(max: NAME_LIMIT)();
  TextColumn get titleTransactionBefore => text().withLength(max: NAME_LIMIT)();
  TextColumn get titleTransactionAfter => text().withLength(max: NAME_LIMIT)();
  TextColumn get amountTransactionBefore =>
      text().withLength(max: NAME_LIMIT)();
  TextColumn get amountTransactionAfter => text().withLength(max: NAME_LIMIT)();
  TextColumn get defaultCategoryFk =>
      text().references(Categories, #categoryPk)();
  TextColumn get walletFk =>
      text().references(Wallets, #walletPk).withDefault(const Constant("0"))();
  // TODO: if it contains certain keyword ignore these emails
  BoolColumn get ignore => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {scannerTemplatePk};
}
