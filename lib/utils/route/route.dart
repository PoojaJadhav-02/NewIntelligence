
import 'package:flutter/material.dart';
import 'package:news_intelligence/utils/route/route_name.dart';
import 'package:news_intelligence/view/auth/login_screen.dart';
import 'package:news_intelligence/view/auth/splash_screen.dart';
import 'package:news_intelligence/view/favorites_screen.dart';
import 'package:news_intelligence/view/news_feed_screen.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteName.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RouteName.favourite:
        return MaterialPageRoute(builder: (context) => const FavoritesScreen());
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const NewsFeedScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: Center(child: Text('404\n No Page Found'))));
    }
  }
}
