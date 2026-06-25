import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool mobile(BuildContext context) =>
      width(context) < 700;

  static bool tablet(BuildContext context) =>
      width(context) >= 700 &&
      width(context) < 1100;

  static bool desktop(BuildContext context) =>
      width(context) >= 1100;
}