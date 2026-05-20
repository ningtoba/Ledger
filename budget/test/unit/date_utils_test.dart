import 'package:flutter_test/flutter_test.dart';

// Replicated pure utility functions from date_utils.dart for testing.
// These do not depend on Flutter context or appStateSettings.

extension DateUtilsExtensions on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime justDay({int yearOffset = 0, int monthOffset = 0, int dayOffset = 0}) {
    return DateTime(
        this.year + yearOffset, this.month + monthOffset, this.day + dayOffset);
  }

  DateTime firstDayOfMonth() {
    return DateTime(this.year, this.month, 1);
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day + 1);
  return (to.difference(from).inHours / 24).round();
}

double getPercentBetweenDates(DateTimeRange timeRange, DateTime currentTime) {
  int millisecondDifference = timeRange.end.millisecondsSinceEpoch -
      timeRange.start.millisecondsSinceEpoch +
      Duration(days: 1).inMilliseconds;
  double percent = (currentTime.millisecondsSinceEpoch -
          timeRange.start.millisecondsSinceEpoch) /
      millisecondDifference;
  return percent * 100;
}

void main() {
  group('DateTime.copyWith', () {
    final base = DateTime(2024, 3, 15, 10, 30, 0);

    test('returns same date when no params given', () {
      expect(base.copyWith(), base);
    });

    test('overrides year', () {
      final result = base.copyWith(year: 2025);
      expect(result.year, 2025);
      expect(result.month, 3);
      expect(result.day, 15);
    });

    test('overrides month and day', () {
      final result = base.copyWith(month: 12, day: 25);
      expect(result.month, 12);
      expect(result.day, 25);
      expect(result.year, 2024);
    });

    test('overrides time components', () {
      final result = base.copyWith(hour: 0, minute: 0, second: 0);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
    });
  });

  group('DateTime.justDay', () {
    test('zeroes out time components', () {
      final dt = DateTime(2024, 6, 15, 14, 30, 45);
      final day = dt.justDay();
      expect(day.year, 2024);
      expect(day.month, 6);
      expect(day.day, 15);
      expect(day.hour, 0);
      expect(day.minute, 0);
      expect(day.second, 0);
    });

    test('applies offsets', () {
      final dt = DateTime(2024, 12, 31);
      final nextDay = dt.justDay(dayOffset: 1);
      expect(nextDay.year, 2025);
      expect(nextDay.month, 1);
      expect(nextDay.day, 1);
    });

    test('handles negative day offset', () {
      final dt = DateTime(2024, 1, 1);
      final prevDay = dt.justDay(dayOffset: -1);
      expect(prevDay.year, 2023);
      expect(prevDay.month, 12);
      expect(prevDay.day, 31);
    });
  });

  group('DateTime.firstDayOfMonth', () {
    test('returns first day of same month', () {
      final dt = DateTime(2024, 6, 15);
      expect(dt.firstDayOfMonth(), DateTime(2024, 6, 1));
    });

    test('handles year boundary', () {
      final dt = DateTime(2024, 1, 15);
      expect(dt.firstDayOfMonth(), DateTime(2024, 1, 1));
    });
  });

  group('daysBetween', () {
    test('returns 0 for same day', () {
      expect(daysBetween(DateTime(2024, 1, 1), DateTime(2024, 1, 1)), 0);
    });

    test('returns 1 for consecutive days', () {
      expect(daysBetween(DateTime(2024, 1, 1), DateTime(2024, 1, 2)), 1);
    });

    test('handles month boundary', () {
      expect(daysBetween(DateTime(2024, 1, 31), DateTime(2024, 2, 1)), 1);
    });

    test('handles year boundary', () {
      expect(daysBetween(DateTime(2024, 12, 31), DateTime(2025, 1, 1)), 1);
    });

    test('returns correct value for multi-day spans', () {
      expect(daysBetween(DateTime(2024, 1, 1), DateTime(2024, 1, 10)), 9);
    });

    test('works backwards (negative range)', () {
      // The function only rounds hours/24, so going backwards gives negative
      final result = daysBetween(DateTime(2024, 1, 10), DateTime(2024, 1, 1));
      expect(result, lessThan(0));
    });
  });

  group('getPercentBetweenDates', () {
    test('returns 0 at start of range', () {
      final range = DateTimeRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 10),
      );
      expect(getPercentBetweenDates(range, DateTime(2024, 1, 1)), closeTo(0, 0.01));
    });

    test('returns ~50 at midpoint', () {
      final range = DateTimeRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 10),
      );
      // Midpoint (including +1 day in calculation) is approximately 5 days in
      final percent = getPercentBetweenDates(range, DateTime(2024, 1, 5));
      expect(percent, greaterThan(30));
      expect(percent, lessThan(70));
    });

    test('returns ~100 at end of range', () {
      final range = DateTimeRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 10),
      );
      final percent = getPercentBetweenDates(range, DateTime(2024, 1, 10));
      // Due to +1 day inclusivity, should be close to 100 but not exceed
      expect(percent, greaterThan(80));
      expect(percent, lessThanOrEqualTo(100));
    });
  });
}
