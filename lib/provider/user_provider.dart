import 'package:flutter/material.dart';
import 'package:sc_lite/models/User.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    active: false,
    alias: null,
    assignmentId: null,
    authoritiesToken: null,
    companyId: null,
    companyName: null,
    companyPicture: null,
    dailyMood: false,
    employeeId: null,
    employeeNo: null,
    employmentId: null,
    fullName: null,
    haveAPin: false,
    haveCheckIn: false,
    isDailyMood: false,
    isHaveAPin: false,
    isOffShift: false,
    moodValue: null,
    offShift: false,
    organizationName: null,
    packageName: null,
    positionName: null,
    profilePicture: null,
    shiftInDateTime: null,
    timezone: null,
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
