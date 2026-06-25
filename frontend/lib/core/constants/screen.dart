import 'package:flutter/material.dart';

class Screen {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool phone(BuildContext context) =>
      width(context) < 600;

  static bool tablet(BuildContext context) =>
      width(context) >= 600 &&
      width(context) < 1000;

  static bool desktop(BuildContext context) =>
      width(context) >= 1000;

  static double padding(BuildContext context) {
    if (phone(context)) return 16;
    if (tablet(context)) return 24;
    return 32;
  }

  static double cardWidth(BuildContext context) {
    if (phone(context)) return width(context) * .95;
    if (tablet(context)) return width(context) * .75;
    return width(context) * .60;
  }

  static double cardHeight(BuildContext context) {
    if (phone(context)) return height(context) * .58;
    if (tablet(context)) return height(context) * .62;
    return height(context) * .70;
  }

  static double title(BuildContext context) {
    if (phone(context)) return 28;
    if (tablet(context)) return 34;
    return 40;
  }

  static double body(BuildContext context) {
    if (phone(context)) return 15;
    return 17;
  }
}