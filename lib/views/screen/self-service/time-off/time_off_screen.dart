import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/self-service/add-time-off/add_time_off.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/views/widget/textdate/text_date.dart';
import 'package:sc_lite/utils/extension.dart';

class TimeOffScreen extends StatefulWidget {
  static const String routeName = '/self-service/time-off';
  const TimeOffScreen({super.key});

  @override
  State<TimeOffScreen> createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<TimeOffScreen> {
  final mainService = MainService();

  TextEditingController timeOff = TextEditingController();
  DateTime timeOffDate = DateTime.now();
  List<dynamic> arrTimeOffList = [];
  List<dynamic> finalArrTimeOffList = [];

  @override
  void dispose() {
    arrTimeOffList.clear();
    finalArrTimeOffList.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  pickDate() {
    return DatePicker.showDatePicker(
      context,
      theme: const DatePickerTheme(
        containerHeight: 250.0,
      ),
      onConfirm: (time) {
        timeOffDate = time;
        timeOff.text = DateFormat('EEEE, d MMM y').format(time);
      },
    );
  }

  addTimeOff(String action, int? index) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => AddTimeOff(
        action: action,
        data: action == 'add' ? null : arrTimeOffList[index!],
      ),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const TextAppbar(text: 'Time Off'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const Text(
                'What is the reason for shift change?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextDate(
                  onClick: pickDate,
                  ctrl: timeOff,
                  hint: 'DD/MM/YYYY',
                  align: TextAlign.right,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Please add your all your request below',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      '#3DC0F0'.toColor(),
                      '#3DF0E5'.toColor(),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const [0.1, 0.8],
                    tileMode: TileMode.clamp,
                    transform: const GradientRotation(pi / 6),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  child: Text('+ Add List'),
                  onPressed: () {
                    addTimeOff('add', null);
                  },
                  // style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
