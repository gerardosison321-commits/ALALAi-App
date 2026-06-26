import 'package:flutter/material.dart';

import '../../screens/home/home_screen.dart';
import '../../screens/swipe_screen.dart';

class AppRoutes {
  static const home = '/home';
  static const swipe = '/swipe';
  static const chat = '/chat';
  static const upload = '/upload';
  static const summary = '/summary';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
    swipe: (_) => const SwipeScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case swipe:
        return MaterialPageRoute(
          builder: (_) => const SwipeScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
