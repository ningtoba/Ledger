import 'package:drift/drift.dart';
import 'converters.dart';
import 'enums.dart';

@DataClassName('TransactionCategory')
class Categories extends Table {
  TextColumn get categoryPk => text().clientDefault(() => uuid.v4())();
  TextColumn get name => text().withLength(max: NAME_LIMIT)();
  TextColumn get colour => text().withLength(max: COLOUR_LIMIT).nullable()();
  TextColumn get iconName => text().nullable()();
  TextColumn get emojiIconName => text().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => new DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(Constant(DateTime.now())).nullable()();
  IntColumn get order => integer()();
  BoolColumn get income => boolean().withDefault(const Constant(false))();
  IntColumn get methodAdded => intEnum<MethodAdded>().nullable()();
  // If mainCategoryPk is null, it is a main category and can have sub categories
  // If mainCategoryPk is NOT null, it is a subcategory
  TextColumn get mainCategoryPk => text()
      .references(Categories, #categoryPk)
      .withDefault(const Constant(null))
      .nullable()();

  // Attributes to configure sharing of transactions:
  // sharedKey will have the key referencing the entry in the firebase database, if this is null, it is not shared
  // TextColumn get sharedKey => text().nullable()();
  // IntColumn get sharedOwnerMember => intEnum<SharedOwnerMember>().nullable()();
  // DateTimeColumn get sharedDateUpdated => dateTime().nullable()();
  // TextColumn get sharedMembers =>
  //     text().map(const StringListInColumnConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {categoryPk};
}
