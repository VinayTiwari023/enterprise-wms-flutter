import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isSmallScreen(BuildContext context) => MediaQuery.sizeOf(context).width < 480;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 480 && MediaQuery.sizeOf(context).width < 768;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

  static double responsiveSize(BuildContext context, double small, double medium, double large) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium;
    return large;
  }

  static double responsivePadding(BuildContext context) {
    return responsiveSize(context, 12, 16, 20);
  }

  static double responsiveFontSize(BuildContext context, double small, double medium, double large) {
    return responsiveSize(context, small, medium, large);
  }

  static double responsiveBorderRadius(BuildContext context) {
    return responsiveSize(context, 10, 12, 14);
  }

  static double responsiveIconSize(BuildContext context) {
    return responsiveSize(context, 18, 20, 22);
  }

  static double responsiveSpacing(BuildContext context) {
    return responsiveSize(context, 8, 12, 16);
  }

  static EdgeInsets responsiveEdgeInsets(BuildContext context) {
    final padding = responsivePadding(context);
    return EdgeInsets.all(padding);
  }

  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    final padding = responsivePadding(context);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  static EdgeInsets responsiveVerticalPadding(BuildContext context) {
    final padding = responsivePadding(context);
    return EdgeInsets.symmetric(vertical: padding);
  }
}
