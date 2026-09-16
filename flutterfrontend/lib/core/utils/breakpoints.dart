import 'package:flutter/material.dart';

class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;

  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return 4;
    if (width >= tablet) return 3;
    if (width >= mobile) return 2;
    return 2;
  }

  static double maxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return desktop;
    return width;
  }
}
