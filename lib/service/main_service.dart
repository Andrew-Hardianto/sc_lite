import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';
import 'package:encrypt/encrypt.dart' as encrypts;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MainService {
  var dio = Dio();

  // Header
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  var key = encrypts.Key.fromUtf8('1234567890987654');
  var iv = encrypts.IV.fromUtf8('1234567890987654');
  final storage = const FlutterSecureStorage();
  final _random = Random();

  int countApproval = 0;

  String? platformName;
  bool platformFaceId = false;
  String? latestAppVersion;
  String defaultImage = '../../assets/image/default_profile.png';
  String staticMapsApiKey = 'AIzaSyBVfpCw2NyVHno3vf3RoYZszzpUo1ec-j0';

  var colors = [
    "#FF757D",
    "#52EED2",
    "#FF6996",
    "#1AD4D4",
    "#FF7AB2",
    "#0FEDFB",
    "#FF8933",
    "#3BCAF8",
    "#FFB74A",
    "#3AA1FF",
    "#F8D042",
    "#3969E4",
    "#EED496",
    "#9AAFFB",
    "#DEB792",
    "#C4B6ED",
    "#6AEE8F",
    "#9A7EEC",
    "#0AD98E",
    "#E49FEA"
  ];

  String resetPasswordApi = 'https://api-master-dev.gitsolutions.id';
  int timeoutms = 35000;

  var dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  var shortDayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  var monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  var shortMonthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  var arrImageMimeType = ["image/png", "image/jpeg", "image/jpg"];
  var acceptType =
      "image/jpeg,image/png,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-powerpoint.presentation.macroEnabled.12,application/oxps,application/vnd.ms-xpsdocument,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel.sheet.macroEnabled.12,application/pdf";

  Map<String, dynamic> globalRegex = {
    'regexEmail':
        r'[A-Za-z0-9._%+-]{3,}@[a-zA-Z]{3,}([.]{1}[a-zA-Z]{2,}|[.]{1}[a-zA-Z]{2,}[.]{1}[a-zA-Z]{2,})',
    'regexNumeric': r'[0-9]*(\\.[0-9]{1,2})?$',
    'regexNumericKK': r'[0-9]{16,16}',
    'regexNumericNPWP': r'[0-9]{15,15}',
    'regexNumericBankAccount': r'[0-9]{13,13}',
    'regexAlphaNumeric': r'[a-zA-Z,.0-9-/ ]*',
    'regexAlphabetical': r'[a-zA-Z ]*',
    'regexMonthInYear': r'(^0?[1-9]$)|(^1[0-2]$)',
    'regexStrongPassword':
        r"^(?=.*[A-Z])(?=.*[#?!@$%^&*-])(?=.*[0-9])(?=.*[a-z]).{8,}$",
    'regexGPA': r"/^[0-4][.][0-9][0-9]$/"
  };

  List<dynamic> sideMenu = [
    {
      'title': 'Status',
      'url': '/status',
      'icon': 'assets/icon/home/menu/status.svg',
      'count': false
    },
    {
      'title': 'Balance',
      'url': '/balance',
      'icon': 'assets/icon/home/menu/balance.svg',
      'count': false
    },
    {
      'title': 'Approval',
      'url': '/approval',
      'icon': 'assets/icon/home/menu/approval.svg',
      'authority': 'Approval',
      'count': true
    },
    {
      'title': 'My Team',
      'url': '/my-team',
      'icon': 'assets/icon/home/menu/my-team.svg',
      'authority': 'My Team',
      'count': false
    },
    {
      'title': 'Timesheet',
      'url': '/timesheet',
      'icon': 'assets/icon/home/menu/timesheet.svg',
      'count': false
    },
    {
      'title': 'Regulation',
      'url': '/regulation',
      'icon': 'assets/icon/home/menu/regulation.svg',
      'count': false
    }
  ];

  List validSidemenu = [];

  urlApi() async {
    final String? keyJson = await storage.read(key: 'SPS!#WU');
    if (keyJson != null) {
      final url = jsonDecode(keyJson)['urlApi'];
      return url;
    }
  }

  encrypt(String plainText) {
    final encrypter = encrypts.Encrypter(encrypts.AES(key));

    final encryptedStr = encrypter.encrypt(plainText, iv: iv);
    return encryptedStr.base16.toString();
  }

  decrypt(plainText) async {
    final encrypter = encrypts.Encrypter(encrypts.AES(key));
    if (plainText != null) {
      final decrypted = encrypter.decrypt16(await plainText, iv: iv);
      return decrypted;
    } else {
      return null;
    }
  }

  saveStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  deleteStorage(String key) async {
    await storage.delete(key: key);
  }

  getRandomColor() async {
    final allValues = await storage.read(key: 'G!T@FTR');
    final decr = decrypt(allValues);
    return decr;
  }

  saveRandomColor() {
    final randomColorAvatar = colors[_random.nextInt(colors.length)];
    final color = encrypt(randomColorAvatar);
    return color;
  }

  getAuthoritiesToken() async {
    final profile = await storage.read(key: 'AU@HZS!');
    if (profile != null) {
      final token = jsonDecode(profile)['authoritiesToken'];
      final authToken = jwtDecode(token);
      return authToken.payload['authorities'];
    } else {
      return null;
    }
  }

  getAuthorities() async {
    var data = await decrypt(await storage.read(key: 'AU@HZS!'));

    var profile = jsonDecode(data);
    if (profile['authoritiesToken'] != null) {
      var authToken =
          jwtDecode(profile['authoritiesToken']).payload['authorities'];
      return authToken;
    } else {
      return [];
    }
  }

  getAccessToken() async {
    final String? keyJson = await storage.read(key: 'SPS!#WU');
    if (keyJson != null) {
      final url = jsonDecode(keyJson)['accessToken'];
      return url;
    } else {
      return null;
    }
  }

  Future getRefreshToken() async {
    return decrypt(await storage.read(key: 'RF@S!TK'));
  }

  Future<bool?> tokenExpired() async {
    final token = await getAccessToken();
    final decodeToken = jwtDecode(token);
    return decodeToken.isExpired;
  }

  getTenantId() async {
    final String? keyJson = await storage.read(key: 'SPS!#WU');
    final url = keyJson != null ? jsonDecode(keyJson)['tenantId'] : null;
    return url;
  }

  getInstanceForgotPassword() async {
    final String? instance = await storage.read(key: 'F&PIES!');
    return instance;
  }

  Future<bool> isFaceIdIphone() async {
    String? isIphone = await storage.read(key: 'F@EZS!#');
    return isIphone == 'true';
  }

  checkAuthority(dynamic authority) async {
    if (authority == null) {
      return true;
    } else {
      if (await storage.read(key: 'AU@HZS!') != null) {
        var userAuth = await getAuthorities();
        dynamic indexAuth;

        if (authority.contains(',')) {
          var arrAuthority = authority.split(',');
          indexAuth = arrAuthority
              .where((dynamic result) => userAuth.indexOf(result) != -1);
        } else {
          indexAuth = userAuth.indexOf(authority);
        }
        return indexAuth.runtimeType == bool ? indexAuth : indexAuth != -1;
      } else {
        return true;
      }
    }
  }

  checkPackage(dynamic arrPackage) {
    if (arrPackage == null) {
      return true;
    } else {
      dynamic userPackage;
      getPackageName().then((value) => userPackage = value);

      var indexPackage =
          arrPackage.findIndex((dynamic result) => result == userPackage);
      return indexPackage != -1;
    }
  }

  validateSidemenuContent(Function callback) async {
    validSidemenu = [];
    List tempSidemenu = [];

    sideMenu.asMap().forEach((index, value) async {
      if (await checkAuthority(value['authority']) == true &&
          checkPackage(value['package'])) {
        tempSidemenu.add(sideMenu[index]);
      }
    });
    return callback(tempSidemenu);
  }

  Future getPackageName() async {
    var packageName = decrypt(await storage.read(key: 'P@CKGN!'));
    return packageName;
  }

  getGlobalKey(String param, Function callback, BuildContext context) async {
    var url = '${await urlApi()}/api/lookup/global-key?name=$param';

    getUrlHttp(url, false, (dynamic res) {
      if (res.statusCode != 200) {
        errorHandlingHttp(res, context);
      } else {
        callback(res);
      }
    });
  }

  configLoding() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 40.0
      ..progressColor = Colors.yellow
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.grey.withOpacity(0.7)
      ..backgroundColor = Colors.transparent
      ..boxShadow = <BoxShadow>[]
      ..dismissOnTap = false;
  }

  showLoading() {
    configLoding();
    return EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
      indicator: Image.asset(
        'assets/loading.gif',
        width: 60,
        height: 60,
      ),
    );
  }

  hideLoading() {
    return Future.delayed(const Duration(milliseconds: 1000))
        .then((value) => EasyLoading.dismiss());
  }

  getUrl(String url, bool loading, Function callback) async {
    // Body
    Map<String, String> headers = {
      'X-TenantID': '${await getTenantId()}',
      'Authorization': 'Bearer ${await getAccessToken()}',
    };
    var res = await dio.get(url,
        options: Options(headers: headers, sendTimeout: timeoutms));

    if (loading) {
      showLoading();
    }

    try {
      return callback(res);
    } on DioError catch (e) {
      callback(e);
    }
  }

  getUrlHttp(String url, bool loading, Function callback) async {
    Map<String, String> headers = {
      'X-TenantID': '${await getTenantId()}',
      'Authorization': 'Bearer ${await getAccessToken()}',
    };

    var res = await http.get(Uri.parse(url), headers: headers).timeout(
          Duration(milliseconds: timeoutms),
          onTimeout: () => http.Response(
            'message',
            408,
          ),
        );

    if (loading) {
      showLoading();
      callback(res);
    } else {
      callback(res);
    }

    return res;
  }

  postUrlApi(String urlApi, bool loading, formData, Function callback) async {
    Map<String, String> headers = {
      'X-TenantID': '${await getTenantId()}',
      'Authorization': 'Bearer ${await getAccessToken()}',
      "content-type": "application/json"
    };

    var res = await http
        .post(Uri.parse(urlApi), headers: headers, body: jsonEncode(formData))
        .timeout(Duration(milliseconds: timeoutms));

    if (loading) {
      showLoading();
      callback(res);
    } else {
      callback(res);
    }
  }

  postFormDataUrlApi(
      String urlApi, data, bool loading, Function callback) async {
    Map<String, String> headers = {
      'X-TenantID': '${await getTenantId()}',
      'Authorization': 'Bearer ${await getAccessToken()}',
    };

    if (loading) {
      showLoading();
    }

    try {
      var formData = FormData.fromMap(data);

      var res = await dio.post(
        urlApi,
        data: formData,
        options: Options(headers: headers, sendTimeout: 35000),
      );

      return callback(res);
    } on DioError catch (e) {
      callback(e);
    }
  }

  postLogin(String email, String password, Function callback) async {
    // Body
    Map<String, String> bodyData = {
      'grant_type': 'password',
      'client_id': 'git-client',
      'username': email,
      'password': password
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.clear,
    );

    var url = Uri.parse(
        'https://keycloak-dev.gitsolutions.id/auth/realms/GIT/protocol/openid-connect/token');
    // var url = Uri.parse(
    //     'https://keycloak.starconnect.id/auth/realms/GIT/protocol/openid-connect/token');

    var res = await http
        .post(
          url,
          body: bodyData,
          headers: requestHeaders,
        )
        .timeout(
          const Duration(milliseconds: 35000),
          onTimeout: () => http.Response(
            'message',
            408,
          ),
        );
    EasyLoading.dismiss();
    return callback(res);
  }

  void errorHandlingDio(dynamic res, BuildContext context) {
    if (res.response.statusCode == 401 || res.response.statusCode == 400) {
      var msg = jsonDecode(res.response);
      if (msg == '') {
        showSnackbarError(context, msg);
      } else {
        showSnackbarError(
            context, "Can't connect to server. Please Contact Admin!");
      }
    } else {
      showSnackbarError(
          context, "Can't connect to server. Please Contact Admin!");
    }
  }

  void errorHandlingHttp(dynamic res, BuildContext context) {
    if (res.statusCode == 401 || res.statusCode == 400) {
      if (res.body != '') {
        var msg = jsonDecode(res.body)["message"];
        var err = jsonDecode(res.body)["error_description"];
        if (msg != "") {
          showSnackbarError(context, msg);
        } else {
          showSnackbarError(context, err);
        }
      }
      showSnackbarError(
          context, "Can't connect to server. Please Contact Admin!");
    } else {
      showSnackbarError(
          context, "Can't connect to server. Please Contact Admin!");
    }
  }

  void errorHandlingHttpLogin(dynamic res, BuildContext context) {
    if (res.statusCode == 401 || res.statusCode == 400) {
      if (res.body != '') {
        var msg = jsonDecode(res.body)["message"];
        var err = jsonDecode(res.body)["error_description"];
        if (err != "") {
          showSnackbarError(context, err);
        } else {
          showSnackbarError(context, msg);
        }
      }
      showSnackbarError(
          context, "Can't connect to server. Please Contact Admin!");
    } else {
      showSnackbarError(
          context, "Can't connect to server. Please Contact Admin!");
    }
  }

  handleReqOTP(String email, Function? callback) async {
    var urlApi =
        Uri.parse('$resetPasswordApi/api/credential/getinstance?email=$email');

    try {
      var res = await http.get(urlApi).timeout(
            const Duration(milliseconds: 35000),
            onTimeout: () => http.Response(
              'message',
              408,
            ),
          );
      return callback!(res);
    } on DioError catch (e) {
      return callback!(e);
    }
  }

  handlePostReqOTP(dynamic dataPost, Function? callback) async {
    final String urlApi =
        await getInstanceForgotPassword() + '/public/password/requestotp';

    var res = await http.post(Uri.parse(urlApi), body: dataPost).timeout(
          const Duration(milliseconds: 35000),
          onTimeout: () => http.Response(
            'message',
            408,
          ),
        );

    return callback!(res);
  }

  Future getImage(dynamic url) async {
    try {
      var image =
          await http.get(Uri.parse(url), headers: {'responseType': "blob"});
      var data = image.body;
      final List<int> codeUnits = data.codeUnits;
      final Uint8List unit8List = Uint8List.fromList(codeUnits);

      return unit8List;
    } catch (e) {
      return 'error';
    }
  }

  getLookUpX(String api, Function callback) async {
    String url = "${await urlApi()}/api/lookup/$api";
    getUrlHttp(url, false, (dynamic res) {
      if (res.statusCode == 200) {
        callback(res);
      } else {
        callback(res);
      }
    });
  }
}
