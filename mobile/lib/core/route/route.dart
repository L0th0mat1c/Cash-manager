import 'package:flutter/cupertino.dart';
import 'package:mobileapp/controller/auth_controller.dart';
import 'package:mobileapp/controller/main_app_controller.dart';
import 'package:page_transition/page_transition.dart';
import 'constant.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AUTH_CONTROLLER_PATH:
      return _getPageTransition(AuthController(), settings);
    case MAIN_APP_CONTROLLER_PATH:
      return _getPageTransition(MainAppController(), settings);
    default:
      return _getPageTransition(AuthController(), settings);
  }
}

PageRoute _getPageTransition(Widget child, RouteSettings settings) {
  return PageTransition(
      type: PageTransitionType.fade, settings: settings, child: child);
}
