import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/screen/login/login_screen.dart';
import 'dart:math' as math;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GetStartedScreen extends StatefulWidget {
  static const String routeName = '/get-started';
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final mainService = MainService();
    PageController controller = PageController();
    int totalDots = 3;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                '#3DC0F0'.toColor(),
                '#3DF0E5'.toColor(),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.1, 0.5],
              tileMode: TileMode.clamp,
              transform: const GradientRotation(math.pi / 6),
            ),
          ),
          // padding: const EdgeInsets.only(bottom: 50),
          child: Stack(
            children: [
              PageView(
                controller: controller,
                // onPageChanged: updatePosition,
                children: const [
                  StartedPage(
                    img: 'assets/image/get-started/first-started-lite.svg',
                    title: 'More Easily Features',
                    description:
                        'They are designed with a minimalistic approach and have only lighter UI elements taken in use, flexible system allows employees work easily and better anytime, anywhere',
                    button: false,
                  ),
                  StartedPage(
                    img: 'assets/image/get-started/second-started-lite.svg',
                    title: 'Get Notified',
                    description:
                        'Don’t worry to miss something important, you can get all your information for any activity',
                    button: false,
                  ),
                  StartedPage(
                    img: 'assets/image/get-started/third-started-lite.svg',
                    title: 'Minimalist Self Services',
                    description:
                        'We only provide basic features of self-services for employees, More minimalist self-services content that you can choose to help your work activities',
                    button: true,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: InkWell(
                    onTap: () async {
                      await mainService.storage
                          .write(key: 'firstLaunch', value: 'true')
                          .then((value) => Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: '#686868'.toColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: totalDots,
                    effect: SlideEffect(
                      activeDotColor: Colors.white,
                      dotColor: '#006F9E'.toColor(),
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

class StartedPage extends StatelessWidget {
  final String img;
  final String title;
  final String description;
  final bool button;
  const StartedPage({
    super.key,
    required this.img,
    required this.title,
    required this.description,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            height: 475,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              img,
              fit: BoxFit.cover,
              // height: 50,
            ),
          ),
          Container(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (button)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              margin: const EdgeInsets.only(top: 60),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: '#3D8FF0'.toColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  await MainService()
                      .storage
                      .write(key: 'firstLaunch', value: 'true')
                      .then((value) => Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName));
                },
              ),
            ),
        ],
      ),
    );
  }
}
