import 'package:intl/intl.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/struct/currencyFunctions.dart';
import 'package:budget/database/tables.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:universal_io/io.dart';

int countDecimalDigits(String value) {
  int decimalIndex = value.indexOf('.');
  if (decimalIndex == -1) {
    return 0;
  }

  int count = 0;
  for (int i = decimalIndex + 1; i < value.length; i++) {
    count++;
  }
  print(count);
  return count;
}

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

String convertToMoney(AllWallets allWallets, double amount,
    {String? currencyKey,
    double? finalNumber,
    int? decimals,
    bool? allDecimals,
    bool? addCurrencyName,
    bool forceHideCurrencyName = false,
    bool forceAllDecimals = false,
    bool forceNonCustomNumberFormat = false,
    bool forceCustomNumberFormat = false,
    String? customSymbol,
    String Function(String)? editFormattedOutput,
    bool forceCompactNumberFormatter = false,
    bool forceDefaultNumberFormatter = false,
    bool forceAbsoluteZero = true,
    NumberFormat Function(int? decimalDigits, String? locale, String? symbol)?
        getCustomNumberFormat}) {
  int numberDecimals = decimals ??
      allWallets.indexedByPk[appStateSettings["selectedWalletPk"]]?.decimals ??
      2;
  numberDecimals = numberDecimals > 2 &&
          (finalNumber ?? amount).toString().split('.').length > 1
      ? (finalNumber ?? amount).toString().split('.')[1].length < numberDecimals
          ? (finalNumber ?? amount).toString().split('.')[1].length
          : numberDecimals
      : numberDecimals;

  if (amount == double.infinity || amount == double.negativeInfinity) {
    return "Infinity";
  }
  amount = double.parse(amount.toStringAsFixed(numberDecimals));
  if (forceAbsoluteZero) amount = absoluteZero(amount);
  if (finalNumber != null) {
    finalNumber = double.parse(finalNumber.toStringAsFixed(numberDecimals));
    if (forceAbsoluteZero) finalNumber = absoluteZero(finalNumber);
  }

  int? decimalDigits = forceAllDecimals
      ? decimals
      : allDecimals == true ||
              hasDecimalPoints(finalNumber) ||
              hasDecimalPoints(amount)
          ? numberDecimals
          : 0;
  String? locale = appStateSettings["customNumberFormat"] == true
      ? "en-US"
      : Platform.localeName;
  String? symbol =
      customSymbol ?? getCurrencyString(allWallets, currencyKey: currencyKey);

  bool useCustomNumberFormat = forceCustomNumberFormat ||
      (forceNonCustomNumberFormat == false &&
          appStateSettings["customNumberFormat"] == true);

  final NumberFormat formatter;
  if (getCustomNumberFormat != null) {
    formatter = getCustomNumberFormat(
        decimalDigits, locale, useCustomNumberFormat ? "" : symbol);
  } else if (forceDefaultNumberFormatter == false &&
      (forceCompactNumberFormatter ||
          appStateSettings["shortNumberFormat"] == "compact")) {
    formatter = NumberFormat.compactCurrency(
      locale: locale,
      decimalDigits: decimalDigits,
      symbol: useCustomNumberFormat ? "" : symbol,
    );
    formatter.significantDigitsInUse = false;
  } else {
    formatter = NumberFormat.currency(
      decimalDigits: decimalDigits,
      locale: locale,
      symbol: useCustomNumberFormat ? "" : symbol,
    );
  }

  if (forceHideCurrencyName == false &&
      getCurrencyString(allWallets, currencyKey: currencyKey) == "") {
    addCurrencyName = true;
  }
  String formatOutput = formatter.format(amount).trim();
  String? currencyName;
  if (addCurrencyName == true && currencyKey != null) {
    currencyName = " " + currencyKey.toUpperCase();
  } else if (addCurrencyName == true) {
    currencyName = " " +
        (allWallets.indexedByPk[appStateSettings["selectedWalletPk"]]
                    ?.currency ??
                "")
            .toUpperCase();
  }

  if (useCustomNumberFormat) {
    formatOutput = formatOutputWithNewDelimiterAndDecimal(
      amount: finalNumber ?? amount,
      currencyName: currencyName,
      input: formatOutput,
      delimiter: appStateSettings["numberFormatDelimiter"],
      decimal: appStateSettings["numberFormatDecimal"],
      symbol: symbol,
    );
  } else if (useCustomNumberFormat == false && currencyName != null) {
    formatOutput = formatOutput + currencyName;
  }

  if (editFormattedOutput != null) {
    return editFormattedOutput(formatOutput);
  }

  return formatOutput;
}

