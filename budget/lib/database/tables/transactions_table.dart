import 'package:drift/drift.dart';
import 'converters.dart';
import 'enums.dart';
import 'categories_table.dart';
import 'wallets_table.dart';
import 'objectives_table.dart';

@DataClassName('Transaction')
class Transactions extends Table {
  TextColumn get transactionPk => text().clientDefault(() => uuid.v4())();
  TextColumn get pairedTransactionFk => text()
      .references(Transactions, #transactionPk)
      .withDefault(const Constant(null))
      .nullable()();
  TextColumn get name => text().withLength(max: NAME_LIMIT)();
  RealColumn get amount => real()();
  TextColumn get note => text().withLength(max: NOTE_LIMIT)();
  TextColumn get categoryFk => text().references(Categories, #categoryPk)();
  TextColumn get subCategoryFk => text()
      .references(Categories, #categoryPk)
      .withDefault(const Constant(null))
      .nullable()();
  TextColumn get walletFk =>
      text().references(Wallets, #walletPk).withDefault(const Constant("0"))();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  // The original date the transaction was due. When a transaction is paid, the date gets set to the current time
  // This stores the original date it was supposed to be due on.
  DateTimeColumn get originalDateDue =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  BoolColumn get income => boolean().withDefault(const Constant(false))();
  // Subscriptions and Repetitive payments
  IntColumn get periodLength => integer().nullable()();
  IntColumn get reoccurrence => intEnum<BudgetReoccurence>().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get upcomingTransactionNotification =>
      boolean().withDefault(const Constant(true)).nullable()();
  IntColumn get type => intEnum<TransactionSpecialType>().nullable()();
  // For credit and debts, paid will be true initially, then false when it is received/paid
  // this is the opposite of what is expected - but taht's because we only want it to count for the totals
  // until it is recieved/paid off resulting in a net of 0
  BoolColumn get paid => boolean().withDefault(const Constant(false))();
  // If user sets to paid and then un pays it will not create a new transaction
  BoolColumn get createdAnotherFutureTransaction =>
      boolean().withDefault(const Constant(false)).nullable()();
  BoolColumn get skipPaid => boolean().withDefault(const Constant(false))();
  // methodAdded will be shared if downloaded from shared server
  IntColumn get methodAdded => intEnum<MethodAdded>().nullable()();
  // Attributes to configure sharing of transactions:
  // Note: a transaction has not been published until methodAdded is shared and sharedKey is not null
  TextColumn get transactionOwnerEmail => text().nullable()();
  TextColumn get transactionOriginalOwnerEmail => text().nullable()();
  TextColumn get sharedKey => text().nullable()();
  TextColumn get sharedOldKey => text()
      .nullable()(); // when a transaction removed shared, this will be sharedKey
  IntColumn get sharedStatus => intEnum<SharedStatus>().nullable()();
  DateTimeColumn get sharedDateUpdated => dateTime().nullable()();
  // the budget this transaction belongs to
  TextColumn get sharedReferenceBudgetPk => text().nullable()();
  TextColumn get objectiveFk =>
      text().references(Objectives, #objectivePk).nullable()();
  TextColumn get objectiveLoanFk =>
      text().references(Objectives, #objectivePk).nullable()();
  TextColumn get budgetFksExclude =>
      text().map(const StringListInColumnConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {transactionPk};
}
