import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/transaction/checkinout/checkinout_list_screen.dart';

class ApprovalScreen extends StatefulWidget {
  static const String routeName = '/approval';
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final mainService = MainService();

  num totalCountPermission = 0;
  num totalCountSick = 0;
  num totalCountLeave = 0;
  num totalCountOvertime = 0;
  num totalCountCheckInOut = 0;
  num totalCountShiftChange = 0;
  num totalCountTimeOff = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCountApproval();
  }

  getCountApproval() async {
    // micro
    String urlApi =
        '${await mainService.urlApi()}/api/user/self-service/data-approval/count-need-approval/all-module';
    // mono
    // String urlApi =
    //     '${await mainService.urlApi()}/api/user/dataapproval/countneedapproval/allmodule';

    mainService.getUrlHttp(urlApi, false, (dynamic res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        if (data.length != 0) {
          var absence = data.where((res) => res['name'] == "Absence").toList();

          if (absence.length != 0) {
            setState(() {
              absence[0]['detail'].forEach((count) {
                if (count['name'] == "Leave") {
                  totalCountLeave = num.parse(count['value']);
                }
                if (count['name'] == "Permission") {
                  totalCountPermission = num.parse(count['value']);
                }
                if (count['name'] == "Sick") {
                  totalCountSick = num.parse(count['value']);
                }
              });
            });
          }
          // end of set count absence

          // set count time
          var time = data.where((res) => res['name'] == "Time").toList();
          if (time.length != 0) {
            setState(() {
              time[0]['detail'].forEach((count) {
                if (count['name'] == "Check In / Out") {
                  totalCountCheckInOut = num.parse(count['value']);
                }

                // set count shift change
                if (count['name'] == "Shift Change") {
                  totalCountShiftChange = num.parse(count['value']);
                }
                // end of set count shift change

                // set count time off
                if (count['name'] == "Time Off") {
                  totalCountTimeOff = num.parse(count['value']);
                }
                // end of set count time off
              });
            });
          }
          // end of set count time

          // set count overtime
          var overtime =
              data.where((res) => res['name'] == "Overtime").toList();
          if (overtime.length != 0) {
            setState(() {
              totalCountOvertime = num.parse(overtime[0]['value']);
            });
          }
        }
      } else {
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Approval',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            // alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/image/approval/Vector.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 0,
            // alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/image/approval/Vector-1.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Absence',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              totalCountPermission != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountPermission',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .pushNamed(TimeOffScreen.routeName);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icon/approval/permission-approval.svg',
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .pushNamed(TimeOffScreen.routeName);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icon/approval/permission-approval.svg',
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Permission',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              totalCountSick != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountSick',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: SvgPicture.asset(
                                          'assets/icon/approval/sick-approval.svg',
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/icon/approval/sick-approval.svg',
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Sick',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              totalCountLeave != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountLeave',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .pushNamed(TimeOffScreen.routeName);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icon/approval/leave-approval.svg",
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .pushNamed(TimeOffScreen.routeName);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icon/approval/leave-approval.svg",
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Leave',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              totalCountCheckInOut != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountCheckInOut',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            CheckinoutListScreen.routeName,
                                            arguments: {'type': 'Approval'},
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icon/approval/checkinout-approval.svg',
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          CheckinoutListScreen.routeName,
                                          arguments: {'type': 'Approval'},
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icon/approval/checkinout-approval.svg',
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Check In/Out',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              totalCountOvertime != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountOvertime',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .pushNamed(TimeOffScreen.routeName);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icon/approval/overtime-approval.svg',
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .pushNamed(TimeOffScreen.routeName);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icon/approval/overtime-approval.svg',
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Overtime',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              totalCountShiftChange != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountShiftChange',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .pushNamed(TimeOffScreen.routeName);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icon/approval/shift-change.svg",
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .pushNamed(TimeOffScreen.routeName);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icon/approval/shift-change.svg",
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Shift Change',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              totalCountTimeOff != 0
                                  ? Badge(
                                      badgeContent: Text(
                                        '$totalCountTimeOff',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.of(context)
                                          //     .pushNamed(TimeOffScreen.routeName);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icon/approval/time-off.svg',
                                          width: 54,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .pushNamed(TimeOffScreen.routeName);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icon/approval/time-off.svg',
                                        width: 54,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Time Off',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
