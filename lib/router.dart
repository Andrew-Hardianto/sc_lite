import 'package:flutter/material.dart';
import 'package:sc_lite/views/screen/checkinout/checkinout_screen.dart';
import 'package:sc_lite/views/screen/get-started/get_started_screen.dart';
import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/screen/login/login_screen.dart';
import 'package:sc_lite/views/screen/self-service/shift-change/shift_change_screen.dart';
import 'package:sc_lite/views/screen/self-service/time-off/time_off_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case GetStartedScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const GetStartedScreen(),
      );
    case CheckinoutScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CheckinoutScreen(),
      );
    case ShiftChangeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ShiftChangeScreen(),
      );
    case TimeOffScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TimeOffScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Page not found!'),
          ),
        ),
      );
  }
}
