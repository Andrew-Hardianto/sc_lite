import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status';
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const TextAppbar(text: 'Status'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                    'assets/icon/status/permission-status.svg',
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Permission',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
                                    'assets/icon/status/sick-status.svg',
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Sick',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
                                    "assets/icon/status/leave-status.svg",
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Leave',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                    'assets/icon/status/checkinout-status.svg',
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Check In/Out',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
                                    'assets/icon/status/overtime-status.svg',
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Overtime',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
                                    "assets/icon/status/shift-change.svg",
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Shift Change',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
                                    'assets/icon/status/time-off.svg',
                                    width: 54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Time Off',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
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
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/image/status/bg-footer-status-dark.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
    );
  }
}
