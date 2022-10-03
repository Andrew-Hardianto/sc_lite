import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/screen/get-started/get_started_screen.dart';
import 'dart:math' as math;

import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/widget/forgot-password/forgot_password.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mainService = MainService();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool hidePassword = true;
  bool rememberMe = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    getStorage(context);
    _passwordCtrl.addListener(isEmpty);
    _emailCtrl.addListener(isEmpty);
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.light
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  getStorage(BuildContext context) async {
    String? getStartedPage = await mainService.storage.read(key: 'firstLaunch');

    if (getStartedPage == null) {
      Future.delayed(const Duration(milliseconds: 500)).then(
        (value) => Navigator.of(context)
            .pushReplacementNamed(GetStartedScreen.routeName),
      );
    }
  }

  Future openForgotPassword() async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: const ForgotPassword(),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).then((dynamic value) {
      if (value != null) {
        mainService.handleReqOTP(value['email'], (res) async {
          var response = jsonDecode(res.body);
          if (res.statusCode == 200) {
            if (!response['error']) {
              if (response['value'] == '') {
                showSnackbarError(context, response['message']);
              } else {
                mainService.saveStorage('F&PIES!', response['value']);
                mainService.handlePostReqOTP(value, (res) {
                  if (res.statusCode == 200) {
                    showSnackbarSuccess(context,
                        '${response['message']}! Please check your Email!');
                  } else {
                    mainService.errorHandlingHttp(res, context);
                  }
                });
              }
            } else {
              showSnackbarError(context, response['message']);
            }
          } else {
            mainService.errorHandlingHttp(res, context);
          }
        });
      }
    });
  }

  submitLogin() {
    mainService.postLogin(_emailCtrl.text, _passwordCtrl.text, (res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        final jwtData = jwtDecode(data['access_token']);

        Map<String, dynamic> keyJson = {
          "tenantId": jwtData.payload['tenant_id'][0],
          "urlApi": jwtData.payload['instance_api'][0],
          "accessToken": data['access_token']
        };

        mainService.saveStorage('ACT@KN2', data['access_token']);
        mainService.saveStorage('RF@S!TK', data['refresh_token']);
        mainService.saveStorage('SPS!#WU', jsonEncode(keyJson));
        mainService.saveStorage('G!T@FTR', mainService.saveRandomColor());
        Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName));
      } else {
        mainService.errorHandlingHttpLogin(res, context);
      }
    });
  }

  isEmpty() {
    if ((_emailCtrl.text.trim() != "") && (_passwordCtrl.text.trim() != "")) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  '#3DC0F0'.toColor(),
                  '#3DF0E5'.toColor(),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: const [0.1, 0.5],
                tileMode: TileMode.clamp,
                transform: const GradientRotation(math.pi / 6)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/image/login/vector.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2.17,
                    ),
                    Image.asset(
                      'assets/image/login/login-background.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Image.asset(
                        'assets/image/login/starconnect-lite-logo.png',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Welcome to '),
                              TextSpan(
                                text: "StarConnect",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: const Text(
                          'Email/ Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 25,
                              offset: Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: const Color.fromRGBO(199, 199, 199, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_outline),
                            iconColor: Colors.grey,
                            hintText: 'Email/ Username',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: const Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 25,
                              offset: Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: const Color.fromRGBO(199, 199, 199, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _passwordCtrl,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.lock_outline),
                            iconColor: Colors.grey,
                            hintText: 'Password',
                            hintStyle: const TextStyle(fontFamily: 'Nunito'),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 10),
                                alignment: Alignment.center,
                                width: 15,
                                height: 15,
                                color: Colors.white,
                                child: Checkbox(
                                  side: const BorderSide(
                                    color:
                                        Colors.grey, //your desire colour here
                                    width: 1.5,
                                  ),
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                ),
                              ),
                              const Text(
                                'Remember Me',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => openForgotPassword(),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: !isButtonEnabled ? null : submitLogin,
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor:
                                  Colors.blue.withOpacity(0.4),
                              backgroundColor: '#3D8FF0'.toColor(),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
