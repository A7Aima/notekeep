import 'package:notekeep/ui/home_screen/home_screen.dart';
import 'package:notekeep/ui/intro_screen/intro_screen.dart';
import 'package:notekeep/ui/login_screen/login_screen.dart';
import 'package:notekeep/ui/notes_screen/notes_screen.dart';
import 'package:notekeep/ui/signup_screen/signup_screen.dart';
import 'package:notekeep/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String login_screen = "/login_screen";
  static const String signup_screen = "/signup_screen";
  static const String intro_screen = "/intro_screen";
  static const String home_screen = "/home_screen";
  static const String notes_screen = "/notes_screen";

  static Route animateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case intro_screen:
        return MaterialPageRoute(
          builder: (_) => IntroScreen(),
          settings: routeSettings,
        );
      case login_screen:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: routeSettings,
        );
      case signup_screen:
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
          settings: routeSettings,
        );
      case home_screen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: routeSettings,
        );
      case notes_screen:
        return MaterialPageRoute(
          builder: (_) => NotesScreen(),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: routeSettings,
        );
    }
  }
}
