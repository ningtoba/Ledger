extension CapExtension on String {
  String get capitalizeFirst =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirst)
      .join(" ");
}

String removeLastCharacter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text.substring(0, text.length - 1);
}

String pluralString(bool condition, String string) {
  if (condition)
    return string;
  else
    return string + "s";
}

String filterEmailTitle(string) {
  // Remove store number (everything past the last '#' symbol)
  int position = string.lastIndexOf('#');
  String title = (position != -1) ? string.substring(0, position) : string;
  title = title.trim();
  return title;
}

bool isNumber(dynamic value) {
  if (value == null) {
    return false;
  }
  return num.tryParse(value.toString()) != null;
}

String? nullIfIndexOutOfRange<T>(List<T> list, int index) {
  if (index < 0 || index >= list.length) {
    return null;
  } else {
    return list[index].toString();
  }
}

String addAmountToString(String string, int amount,
    {String? extraText, bool addCommaWithExtraText = true}) {
  return string +
      " " +
      "(\u200B\u00D7" +
      amount.toString() +
      (extraText == null
          ? ""
          : (addCommaWithExtraText ? ", " : " ") + (extraText)) +
      "\u200B)";
}
