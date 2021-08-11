import 'package:flutter/material.dart';

class SpecialRoute<T> extends MaterialPageRoute<T> {
  SpecialRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == "/") return child;
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class SpecialPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == "/") return child;
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
