import 'package:drift/drift.dart';
import 'converters.dart';
import 'categories_table.dart';

//If a title is in a smart label, automatically choose this category
// For e.g. for Food category
// smartLabels = ["apple", "pear"]
// Then when user sets title to pineapple, it will set the category to Food. Because "apple" is in "pineapple".
@DataClassName('TransactionAssociatedTitle')
class AssociatedTitles extends Table {
  TextColumn get associatedTitlePk => text().clientDefault(() => uuid.v4())();
  TextColumn get categoryFk => text().references(Categories, #categoryPk)();
  TextColumn get title => text().withLength(max: NAME_LIMIT)();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  IntColumn get order => integer()();
  BoolColumn get isExactMatch => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {associatedTitlePk};
}

// @DataClassName('TransactionLabel')
// class Labels extends Table {
//   IntColumn get label_pk => integer().autoIncrement()();
//   TextColumn get name => text().withLength(max: NAME_LIMIT)();
//   IntColumn get categoryFk => integer().references(Categories, #categoryPk)();
//   DateTimeColumn get dateCreated =>
//       dateTime().clientDefault(() => new DateTime.now())();
//   DateTimeColumn get dateTimeModified =>
//       dateTime().withDefault(Constant(DateTime.now())).nullable()();
//   IntColumn get order => integer()();
// }
