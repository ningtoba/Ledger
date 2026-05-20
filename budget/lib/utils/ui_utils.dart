import 'package:flutter/material.dart';
import 'package:budget/main.dart';

class CustomMaterialPageRoute extends MaterialPageRoute {
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

popRoute<T extends Object?>(BuildContext? context, [T? result]) {
  BuildContext? contextToPop = context;
  if (context == null) contextToPop = navigatorKey.currentContext;
  if (contextToPop == null) return;
  Navigator.of(contextToPop, rootNavigator: false).pop(result);
}

Future<bool> maybePopRoute<T extends Object?>(BuildContext? context,
    [T? result]) async {
  BuildContext? contextToPop = context;
  if (context == null) contextToPop = navigatorKey.currentContext;
  if (contextToPop == null) return false;
  return Navigator.of(contextToPop, rootNavigator: false).maybePop(result);
}

popAllRoutes(BuildContext? context) {
  BuildContext? contextToPop = context;
  if (context == null) contextToPop = navigatorKey.currentContext;
  if (contextToPop == null) return;
  Navigator.of(contextToPop, rootNavigator: false)
      .popUntil((route) => route.isFirst);
}

Future<dynamic> pushRoute(BuildContext? context, Widget page,
    {String? routeName}) async {
  BuildContext? contextToPush = context;
  if (context == null) contextToPush = navigatorKey.currentContext;
  if (contextToPush == null) return;

  minimizeKeyboard(contextToPush);

  return await Navigator.push(
    contextToPush,
    PageRouteBuilder(
      opaque: true,
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 125),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: Offset(0, 0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    ),
  );
}

minimizeKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

bool getIsKeyboardOpen(context) {
  return EdgeInsetsDirectional.zero !=
      EdgeInsets.fromViewPadding(
          View.of(context).viewInsets, View.of(context).devicePixelRatio);
}

double getKeyboardHeight(context) {
  return EdgeInsets.fromViewPadding(
          View.of(context).viewInsets, View.of(context).devicePixelRatio)
      .bottom;
}

double getKeyboardHeightForceBuild(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

double getDeviceAspectRatio(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  final double aspectRatio = size.height / size.width;
  return aspectRatio;
}
