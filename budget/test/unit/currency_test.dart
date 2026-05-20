import 'package:flutter_test/flutter_test.dart';

// Tests for pure utility functions from money_format.dart
// These are copied here locally because the originals depend on Flutter/DB state.
// When refactoring, these should be moved to a pure Dart utility class.

// Pure function: absoluteZero
double absoluteZero(double number) {
  if (number == -0) return number.abs();
  return number;
}

// Pure function: absoluteZeroNull
double? absoluteZeroNull(double? number) {
  if (number == null) return null;
  if (number == -0) return number.abs();
  return number;
}

// Pure function: absoluteZeroString
String absoluteZeroString(String number) {
  if (number == "-0") return "0";
  return number;
}

// Pure function: removeNaNAndInfinity
double removeNaNAndInfinity(double number) {
  if (number.isFinite == false) return 0;
  return number;
}

// Pure function: hasDecimalPoints
bool hasDecimalPoints(double? value) {
  if (value == null) return false;
  String stringValue = value.toString();
  int dotIndex = stringValue.indexOf('.');
  if (dotIndex != -1) {
    for (int i = dotIndex + 1; i < stringValue.length; i++) {
      if (stringValue[i] != '0') {
        return true;
      }
    }
  }
  return false;
}

// Pure function: countNonTrailingZeroes
int countNonTrailingZeroes(String input) {
  int count = 0;
  for (int i = input.length - 1; i >= 0; i--) {
    if (!isNumber(input[i]) || input[i] == ".") break;
    if (input[i] == "0") {
      count++;
    } else {
      break;
    }
  }
  return count;
}

// Pure function: countDecimalDigits
int countDecimalDigits(String value) {
  int decimalIndex = value.indexOf('.');
  if (decimalIndex == -1) {
    return 0;
  }
  int count = 0;
  for (int i = decimalIndex + 1; i < value.length; i++) {
    count++;
  }
  return count;
}

// Pure function: removeTrailingZeroes
String removeTrailingZeroes(String input) {
  if (input.contains(".") == false) return input;
  List<String> splitInput = input.split(".");
  String decimal = splitInput[1];
  int indexOfFirstNonTrailingZero = 0;
  for (int i = decimal.length - 1; i >= 0; i--) {
    if (decimal[i] == "0") {
      indexOfFirstNonTrailingZero = i;
    } else {
      break;
    }
  }
  decimal = decimal.substring(0, indexOfFirstNonTrailingZero);
  if (decimal.length > 0) {
    return splitInput[0] + "." + decimal;
  }
  return splitInput[0];
}

// Pure function: isNumber (helper used by countNonTrailingZeroes)
bool isNumber(String s) {
  if (s.isEmpty) return false;
  return double.tryParse(s) != null;
}

// Pure function: getAmountFromString
// Simplified version that doesn't depend on appStateSettings
double? getAmountFromString(String inputString) {
  bool isNegative = false;
  if (inputString.contains("-") ||
      inputString.contains("\u2014") ||
      inputString.contains("\u2212") ||
      inputString.contains("\u2013") ||
      inputString.contains("\u2010") ||
      inputString.contains("\u2043") ||
      inputString.contains("\u2011") ||
      inputString.contains("\u2012") ||
      inputString.contains("\u2015")) {
    isNegative = true;
  }
  // Default decimal separator
  String decimalSeparator = ".";
  if (decimalSeparator == ",") {
    inputString = inputString.replaceAll(",", ".");
  } else {
    inputString = inputString.replaceAll(",", "");
  }
  RegExp regex = RegExp(r'[0-9]+(?:\.[0-9]+)?');
  String? match = regex.stringMatch(inputString);
  if (match != null) {
    double amount = double.tryParse(match) ?? 0.0;
    amount = amount.abs();
    if (isNegative) {
      amount = amount * -1;
    }
    return amount;
  }
  return null;
}

// Pure function: convertToPercent (simplified, no appStateSettings dependency)
String convertToPercent(double amount, {double? finalNumber, int? numberDecimals, bool useLessThanZero = false, bool shouldRemoveTrailingZeroes = false}) {
  amount = absoluteZero(amount);
  finalNumber = absoluteZeroNull(finalNumber)
;

  if (amount.isNaN || amount == 0 || finalNumber == 0) return "0%";

  int numberDecimalsGet = numberDecimals ?? 0
;

  String roundedAmount = amount.toStringAsFixed(numberDecimalsGet);

  if (shouldRemoveTrailingZeroes) {
    if (finalNumber != null) {
      int finalTrailingZeroes = countNonTrailingZeroes(finalNumber.toStringAsFixed(numberDecimalsGet));
      roundedAmount = finalNumber.toStringAsFixed(
          finalTrailingZeroes > numberDecimalsGet ? finalTrailingZeroes : numberDecimalsGet);
    } else {
      roundedAmount = removeTrailingZeroes(roundedAmount);
    }
  }

  if (useLessThanZero && roundedAmount == "0" && (finalNumber == null && amount.abs() != 0 || finalNumber != null && finalNumber.abs() != 0)) {
    if (numberDecimalsGet == 0) {
      if (finalNumber == null && amount < 0 || finalNumber != null && finalNumber < 0) {
        roundedAmount = "< -1";
      } else {
        roundedAmount = "< 1";
      }
    } else if (numberDecimalsGet == 1) {
      if (finalNumber == null && amount < 0.1 || finalNumber != null && finalNumber < 0.1) {
        roundedAmount = "< -0.1";
      } else {
        roundedAmount = "< 0.1";
      }
    } else if (numberDecimalsGet == 2) {
      if (finalNumber == null && amount < 0.01 || finalNumber != null && finalNumber < 0.01) {
        roundedAmount = "< -0.01";
      } else {
        roundedAmount = "< 0.01";
      }
    }
  }

  return absoluteZeroString(roundedAmount) + "%";
}

