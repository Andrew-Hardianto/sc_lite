import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/widget/action-modal/modal_delete.dart';
import 'package:sc_lite/views/widget/self-service/add-time-off/add_time_off.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';
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
  bool isButtonActive = false;

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

  checkOverlap(DateTime starTime, DateTime endTime, String action, int? index) {
    if (action == 'add') {
      for (var i = 0; i < arrTimeOffList.length; i++) {
        DateTime dataStart = arrTimeOffList[i]['timeoffStartTime'];
        DateTime dataEnd = arrTimeOffList[i]['timeoffEndTime'];

        var erliest = arrTimeOffList.reduce((curr, next) =>
            curr['timeoffStartTime'] > next['timeoffStartTime']
                ? curr['timeoffStartTime']
                : next['timeoffStartTime']);

        var latest = arrTimeOffList.reduce((curr, next) =>
            curr['timeoffEndTime'] > next['timeoffEndTime']
                ? curr['timeoffEndTime']
                : next['timeoffEndTime']);

        // print({data['timeoffStartTime']: starTime});
        if (starTime.millisecond >= dataStart.millisecondsSinceEpoch &&
                starTime.millisecondsSinceEpoch <=
                    dataEnd.millisecondsSinceEpoch ||
            endTime.millisecondsSinceEpoch >=
                    dataStart.millisecondsSinceEpoch &&
                endTime.millisecondsSinceEpoch <=
                    dataEnd.millisecondsSinceEpoch ||
            starTime.millisecondsSinceEpoch <=
                    dataStart.millisecondsSinceEpoch &&
                endTime.millisecondsSinceEpoch >=
                    dataEnd.millisecondsSinceEpoch) {
          return true;
        } else if (starTime.millisecondsSinceEpoch <=
                erliest.millisecondsSinceEpoch &&
            endTime.millisecondsSinceEpoch >= latest.millisecondsSinceEpoch) {
          return true;
        }
      }
    }
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
        setState(() {
          isButtonActive = true;
        });
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
    ).then((dynamic value) {
      if (value != null) {
        if (action == 'add') {
          setState(() {
            arrTimeOffList.add(value);
          });
        } else {
          setState(() {
            arrTimeOffList[index!] = value;
          });
        }
      }
    });
  }

  void deleteTimeOff(int index) {
    setState(() {
      arrTimeOffList.removeAt(index);
    });
  }

  submitData() async {
    for (var element in arrTimeOffList) {
      finalArrTimeOffList.add({
        'startTime': DateFormat("HH:mm").format(
          element['timeoffStartTime'],
        ),
        'endTime': DateFormat("HH:mm").format(
          element['timeoffEndTime'],
        ),
        'reason': element['purposeName'],
        'remark': element['timeoffNotes']
      });
    }

    Map<String, dynamic> payload = {
      'dateOff': DateFormat('yyyy-MM-dd').format(timeOffDate),
      'details': finalArrTimeOffList
    };

    var url = await mainService.urlApi() + '/api/user/self-service/time-off';

    mainService.postUrlApi(url, true, payload, (res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        finalArrTimeOffList.clear();
        arrTimeOffList.clear();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()))
            .whenComplete(() {
          showSnackbarSuccess(context, res['message']);
        });
      } else {
        mainService.hideLoading();
        finalArrTimeOffList.clear();
        mainService.errorHandlingHttp(res, context);
      }
    });
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
                  onClick: () {
                    pickDate();
                  },
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
                ),
              ),
              if (arrTimeOffList.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: arrTimeOffList.asMap().entries.map((e) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  addTimeOff('edit', e.key);
                                },
                                backgroundColor: Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ModalDelete(
                                          deleteAction: () {
                                            deleteTimeOff(e.key);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      });
                                  ;
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: '#C0C0C0'.toColor()),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                )),
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: '#F2F2F2'.toColor(),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Time Off ${e.key + 1}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  height: 70,
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        '${DateFormat('dd MMM yyyy').format(e.value['timeoffStartTime'])} - ${DateFormat('dd MMM yyyy').format(e.value['timeoffEndTime'])}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text('${e.value['purposeName']}'),
                                      Text('${e.value['timeoffNotes']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: arrTimeOffList.length < 3
                      ? MediaQuery.of(context).size.height / 2.5
                      : MediaQuery.of(context).size.height / 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: ['#3DC0F0'.toColor(), '#3D8FF0'.toColor()],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.5, 0.8]),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: !isButtonActive || arrTimeOffList.isEmpty
                      ? null
                      : () {
                          submitData();
                        },
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.blue.shade200,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
