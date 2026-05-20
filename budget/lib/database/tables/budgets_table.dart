import 'package:drift/drift.dart';
import 'converters.dart';
import 'enums.dart';
import 'wallets_table.dart';
import 'categories_table.dart';

@DataClassName('Budget')
class Budgets extends Table {
  TextColumn get budgetPk => text().clientDefault(() => uuid.v4())();
  TextColumn get name => text().withLength(max: NAME_LIMIT)();
  RealColumn get amount => real()();
  TextColumn get colour => text()
      .withLength(max: COLOUR_LIMIT)
      .nullable()(); // if null we are using the themes color
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get walletFks =>
      text().map(const StringListInColumnConverter()).nullable()();
  TextColumn get categoryFks =>
      text().map(const StringListInColumnConverter()).nullable()();
  TextColumn get categoryFksExclude =>
      text().map(const StringListInColumnConverter()).nullable()();
  // BoolColumn get allCategoryFks => boolean()();
  BoolColumn get income => boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  BoolColumn get addedTransactionsOnly =>
      boolean().withDefault(const Constant(false))();
  IntColumn get periodLength => integer()();
  IntColumn get reoccurrence => intEnum<BudgetReoccurence>().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  IntColumn get order => integer()();
  TextColumn get walletFk =>
      text().references(Wallets, #walletPk).withDefault(const Constant("0"))();
  TextColumn get budgetTransactionFilters => text()
      .nullable()
      .withDefault(const Constant(null))
      .map(const BudgetTransactionFiltersListInColumnConverter())();
  TextColumn get memberTransactionFilters => text()
      .nullable()
      .withDefault(const Constant(null))
      .map(const StringListInColumnConverter())();
  // Attributes to configure sharing of transactions:
  // sharedKey will have the key referencing the entry in the firebase database, if this is null, it is not shared
  TextColumn get sharedKey => text().nullable()();
  IntColumn get sharedOwnerMember => intEnum<SharedOwnerMember>().nullable()();
  DateTimeColumn get sharedDateUpdated => dateTime().nullable()();
  TextColumn get sharedMembers =>
      text().map(const StringListInColumnConverter()).nullable()();
  TextColumn get sharedAllMembersEver =>
      text().map(const StringListInColumnConverter()).nullable()();
  BoolColumn get isAbsoluteSpendingLimit =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {budgetPk};
}

@DataClassName('CategoryBudgetLimit')
class CategoryBudgetLimits extends Table {
  TextColumn get categoryLimitPk => text().clientDefault(() => uuid.v4())();
  TextColumn get categoryFk => text().references(Categories, #categoryPk)();
  TextColumn get budgetFk => text().references(Budgets, #budgetPk)();
  RealColumn get amount => real()();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  TextColumn get walletFk =>
      text().references(Wallets, #walletPk).withDefault(const Constant("0"))();

  @override
  Set<Column> get primaryKey => {categoryLimitPk};
}