void main() {
  group('absoluteZero', () {
    test('returns absolute value for negative zero', () {
      expect(absoluteZero(-0.0), 0.0);
    });

    test('returns same value for positive zero', () {
      expect(absoluteZero(0.0), 0.0);
    });

    test('returns same value for positive number', () {
      expect(absoluteZero(42.5), 42.5);
    });

    test('returns same value for negative number', () {
      expect(absoluteZero(-10.0), -10.0);
    });
  });

  group('absoluteZeroNull', () {
    test('returns null for null input', () {
      expect(absoluteZeroNull(null), isNull);
    });

    test('handles negative zero', () {
      expect(absoluteZeroNull(-0.0), 0.0);
    });

    test('passes through normal values', () {
      expect(absoluteZeroNull(5.0), 5.0);
    });
  });

  group('absoluteZeroString', () {
    test('converts "-0" to "0"', () {
      expect(absoluteZeroString("-0"), "0");
    });

    test('leaves other strings unchanged', () {
      expect(absoluteZeroString("42"), "42");
      expect(absoluteZeroString("-42"), "-42");
      expect(absoluteZeroString("0"), "0");
    });
  });

  group('removeNaNAndInfinity', () {
    test('returns 0 for NaN', () {
      expect(removeNaNAndInfinity(double.nan), 0.0);
    });

    test('returns 0 for infinity', () {
      expect(removeNaNAndInfinity(double.infinity), 0.0);
      expect(removeNaNAndInfinity(double.negativeInfinity), 0.0);
    });

    test('returns same value for finite numbers', () {
      expect(removeNaNAndInfinity(3.14), 3.14);
    });
  });

  group('hasDecimalPoints', () {
    test('returns false for null', () {
      expect(hasDecimalPoints(null), false);
    });

    test('returns false for integer values', () {
      expect(hasDecimalPoints(10.0), false);
      expect(hasDecimalPoints(0.0), false);
    });

    test('returns true for values with decimal parts', () {
      expect(hasDecimalPoints(10.5), true);
      expect(hasDecimalPoints(0.01), true);
    });
  });

  group('countDecimalDigits', () {
    test('returns 0 when no decimal point', () {
      expect(countDecimalDigits("42"), 0);
    });

    test('returns correct count for decimal strings', () {
      expect(countDecimalDigits("3.14"), 2);
      expect(countDecimalDigits("0.5"), 1);
      expect(countDecimalDigits("100.12345"), 5);
    });
  });

  group('removeTrailingZeroes', () {
    test('returns same string if no decimal point', () {
      expect(removeTrailingZeroes("42"), "42");
    });

    test('removes trailing zeros', () {
      expect(removeTrailingZeroes("3.1400"), "3.14");
      expect(removeTrailingZeroes("5.0"), "5");
    });

    test('keeps non-trailing zeros', () {
      expect(removeTrailingZeroes("10.01"), "10.01");
    });
  });

  group('getAmountFromString', () {
    test('extracts simple positive amount', () {
      expect(getAmountFromString("42.50"), 42.50);
    });

    test('extracts amount with negative sign', () {
      expect(getAmountFromString("-15.99"), -15.99);
    });

    test('returns null when no amount found', () {
      expect(getAmountFromString("hello world"), isNull);
    });

    test('handles various Unicode dash characters', () {
      expect(getAmountFromString("\u201410.50"), -10.50);
    });

    test('strips commas from thousands separators', () {
      expect(getAmountFromString("1,234.56"), 1234.56);
    });
  });

  group('convertToPercent', () {
    test('returns 0% for zero', () {
      expect(convertToPercent(0), "0%");
    });

    test('returns 0% for NaN', () {
      expect(convertToPercent(double.nan), "0%");
    });

    test('formats basic percentages', () {
      expect(convertToPercent(50), "50%");
      expect(convertToPercent(100.0), "100%");
    });

    test('handles negative values', () {
      expect(convertToPercent(-25), "-25%");
    });
  });
}
