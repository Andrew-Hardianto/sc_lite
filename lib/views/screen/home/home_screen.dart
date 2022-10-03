import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sc_lite/provider/user_provider.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/screen/login/login_screen.dart';
import 'dart:math' as math;
import 'package:badges/badges.dart';

import 'package:sc_lite/views/widget/present-alert-expired/present_alert_expired.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeTutorial extends StatelessWidget {
  const HomeTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      enableAutoScroll: true,
      builder: Builder(
        builder: (ctx) => HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final mainService = MainService();
  final _deviceUuidPlugin = DeviceUuid();
  RefreshController refreshCtrl = RefreshController(initialRefresh: false);
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();

  String? randomColor;
  int hour = DateTime.now().hour;
  DateTime today = DateTime.now();
  String? greet;
  String? quote;
  String? quoteBy;
  String moodToday = 'default';
  bool dailyMood = false;
  dynamic employmentId;
  bool isOffShift = false;
  dynamic shiftDateTime;
  bool isLate = false;
  bool? isCheckIn;
  bool isPayslip = false;
  bool isSpt = false;
  String packageName = '';
  num minuteDiff = 0;
  late Timer intervalLate;
  DateTime intervalTime = DateTime.now();

  String? maintenanceAlertText;
  bool maintenanceAlertShow = false;
  String? expiredDate;
  bool expiredAlertShow = false;

  List newsFeed = [];
  bool isNewsEmpty = false;

  bool isSkeletonLoading = true;
  bool isSkeletonLoadingQuickAccess = true;
  bool isSkeletonLoadingMenuAccess = true;
  bool isSkeletonLoadingNewsFeed = true;

  late Animation animationDissapoint;
  late Animation animationHappy;

  late AnimationController animationCtrl;

  double opacityDissapoint = 1.0;
  double opacityBad = 1.0;
  double opacityHappy = 1.0;

  String? tutorial;
  bool startTour = true;

  initPage() {
    // startTutorial();
    getMaintenance();
    intervalLate = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isCheckIn != null) {
        if (!isCheckIn!) {
          checkLate();
        }
      }
    });
    animationCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    animationDissapoint = Tween(begin: 0.0, end: 0.0).animate(animationCtrl);
    animationHappy = Tween(begin: 0.0, end: 0.0).animate(animationCtrl);
    mainService.storage.read(key: 'home-tutorial').then((value) {
      setState(() {
        tutorial = value;
      });
    });
  }

  @override
  void dispose() {
    intervalLate.cancel();
    animationCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  refreshPage() async {
    intervalLate.cancel();
    animationCtrl.dispose();
    intervalTime = DateTime.now();
    await Future.delayed(const Duration(milliseconds: 1000));

    initPage();
    refreshCtrl.refreshCompleted();
  }

  getProfile() async {
    String url = '${await mainService.urlApi()}/api/v1/user/profile';

    mainService.getUrlHttp(url, false, (res) async {
      if (res.statusCode == 200) {
        checkExpired();
        var data = jsonDecode(res.body);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(res.body);
        mainService.saveStorage('AU@HZS!', mainService.encrypt(res.body));
        mainService.saveStorage(
            'P@CKGN!', mainService.encrypt(data['packageName']));
        randomColor = await mainService.getRandomColor();

        mainService.validateSidemenuContent((dynamic sidemenu) {
          setState(() {
            mainService.validSidemenu = sidemenu;
          });
          // if (tutorial == null) {
          //   Future.delayed(const Duration(milliseconds: 1000))
          //       .then((value) => startTutorial());
          // }
        });

        setState(() {
          isOffShift = data['isOffShift'];
          shiftDateTime = data['shiftInDateTime'];
          employmentId = data['employmentId'];
          dailyMood = data['isDailyMood'];
          mainService.getPackageName().then((value) => packageName = value);
        });

        if (data['haveCheckIn']) {
          isCheckIn = true;
        } else {
          isCheckIn = false;
          checkLate();
        }

        setGreetings();
        getQuotes();
        checkValidation();
        updateTime();
        getCountApproval();
        getNewsFeed();

        var uuid = await _deviceUuidPlugin.getUUID();
        mainService.saveStorage("uuid", mainService.encrypt(uuid!));

        postUniqueId(
          uuid,
          await mainService
              .decrypt(await mainService.storage.read(key: "YLI2Q4W")),
        );
      } else {
        mainService.errorHandlingHttp(res, context);
      }
      setState(() {
        isSkeletonLoading = false;
      });
    });
  }

  startTutorial() {
    if (startTour) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([_key1]));
    }
  }

  setGreetings() {
    if (hour < 12) {
      greet = 'Good Morning,';
    } else if (hour >= 12 && hour <= 17) {
      greet = 'Good Afternoon,';
    } else if (hour >= 17 && hour <= 24) {
      greet = 'Good Evening,';
    }
  }

  getQuotes() async {
    String urlApi = '${await mainService.urlApi()}/api/v1/quote';

    mainService.getUrlHttp(urlApi, false, (res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        setState(() {
          quote = data['quote'];
          quoteBy = data['quoteBy'];
        });
      } else {
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  postMood(String mood) async {
    String urlApi = '${await mainService.urlApi()}/api/v1/user/dailymood';

    Map<String, dynamic> dataPost = {
      'mood': mood,
      'employmentId': employmentId
    };

    if (moodToday != 'default') {
      return;
    } else {
      setState(() {
        moodToday = mood;
      });
    }

    animationDissapoint = Tween(begin: 0.0, end: 32.0).animate(animationCtrl);
    animationHappy = Tween(begin: 0.0, end: -32.0).animate(animationCtrl);
    if (mood == 'Dissapoint') {
      setState(() {
        opacityBad = 0.0;
        opacityHappy = 0.0;
      });
    } else if (mood == 'Bad') {
      setState(() {
        opacityDissapoint = 0.0;
        opacityHappy = 0.0;
      });
    } else {
      setState(() {
        opacityBad = 0.0;
        opacityDissapoint = 0.0;
      });
    }
    animationCtrl.forward();

    await mainService.postUrlApi(urlApi, false, dataPost, (dynamic res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        showSnackbarSuccess(context, data['message']);
      } else {
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  updateTime() {
    Stream timer = Stream.periodic(const Duration(seconds: 1), (i) {
      today = today.add(const Duration(seconds: 1));
      return today;
    });

    timer.listen((data) {
      setState(() {
        intervalTime = data;
      });
    });
  }

  Future checkValidation() async {
    await mainService.getGlobalKey('PAY_PROPERTIES', (res) {
      var data = jsonDecode(res.body);
      var payslip = data
          .where((dynamic data) => data['name'] == "ENABLE_PAYSLIP_ACCESS")
          .toList();
      var spt = data
          .where((dynamic data) => data['name'] == "ENABLE_1721A1_ACCESS")
          .toList();

      setState(() {
        isPayslip = payslip[0]['value'] == 'Y' ? true : false;
        isSpt = spt[0]['value'] == 'Y' ? true : false;
      });

      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        setState(() {
          isSkeletonLoadingQuickAccess = false;
        });
      });
    }, context);
  }

  checkLate() async {
    if (!isOffShift) {
      var time1 = today.millisecondsSinceEpoch;
      var time2 = DateTime.parse(await shiftDateTime ?? today.toString())
          .millisecondsSinceEpoch;

      if (time1 <= time2) {
        isLate = false;
      }

      minuteDiff = ((time1 - time2) / 1000);
      minuteDiff /= 60;
      minuteDiff = (minuteDiff).round();
      minuteDiff = (minuteDiff).abs();

      if (isLate) {
        if (minuteDiff > 60) {
          minuteDiff = 0;
        }
      }
    }
  }

  getNewsFeed() async {
    String url = '${await mainService.urlApi()}/api/v1/newsfeed?active=true';

    mainService.getUrlHttp(url, false, (res) {
      if (res.statusCode == 200) {
        List content = jsonDecode(res.body)['content'];

        setState(() {
          newsFeed = content;
          newsFeed.sort((dynamic a, dynamic b) =>
              a['sequenceNo'] > b['sequenceNo'] ? 1 : -1);
          isNewsEmpty = newsFeed.isEmpty ? true : false;
        });
      } else {
        mainService.errorHandlingHttp(res, context);
      }

      setState(() {
        isSkeletonLoadingNewsFeed = false;
      });
    });
  }

  getMaintenance() async {
    String urlApi = '${await mainService.urlApi()}/api/v1/maintenance/alert';

    await mainService.getUrlHttp(urlApi, true, (dynamic res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        var data = jsonDecode(res.body);

        setState(() {
          maintenanceAlertText = data['announcement'];
          maintenanceAlertShow = data['maintenanceAlertShow'];
        });
        getProfile();
      } else {
        mainService.hideLoading();
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  checkExpired() async {
    String urlApi =
        '${await mainService.urlApi()}/api/v1/user/subscription/alert-expired';

    await mainService.getUrlHttp(urlApi, false, (dynamic res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data['expiredDate'] != null &&
            today.isAfter(DateTime.parse(data['expiredDate']))) {
          presentAlertExpired();
        } else {
          setState(() {
            expiredDate = data['expiredDate'] ?? '-';
            expiredAlertShow =
                maintenanceAlertShow ? false : data['expiredAlertShow'];
          });
        }
      } else {
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  postUniqueId(dynamic uuid, String firebaseToken) async {
    String url = await mainService.urlApi();
    var urlApi = "$url/api/v1/user/sys/notificationtoken";

    Map<String, dynamic> payload = {
      'deviceId': uuid,
      'tokenId': firebaseToken,
      'employeeId': employmentId,
    };

    if (payload['tokenId'] != null) {
      mainService.postUrlApi(urlApi, false, payload, (res) => {});
    }
  }

  presentAlertExpired() async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: const PresentAlertExpired(),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).then((value) => logout());
  }

  getCountApproval() async {
    String urlApi =
        '${await mainService.urlApi()}/api/user/dataapproval/countneedapproval/allmodule';

    mainService.getUrlHttp(urlApi, false, (dynamic res) {
      if (res.statusCode == 200) {
        var count = jsonDecode(res.body);

        var absenceData =
            count.where((dynamic data) => data['name'] == 'Absence');
        var timeData = count.where((dynamic data) => data['name'] == 'Time');
        var absence =
            absenceData.length == 0 ? 0 : int.parse(absenceData[0].value);
        var time = timeData.length == 0 ? 0 : int.parse(timeData[0].value);
        setState(() {
          mainService.countApproval = absence + time;
          isSkeletonLoadingMenuAccess = false;
        });
      } else {
        setState(() {
          isSkeletonLoadingMenuAccess = false;
        });
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  clickProfile() {
    return showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(10.0, 100.0, 0.0, 0.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        items: [
          PopupMenuItem<String>(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
            enabled: true,
            onTap: logout,
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              iconColor: '#3DC0F0'.toColor(), // your icon
              title: Text(
                'Setting',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: '#3DC0F0'.toColor()),
              ),
            ),
          ),
          PopupMenuItem<String>(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
            enabled: true,
            onTap: logout,
            child: const ListTile(
              leading: Icon(Icons.logout_sharp),
              iconColor: Colors.red, // your icon
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
            ),
          )
        ]);
  }

  logout() {
    mainService.deleteStorage('SPS!#WU');
    mainService.deleteStorage('AU@HZS!');
    mainService.deleteStorage('G!T@VTR');
    mainService.deleteStorage('ACT@KN2');
    mainService.deleteStorage('P@CKGN!');
    Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshCtrl,
          onRefresh: () => refreshPage(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            '#3DC0F0'.toColor(),
                            '#3DF0E5'.toColor(),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const [0.1, 0.5],
                          tileMode: TileMode.clamp,
                          transform: const GradientRotation(math.pi / 6),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {},
                            child: const Icon(
                              Icons.notifications_outlined,
                              size: 43.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          // if (startTour)
                          //   Showcase(
                          //     key: _key1,
                          //     description: 'Press button to send notification',
                          //     shapeBorder: const RoundedRectangleBorder(),
                          //     showcaseBackgroundColor: Colors.indigo,
                          //     descTextStyle: const TextStyle(
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.white,
                          //     ),
                          //     blurValue: 0.0,
                          //     child: InkWell(
                          //       onTap: clickProfile,
                          //       child: profile.profilePicture != null
                          //           ? ClipRRect(
                          //               borderRadius: BorderRadius.circular(50),
                          //               child: Image.network(
                          //                 profile.profilePicture!,
                          //                 width: 43.0,
                          //                 height: 43.0,
                          //               ),
                          //             )
                          //           : Container(
                          //               width: 43.0,
                          //               height: 43.0,
                          //               decoration: BoxDecoration(
                          //                 color: randomColor == null
                          //                     ? '#121212'.toColor()
                          //                     : '$randomColor'.toColor(),
                          //                 shape: BoxShape.circle,
                          //               ),
                          //               child: Center(
                          //                 child: Text(
                          //                   profile.alias ?? '-',
                          //                   style: const TextStyle(
                          //                       color: Colors.white,
                          //                       fontSize: 48),
                          //                 ),
                          //               ),
                          //             ),
                          //     ),
                          //   ),
                          // if (!startTour)
                          InkWell(
                            onTap: clickProfile,
                            child: profile.profilePicture != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      profile.profilePicture!,
                                      width: 43.0,
                                      height: 43.0,
                                    ),
                                  )
                                : Container(
                                    width: 43.0,
                                    height: 43.0,
                                    decoration: BoxDecoration(
                                      color: randomColor == null
                                          ? '#121212'.toColor()
                                          : '$randomColor'.toColor(),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        profile.alias ?? '-',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 48),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/icon/logo/png/logo_sc_lite.png',
                            height: 50,
                          ),
                        ),
                        if (isSkeletonLoading)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20, top: 45),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    width: 100,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    width: 150,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!isSkeletonLoading)
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 20, top: 45),
                            child: Text(
                              greet != null ? greet! : '-',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (!isSkeletonLoading)
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              profile.fullName != null
                                  ? profile.fullName!
                                  : '-',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        Container(
                          width: 325,
                          constraints: const BoxConstraints(
                            minHeight: 100,
                          ),
                          margin: const EdgeInsets.only(top: 10),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (isSkeletonLoading)
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        width: 100,
                                        height: 15.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (!isSkeletonLoading)
                                    Text(
                                      DateFormat('dd MMMM yyyy, hh:mm:ss a')
                                          .format(intervalTime),
                                      style: TextStyle(
                                        color: '#39B4E1'.toColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!dailyMood)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'How are you today?',
                                              style: TextStyle(
                                                color: '#6E6E6E'.toColor(),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            AnimatedBuilder(
                                              animation: animationCtrl,
                                              builder: (context, child) {
                                                return Row(
                                                  children: [
                                                    Transform.translate(
                                                      offset: Offset(
                                                          animationDissapoint
                                                              .value,
                                                          0),
                                                      child: AnimatedOpacity(
                                                        opacity:
                                                            opacityDissapoint,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1500),
                                                        child: InkWell(
                                                          onTap: () => postMood(
                                                              'Dissapoint'),
                                                          child: Image.asset(
                                                              'assets/icon/home/sad.png'),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Transform.translate(
                                                      offset:
                                                          const Offset(0, 0),
                                                      child: AnimatedOpacity(
                                                        opacity: opacityBad,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1500),
                                                        child: InkWell(
                                                          onTap: () =>
                                                              postMood('Bad'),
                                                          child: Image.asset(
                                                              'assets/icon/home/flat.png'),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(
                                                          animationHappy.value,
                                                          0),
                                                      child: AnimatedOpacity(
                                                        opacity: opacityHappy,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1500),
                                                        child: InkWell(
                                                          onTap: () =>
                                                              postMood('Happy'),
                                                          child: Image.asset(
                                                              'assets/icon/home/happy.png'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      if (!dailyMood)
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (isSkeletonLoading)
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor: Colors.grey,
                                              child: Container(
                                                width: dailyMood ? 295 : 150,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          if (isSkeletonLoading)
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          if (isSkeletonLoading)
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor: Colors.grey,
                                              child: Container(
                                                width: 100,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          if (!isSkeletonLoading &&
                                              !isLate &&
                                              minuteDiff <= 15 &&
                                              !isCheckIn!)
                                            Container(
                                              width: dailyMood ? 290 : 160,
                                              constraints: const BoxConstraints(
                                                minWidth: 150,
                                              ),
                                              child: Text(
                                                "You'll be late in $minuteDiff minute(s) !",
                                                style: TextStyle(
                                                  color: '#FFC700'.toColor(),
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          if (!isSkeletonLoading &&
                                              isLate &&
                                              minuteDiff != 0 &&
                                              !isCheckIn!)
                                            Container(
                                              width: dailyMood ? 290 : 160,
                                              constraints: const BoxConstraints(
                                                minWidth: 150,
                                              ),
                                              child: Text(
                                                'You already late $minuteDiff minute(s) !',
                                                style: TextStyle(
                                                  color: '#FA8787'.toColor(),
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          if ((!isSkeletonLoading &&
                                                  isCheckIn!) ||
                                              (!isSkeletonLoading &&
                                                  minuteDiff == 0 &&
                                                  isLate) ||
                                              (!isSkeletonLoading &&
                                                  minuteDiff > 15 &&
                                                  !isLate))
                                            Container(
                                              width: dailyMood ? 290 : 160,
                                              constraints: const BoxConstraints(
                                                minWidth: 150,
                                              ),
                                              child: Text(
                                                quote ?? '-',
                                                overflow: TextOverflow.clip,
                                                maxLines: 4,
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: '#6E6E6E'.toColor(),
                                                ),
                                              ),
                                            ),
                                          if ((!isSkeletonLoading &&
                                                  isCheckIn!) ||
                                              (!isSkeletonLoading &&
                                                  minuteDiff == 0 &&
                                                  isLate) ||
                                              (!isSkeletonLoading &&
                                                  minuteDiff > 15 &&
                                                  !isLate))
                                            Container(
                                              alignment: Alignment.centerRight,
                                              width: 160,
                                              constraints: const BoxConstraints(
                                                minWidth: 150,
                                              ),
                                              child: Text(
                                                quoteBy ?? '-',
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: '#6E6E6E'.toColor(),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (expiredAlertShow || maintenanceAlertShow)
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icon/home/megaphone.svg',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              if (expiredAlertShow)
                                SizedBox(
                                  width: 270,
                                  child: RichText(
                                    maxLines: 5,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text:
                                                'Your StarConnect license will expire on '),
                                        TextSpan(
                                          text: DateFormat('dd MMMM yyyy')
                                              .format(DateTime.parse(
                                                  expiredDate ?? '2022-09-23')),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const TextSpan(
                                            text:
                                                ', please contact your administrator to update your license.'),
                                      ],
                                    ),
                                  ),
                                ),
                              if (maintenanceAlertShow)
                                Text('$maintenanceAlertText')
                            ],
                          ),
                        ),
                      const Text(
                        'Popular Services',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isSkeletonLoadingQuickAccess)
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 10),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!isSkeletonLoadingQuickAccess)
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 10),
                          width: double.infinity,
                          child: Wrap(
                            spacing: 15.0,
                            runSpacing: 10.0,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/check-in.svg',
                                      width: 54,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Check In',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/leave.svg',
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
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/permission.svg',
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
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/sick.svg',
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
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/check-out.svg',
                                      width: 54,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Check Out',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/overtime.svg',
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
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/shift-change.svg',
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
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/icon/home/time-off.svg',
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
                              if ((packageName == 'Silver' ||
                                      packageName == 'Gold') &&
                                  isPayslip)
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/icon/home/payslip.svg',
                                        width: 54,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Payslip',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              if ((packageName == 'Silver' ||
                                      packageName == 'Gold') &&
                                  isSpt)
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/icon/home/spt.svg',
                                        width: 54,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      '1721A1',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
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
                if (!isNewsEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Explore Today's News",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (isSkeletonLoadingNewsFeed)
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey,
                            child: Container(
                              width: double.infinity,
                              height: 100.0,
                              margin: const EdgeInsets.only(top: 15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        if (!isSkeletonLoadingNewsFeed)
                          CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: newsFeed.length > 1 ? 0.8 : 1,
                              height: 100.0,
                              autoPlay: true,
                              disableCenter: true,
                              enlargeCenterPage: false,
                            ),
                            items: newsFeed.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          i['imagePath'],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          )
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Popular Services',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isSkeletonLoadingMenuAccess)
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 10),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!isSkeletonLoadingMenuAccess)
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top: 10),
                          width: double.infinity,
                          child: Wrap(
                            spacing: 15.0,
                            runSpacing: 10.0,
                            children: mainService.validSidemenu.map((e) {
                              return Column(
                                children: [
                                  if (mainService.countApproval != 0 &&
                                      e['count'])
                                    Badge(
                                      badgeContent: Text(
                                        '${mainService.countApproval}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: SvgPicture.asset(
                                          e['icon'],
                                          width: 54,
                                        ),
                                      ),
                                    ),
                                  if (mainService.countApproval == 0)
                                    InkWell(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        e['icon'],
                                        width: 54,
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${e['title']}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
