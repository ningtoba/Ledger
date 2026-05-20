import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:budget/main.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/database/tables.dart';

extension DateUtils on DateTime {
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

  DateTime justDay(
      {int yearOffset = 0, int monthOffset = 0, int dayOffset = 0}) {
    return DateTime(
        this.year + yearOffset, this.month + monthOffset, this.day + dayOffset);
  }

  DateTime firstDayOfMonth() {
    return DateTime(this.year, this.month, 1);
  }
}

List<String> localizedMonthNames = [];
initializeLocalizedMonthNames() {
  localizedMonthNames = [];
  for (int i = 1; i <= 12; i++) {
    final DateTime date = DateTime(2022, i);
    final String? locale = navigatorKey.currentContext?.locale.toString();
    final String monthName = DateFormat.MMMM(locale).format(date).toLowerCase();
    localizedMonthNames.add(monthName);
  }
  print("Initializing local months: " + localizedMonthNames.toString());
}

String getMonth(DateTime dateTime, {bool includeYear = false}) {
  if (includeYear) {
    return DateFormat.yMMMM(navigatorKey.currentContext?.locale.toString())
        .format(dateTime);
  }
  return DateFormat.MMMM(navigatorKey.currentContext?.locale.toString())
      .format(dateTime);
}

String getWordedTime(
  String? locale,
  DateTime dateTime,
) {
  if (isSetting24HourFormat() == null) {
    return DateFormat.jm(
            locale ?? navigatorKey.currentContext?.locale.toString())
        .format(dateTime);
  } else {
    if (isSetting24HourFormat() == true) {
      return DateFormat("H:mm").format(dateTime);
    } else {
      return DateFormat("h:mm aa").format(dateTime);
    }
  }
}

String getMeridiemString(DateTime dateTime) {
  return DateFormat("aa").format(dateTime).replaceAll(".", "");
}

checkYesterdayTodayTomorrow(DateTime date) {
  DateTime now = DateTime.now();
  if (date.justDay() == now.justDay()) {
    return "today".tr();
  } else if (date.justDay() == now.justDay(dayOffset: 1)) {
    return "tomorrow".tr();
  } else if (date.justDay() == now.justDay(dayOffset: -1)) {
    return "yesterday".tr();
  }

  return false;
}

// e.g. Today/Yesterday/Tomorrow/Tuesday/ Mar 15
String getWordedDateShort(
  DateTime date, {
  includeYear = false,
  showTodayTomorrow = true,
  lowerCaseTodayTomorrow = false,
}) {
  if (showTodayTomorrow && checkYesterdayTodayTomorrow(date) != false) {
    String todayTomorrowOut = checkYesterdayTodayTomorrow(date);
    return lowerCaseTodayTomorrow
        ? todayTomorrowOut.toLowerCase()
        : todayTomorrowOut;
  }

  final locale = navigatorKey.currentContext?.locale.toString();

  if (includeYear) {
    return DateFormat.yMMMd(locale).format(date);
  } else {
    return DateFormat.MMMd(locale).format(date);
  }
}

// e.g. Today/Yesterday/Tomorrow/Tuesday/ March 15
String getWordedDateShortMore(
  DateTime date, {
  includeYear = false,
  includeTime = false,
  includeTimeIfToday = false,
  showTodayTomorrow = true,
}) {
  final String? locale = navigatorKey.currentContext?.locale.toString();

  if (showTodayTomorrow && checkYesterdayTodayTomorrow(date) != false) {
    if (includeTimeIfToday) {
      return checkYesterdayTodayTomorrow(date) +
          " - " +
          getWordedTime(locale, date);
    } else {
      return checkYesterdayTodayTomorrow(date);
    }
  }
  if (includeYear) {
    return DateFormat.MMMMd(locale).format(date) +
        ", " +
        DateFormat.y(locale).format(date);
  } else if (includeTime) {
    return DateFormat.MMMMd(locale).format(date) +
        ", " +
        DateFormat.y(locale).format(date) +
        " - " +
        getWordedTime(locale, date);
  }
  return DateFormat.MMMMd(locale).format(date);
}

String getTimeAgo(DateTime time) {
  final duration = DateTime.now().difference(time);
  if (duration.inDays >= 7) {
    return getWordedDateShortMore(
      time,
      includeTime: false,
      includeTimeIfToday: true,
    );
  } else if (duration.inDays >= 1) {
    if (duration.inDays == 1) {
      return '1-day-ago'.tr();
    }
    return '${duration.inDays} ${"days-ago".tr()}';
  } else if (duration.inHours >= 1) {
    if (duration.inHours == 1) {
      return '1-hour-ago'.tr();
    }
    return '${duration.inHours} ${"hours-ago".tr()}';
  } else if (duration.inMinutes >= 1) {
    if (duration.inMinutes == 1) {
      return '1-minute-ago'.tr();
    }
    return '${duration.inMinutes} ${"minutes-ago".tr()}';
  }
  return 'just-now'.tr();
}

//e.g. Today/Yesterday/Tomorrow/Tuesday/ Thursday, September 15
getWordedDate(DateTime date,
    {bool includeMonthDate = false, bool includeYearIfNotCurrentYear = true}) {
  DateTime now = DateTime.now();

  String extraYear = "";
  if (includeYearIfNotCurrentYear && now.year != date.year) {
    extraYear = ", " + date.year.toString();
  }

  if (checkYesterdayTodayTomorrow(date) != false) {
    return checkYesterdayTodayTomorrow(date) +
        (includeMonthDate
            ? ", " +
                DateFormat.MMMMd(navigatorKey.currentContext?.locale.toString())
                    .format(date)
                    .toString() +
                extraYear
            : "");
  }

  if (includeMonthDate == false &&
      now.difference(date).inDays < 4 &&
      now.difference(date).inDays > 0) {
    String weekday =
        DateFormat('EEEE', navigatorKey.currentContext?.locale.toString())
            .format(date);
    return weekday + extraYear;
  }
  return DateFormat.MMMMEEEEd(navigatorKey.currentContext?.locale.toString())
          .format(date)
          .toString() +
      extraYear;
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
