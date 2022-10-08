import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sc_lite/views/screen/transaction/checkinout/checkinout_list_screen.dart';

class ApprovalScreen extends StatefulWidget {
  static const String routeName = '/approval';
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
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
                              InkWell(
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
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(TimeOffScreen.routeName);
                                },
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
                              InkWell(
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
                    Text(
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
                              InkWell(
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
                              InkWell(
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
                              InkWell(
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
                              InkWell(
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
