import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> navigatorKey;

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<void>? navigate(Widget widget) {
    return navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  Future<void>? navigateReplace(Widget widget) {
    return navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  Future<void> showDialog(Widget widget) async {
    await showAdaptiveDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context) => widget);
  }

  void showSnackbar(String message) {
    final context = navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    final snackbarWidget = SnackBar(
      content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      snackbarWidget,
    );
  }
}
