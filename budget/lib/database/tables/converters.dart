import 'dart:convert';
import 'package:drift/drift.dart';
import 'enums.dart';

class IntListInColumnConverter extends TypeConverter<List<int>, String> {
  const IntListInColumnConverter();
  @override
  List<int> fromSql(String string_from_db) {
    return new List<int>.from(json.decode(string_from_db));
  }

  @override
  String toSql(List<int> ints) {
    return json.encode(ints);
  }
}

class BudgetTransactionFiltersListInColumnConverter
    extends TypeConverter<List<BudgetTransactionFilters>, String> {
  const BudgetTransactionFiltersListInColumnConverter();
  @override
  List<BudgetTransactionFilters> fromSql(String string_from_db) {
    List<int> ints = List<int>.from(json.decode(string_from_db));
    List<BudgetTransactionFilters> filters = ints
        .where((i) => i >= 0 && i < BudgetTransactionFilters.values.length)
        .map((i) => BudgetTransactionFilters.values[i])
        .toList();
    return filters;
  }

  @override
  String toSql(List<BudgetTransactionFilters> filters) {
    List<int> ints = filters.map((filter) => filter.index).toList();
    return json.encode(ints);
  }
}

class HomePageWidgetDisplayListInColumnConverter
    extends TypeConverter<List<HomePageWidgetDisplay>, String> {
  const HomePageWidgetDisplayListInColumnConverter();
  @override
  List<HomePageWidgetDisplay> fromSql(String string_from_db) {
    List<int> ints = List<int>.from(json.decode(string_from_db));
    List<HomePageWidgetDisplay> widgetDisplays = ints
        .where((i) => i >= 0 && i < HomePageWidgetDisplay.values.length)
        .map((i) => HomePageWidgetDisplay.values[i])
        .toList();
    return widgetDisplays;
  }

  @override
  String toSql(List<HomePageWidgetDisplay> filters) {
    List<int> ints = filters.map((filter) => filter.index).toList();
    return json.encode(ints);
  }
}

class StringListInColumnConverter extends TypeConverter<List<String>, String> {
  const StringListInColumnConverter();
  @override
  List<String> fromSql(String string_from_db) {
    List<dynamic> dynamicList = List<dynamic>.from(json.decode(string_from_db));
    List<String> stringList =
        dynamicList.map((dynamic item) => item.toString()).toList();
    return stringList;
  }

  @override
  String toSql(List<String> strings) {
    return json.encode(strings);
  }
}

class DoubleListInColumnConverter extends TypeConverter<List<double>, String> {
  const DoubleListInColumnConverter();
  @override
  List<double> fromSql(String string_from_db) {
    return new List<double>.from(json.decode(string_from_db));
  }

  @override
  String toSql(List<double> doubles) {
    return json.encode(doubles);
  }
}