String formatOutputWithNewDelimiterAndDecimal({
  required double amount,
  required String input,
  required String delimiter,
  required String decimal,
  required String symbol,
  required String? currencyName,
}) {
  input = input.replaceAll(".", "\uFFFD");
  input = input.replaceAll(",", delimiter);
  input = input.replaceAll("\uFFFD", decimal);
  String negativeSign = "";
  if (amount < 0) {
    input = input.replaceRange(0, 1, "");
    negativeSign = "-";
  }
  if (appStateSettings["numberFormatCurrencyFirst"] == false) {
    return negativeSign +
        input +
        (symbol.length > 0 ? "\u200A\u200A" : "") +
        symbol +
        (currencyName ?? "");
  } else {
    return negativeSign + symbol + input + (currencyName ?? "");
  }
}

// String getDecimalSeparator() => appStateSettings["customNumberFormat"] == true
//     ? appStateSettings["numberFormatDecimal"] ?? "."
//     : ".";
String getDecimalSeparator() => ".";

String convertToPercent(double amount,
    {double? finalNumber,
    int? numberDecimals,
    bool useLessThanZero = false,
    bool shouldRemoveTrailingZeroes = false}) {
  amount = absoluteZero(amount);
  finalNumber = absoluteZeroNull(finalNumber);

  if (amount.isNaN || amount == 0 || finalNumber == 0) return "0%";

  int numberDecimalsGet = numberDecimals != null
      ? numberDecimals
      : (int.tryParse(appStateSettings["percentagePrecision"].toString()) ?? 0);

  String roundedAmount = amount.toStringAsFixed(numberDecimalsGet);

  if (shouldRemoveTrailingZeroes) {
    if (finalNumber != null) {
      int finalTrailingZeroes = countNonTrailingZeroes(
          finalNumber.toStringAsFixed(numberDecimalsGet));
      roundedAmount = finalNumber
          .toStringAsFixed(max(finalTrailingZeroes, numberDecimalsGet));
    } else {
      roundedAmount = removeTrailingZeroes(roundedAmount);
    }
  }

  if (useLessThanZero &&
      roundedAmount == "0" &&
      (finalNumber == null && amount.abs() != 0 ||
          finalNumber != null && finalNumber.abs() != 0)) {
    if (numberDecimalsGet == 0) {
      if (finalNumber == null && amount < 0 ||
          finalNumber != null && finalNumber < 0) {
        roundedAmount = "< -1";
      } else {
        roundedAmount = "< 1";
      }
    } else if (numberDecimalsGet == 1) {
      if (finalNumber == null && amount < 0.1 ||
          finalNumber != null && finalNumber < 0.1) {
        roundedAmount = "< -0.1";
      } else {
        roundedAmount = "< 0.1";
      }
    } else if (numberDecimalsGet == 2) {
      if (finalNumber == null && amount < 0.01 ||
          finalNumber != null && finalNumber < 0.01) {
        roundedAmount = "< -0.01";
      } else {
        roundedAmount = "< 0.01";
      }
    }
  }

  return absoluteZeroString(roundedAmount) + "%";
}

double absoluteZero(double number) {
  if (number == -0) return number.abs();
  return number;
}

double? absoluteZeroNull(double? number) {
  if (number == null) return null;
  if (number == -0) return number.abs();
  return number;
}

double removeNaNAndInfinity(double number) {
  if (number.isFinite == false) return 0;
  return number;
}

String absoluteZeroString(String number) {
  if (number == "-0") return "0";
  return number;
}

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

double? getAmountFromString(String inputString) {
  bool isNegative = false;
  if (inputString.contains("-") ||
      inputString.contains("\u2014") ||
      inputString.contains("\u2212") ||
      inputString.contains("\u2013") ||
      inputString.contains("\u2010") ||
      inputString.contains("\u2212") ||
      inputString.contains("\u2043") ||
      inputString.contains("\u2011") ||
      inputString.contains("\u2012") ||
      inputString.contains("\u2013") ||
      inputString.contains("\u2014") ||
      inputString.contains("\u2015")) {
    isNegative = true;
  }
  String decimalSeparator = getDecimalSeparator();
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
