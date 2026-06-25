import 'package:flutter/material.dart';

import '../../screens/home/home_screen.dart';
import '../../screens/swipe_screen.dart';

class AppRoutes {
  static const home = "/home";
  static const swipe = "/swipe";

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
    swipe: (_) => const SwipeScreen(),
  };
}