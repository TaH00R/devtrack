import 'package:flutter/material.dart';

PageRouteBuilder<T> smoothRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    opaque: true,
    barrierColor: const Color(0xff121214),

    pageBuilder: (
      context,
      animation,
      secondaryAnimation,
    ) {
      return page;
    },

    transitionDuration: const Duration(
      milliseconds: 280,
    ),

    reverseTransitionDuration: const Duration(
      milliseconds: 220,
    ),

    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}