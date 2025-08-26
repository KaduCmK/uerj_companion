import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomPageTransition<T> extends CustomTransitionPage<T> {
  static const _duration = Duration(milliseconds: 250);

  const CustomPageTransition({required super.child, super.key})
    : super(
        transitionsBuilder: _transitionsBuilder,
        transitionDuration: _duration,
        reverseTransitionDuration: _duration,
      );

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
      child: child,
    );
  }
}
