import 'package:flutter/material.dart';
import 'package:sc_lite/views/screen/approval/approval_screen.dart';
import 'package:sc_lite/views/screen/checkinout/checkinout_screen.dart';
import 'package:sc_lite/views/screen/get-started/get_started_screen.dart';
import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/screen/login/login_screen.dart';
import 'package:sc_lite/views/screen/self-service/leave/leave_screen.dart';
import 'package:sc_lite/views/screen/self-service/overtime/overtime_screen.dart';
import 'package:sc_lite/views/screen/self-service/payslip/payslip-detail/payslip_detail.dart';
import 'package:sc_lite/views/screen/self-service/payslip/payslip_screen.dart';
import 'package:sc_lite/views/screen/self-service/permission/permission_screen.dart';
import 'package:sc_lite/views/screen/self-service/shift-change/shift_change_screen.dart';
import 'package:sc_lite/views/screen/self-service/sick/sick_screen.dart';
import 'package:sc_lite/views/screen/self-service/time-off/time_off_screen.dart';
import 'package:sc_lite/views/screen/status/status_screen.dart';
import 'package:sc_lite/views/screen/transaction/checkinout/checkinout_list_screen.dart';

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
    case ApprovalScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ApprovalScreen(),
      );
    case StatusScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const StatusScreen(),
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
    case PayslipScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PayslipScreen(),
      );
    case PayslipDetailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PayslipDetailScreen(),
      );
    case OvertimeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OvertimeScreen(),
      );
    case SickScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SickScreen(),
      );
    case LeaveScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LeaveScreen(),
      );
    case PermissionScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PermissionScreen(),
      );
    case CheckinoutListScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CheckinoutListScreen(),
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
