import 'package:budget/functions.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/navigationSidebar.dart';
import 'package:flutter/material.dart';
import 'package:budget/colors.dart';
import 'package:budget/widgets/scrollbarWrap.dart';

// Deprecated: kept for backward compatibility with callers that reference
// these controllers. They no longer have any effect since sliding_sheet was removed.
dynamic bottomSheetControllerGlobalCustomAssigned;
dynamic bottomSheetControllerGlobal;

bool getIsFullScreen(context) {
  return getWidthNavigationSidebar(context) > 0;
}

double getWidthBottomSheet(context) {
  double maxWidth = 650;
  return MediaQuery.sizeOf(context).width - getWidthNavigationSidebar(context) >
          maxWidth
      ? maxWidth
      : MediaQuery.sizeOf(context).width - getWidthNavigationSidebar(context);
}

double getHorizontalPaddingConstrained(BuildContext context,
    {bool enabled = true, double? customWidthToCalculateOn}) {
  if (enabled == false) return 0;
  double fullWidth =
      customWidthToCalculateOn ?? MediaQuery.sizeOf(context).width;
  if (fullWidth >= 550 &&
      fullWidth <= 1000 &&
      getIsFullScreen(context) == false) {
    double returnedPadding = 0;
    returnedPadding = fullWidth / 3 - 140;
    return returnedPadding < 0 ? 0 : returnedPadding;
  } else if (fullWidth <= 1000 &&
      getIsFullScreen(context) &&
      appStateSettings["expandedNavigationSidebar"] == true) {
    double returnedPadding = 0;
    returnedPadding = fullWidth / 5 - 125;
    return returnedPadding < 0 ? 0 : returnedPadding;
  }
  // When the navigation bar is closed
  else if (fullWidth <= 1000 &&
      getIsFullScreen(context) &&
      appStateSettings["expandedNavigationSidebar"] == false) {
    double returnedPadding = 0;
    returnedPadding = fullWidth / 3.5 - 125;
    return returnedPadding < 0 ? 0 : returnedPadding;
  } else if (getIsFullScreen(context) &&
      appStateSettings["expandedNavigationSidebar"] == false) {
    double returnedPadding = 0;
    returnedPadding = (fullWidth - 500) / 3;
    return returnedPadding < 0 ? 0 : returnedPadding;
  }

  return (fullWidth - getWidthBottomSheet(context)) / 3;
}

Color getPopupBackgroundColor(BuildContext context) {
  return appStateSettings["materialYou"]
      ? dynamicPastel(context, Theme.of(context).colorScheme.secondaryContainer,
          amountDark: 0.3, amountLight: 0.6)
      : getColor(context, "lightDarkAccent");
}

// Replaces sliding_sheet with native Flutter showModalBottomSheet + DraggableScrollableSheet
Future openBottomSheet(
  context,
  child, {
  bool maxHeight = true,
  bool snap = true,
  bool resizeForKeyboard = true,
  bool showScrollbar = false,
  bool fullSnap = false,
  bool popupWithKeyboard = false,
  bool isDismissable = true,
  bool useCustomController = false,
  bool reAssignBottomSheetControllerGlobal = true,
  Widget Function(BuildContext context, ScrollController scrollController,
          double sheetProgress)?
      customBuilder,
  bool useParentContextForTheme = true,
}) async {
  //minimize keyboard when open
  minimizeKeyboard(context);

  BuildContext? themeContext =
      useParentContextForTheme && isContextValidForTheme(context)
          ? context
          : null;

  return showModalBottomSheet(
    context: context,
    useRootNavigator: false,
    isScrollControlled: true,
    enableDrag: isDismissable,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (context) {
      if (checkIfDefaultThemeData(themeContext)) themeContext = null;

      Color bottomPaddingColor =
          getPopupBackgroundColor(themeContext ?? context);

      return Container(
        constraints: BoxConstraints(
          maxWidth: getWidthBottomSheet(context),
        ),
        decoration: BoxDecoration(
          color: bottomPaddingColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(
                getPlatform() == PlatformOS.isIOS ? 10 : 20),
            topEnd: Radius.circular(
                getPlatform() == PlatformOS.isIOS ? 10 : 20),
          ),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: fullSnap || popupWithKeyboard ? 0.95 : 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          snap: snap,
          snapSizes: fullSnap || popupWithKeyboard || getIsFullScreen(context)
              ? [0.95, 1.0]
              : [0.6, 1.0],
          builder: (context, scrollController) {
            if (customBuilder != null) {
              return Material(
                child: Theme(
                  data: Theme.of(themeContext ?? context),
                  child: customBuilder(
                      context, scrollController, 1.0),
                ),
              );
            }
            return Material(
              child: Theme(
                data: Theme.of(themeContext ?? context),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

bool isContextValidForTheme(context) {
  try {
    Theme.of(context);
    return true;
  } catch (e) {
    return false;
  }
}

bool checkIfDefaultThemeData(BuildContext? context) {
  try {
    return context != null &&
        Theme.of(context).primaryColor == ThemeData().primaryColor &&
        Theme.of(context).secondaryHeaderColor ==
            ThemeData().secondaryHeaderColor &&
        Theme.of(context).colorScheme.background ==
            ThemeData().colorScheme.background &&
        Theme.of(context).cardColor == ThemeData().cardColor;
  } catch (e) {
    return true;
  }
}
