import 'package:budget/struct/randomConstants.dart';
import 'package:easy_localization/easy_localization.dart';

/// String constants used across the app
String getWelcomeMessage() {
  int h24 = DateTime.now().hour;
  List<String> greetings = [
    "greetings-general-1".tr(),
    "greetings-general-2".tr(),
    "greetings-general-3".tr(),
    "greetings-general-4".tr(),
    "greetings-general-5".tr(),
    "greetings-general-6".tr(),
    "greetings-general-7".tr(),
  ];
  List<String> greetingsMorning = [
    "greetings-morning-1".tr(),
    "greetings-morning-2".tr(),
  ];
  List<String> greetingsAfternoon = [
    "greetings-afternoon-1".tr(),
    "greetings-afternoon-2".tr(),
  ];
  List<String> greetingsEvening = ["greetings-evening-1".tr()];
  List<String> greetingsLate = [
    "greetings-late-1".tr(),
    "greetings-late-2".tr()
  ];
  if (randomInt[0] % 2 == 0) {
    if (h24 <= 12 && h24 >= 6)
      return greetingsMorning[randomInt[0] % (greetingsMorning.length)];
    else if (h24 <= 16 && h24 >= 13)
      return greetingsAfternoon[randomInt[0] % (greetingsAfternoon.length)];
    else if (h24 <= 22 && h24 >= 19)
      return greetingsEvening[randomInt[0] % (greetingsEvening.length)];
    else if (h24 >= 23 || h24 <= 5)
      return greetingsLate[randomInt[0] % (greetingsLate.length)];
    else
      return greetings[randomInt[0] % (greetings.length)];
  } else {
    return greetings[randomInt[0] % (greetings.length)];
  }
}

/// Popular currencies for auto-detection
List<String> popularCurrencies = [
  'usd', // United States Dollar
  'eur', // Euro
  'jpy', // Japanese Yen
  'gbp', // British Pound Sterling
  'aud', // Australian Dollar
  'cad', // Canadian Dollar
  'chf', // Swiss Franc
  'cny', // Chinese Yuan
  'sek', // Swedish Krona
  'nzd', // New Zealand Dollar
  'mxn', // Mexican Peso
  'inr', // Indian Rupee
  'nok', // Norwegian Krone
  'krw', // South Korean Won
  'btc', // Bitcoin
];
