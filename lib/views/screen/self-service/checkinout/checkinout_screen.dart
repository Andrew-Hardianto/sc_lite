import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin, sin, atan2;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/widget/map/google_map_screen.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:location/location.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class CheckinoutScreen extends StatefulWidget {
  static const String routeName = '/self-service/checkinout';
  const CheckinoutScreen({super.key});

  @override
  State<CheckinoutScreen> createState() => _CheckinoutScreenState();
}

class _CheckinoutScreenState extends State<CheckinoutScreen>
    with TickerProviderStateMixin {
  dynamic dataType;
  double reload = 0.0;

  final mainService = MainService();
  List<dynamic> purposeList = [];
  final TextEditingController _remarks = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  bool takePhoto = false;
  File? image;
  dynamic imageBytes;

  int groupValue = 0;
  bool isOutOfOffice = false;
  bool validateLoc = true;

  String userLocation = 'inOffice';

  final Location location = Location();

  double lat = 0.0;
  double lng = 0.0;

  num companyLong = 0;
  num companyLat = 0;
  num toleranceMeter = 0;

  bool maps = false;

  bool requiredSelfie = false;

  String? selectedItem;

  bool isButtonActive = false;

  dynamic formData;
  // Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    getListPurpose();
    getLocation();
    validatePhoto();
    getUserLoc();
    _remarks.addListener(isEmpty);
  }

  @override
  void dispose() {
    super.dispose();
    maps = false;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  reloadMap() {
    setState(() {
      reload -= 1 / 1;
    });
  }

  getListPurpose() async {
    String urlApi =
        '${await mainService.urlApi()}/api/lookup/global-key?name=TM_CHECKINOUT_PURPOSES';

    mainService.getUrlHttp(urlApi, false, (res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        setState(() {
          purposeList = data;
          print(purposeList);
        });
      } else {
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  getUserLoc() {
    location.onLocationChanged.listen((event) {
      // if (mounted) {
      setState(() {
        lat = event.latitude!;
        lng = event.longitude!;
        maps = true;
      });
      // }
    });
  }

  getLocation() async {
    String urlApi =
        "${await mainService.urlApi()}/api/user/home/dashboard/location";

    mainService.getUrlHttp(urlApi, false, (res) {
      if (res.statusCode != 200) {
        mainService.errorHandlingHttp(res, context);
      } else {
        var data = jsonDecode(res.body);
        // if (mounted) {
        setState(() {
          companyLat = data["latitude"];
          companyLong = data["longitude"];
          toleranceMeter = data["toleranceInMeter"];
        });
        // }
      }
    });
  }

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);
      if (img == null) return;
      setState(() {
        image = File(img.path);
      });
      // if (image != null) {
      //   var imgByte = image!.readAsBytesSync();
      //   var fileName = image!.path.split('/').last;
      //   var ext = fileName.split('.').last;

      //   imageBytes = MultipartFile.fromBytes(
      //     imgByte,
      //     filename: fileName,
      //     contentType: MediaType(
      //       'image',
      //       ext,
      //     ),
      //   );
      // }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  isEmpty() {
    if (_remarks.text == "" && isOutOfOffice ||
        isOutOfOffice && selectedItem == null ||
        requiredSelfie && image == null) {
      setState(() {
        isButtonActive = false;
      });
    } else if (_remarks.text != "" && isOutOfOffice ||
        selectedItem != null ||
        requiredSelfie && image != null) {
      setState(() {
        isButtonActive = true;
      });
    }
  }

  validatePhoto() async {
    String urlApi =
        '${await mainService.urlApi()}/api/lookup/global-key?name=TM_PROPERTIES';
    mainService.getUrlHttp(urlApi, false, (res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        var filter = data
            .where((element) =>
                element['name'] == "TM_CHECK_INOUT_REQUIRED_SELFIE")
            .toList();

        if (filter[0] != null) {
          setState(() {
            requiredSelfie = filter[0]['value'] == "Y" ? true : false;
          });
        }
        setState(() {
          takePhoto = requiredSelfie;
        });
      } else {
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  handleTogglePhoto() {
    setState(() {
      if (requiredSelfie) {
        takePhoto = true;
      } else {
        takePhoto = !takePhoto;
      }
    });
  }

  showBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        pickImage()
                            .whenComplete(() => Navigator.of(context).pop());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: image == null
                              ? BorderRadius.circular(10.0)
                              : const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                        ),
                      ),
                      child: Text(
                        'Take a Picture',
                        style: TextStyle(
                          color: '#3DC0F0'.toColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (image != null)
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            image = null;
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Delete Picture',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  selectedPurpose(dynamic value) {
    setState(() {
      selectedItem = value as String?;
    });
  }

  checkDistance(
    dynamic latitude,
    dynamic longitude,
    dynamic toleranceMeter,
    Function? callback,
  ) {
    var R = 6378137;
    var dLat = mainService.degreesToRadians(lat - latitude);
    var dLong = mainService.degreesToRadians(lng - longitude);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(mainService.degreesToRadians(companyLat)) *
            cos(mainService.degreesToRadians(companyLat)) *
            sin(dLong / 2) *
            sin(dLong / 2);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = R * c;

    if (distance > toleranceMeter) {
      validateLoc = true;
      callback!(true);
    } else {
      validateLoc = false;
      callback!(false);
    }
  }

  changeLoc(dynamic loc) {
    setState(() {
      groupValue = loc;
      if (loc == 1) {
        validateLoc = false;
        userLocation = "outOffice";
        isOutOfOffice = true;
      } else {
        validateLoc = true;
        userLocation = "inOffice";
        isOutOfOffice = false;
        getLocation();
      }
    });
  }

  submitCheckInOut(dynamic type) {
    checkDistance(companyLat, companyLong, toleranceMeter,
        (bool farFromOffice) async {
      final strBytesLat = utf8.encode(lat.toString());
      final base64Lat = base64.encode(strBytesLat);
      final strBytesLng = utf8.encode(lng.toString());
      final base64Lng = base64.encode(strBytesLng);

      Map<String, dynamic> payload = {
        "actualLatEnc": base64Lat,
        "actualLngEnc": base64Lng,
        "outOfOffice": isOutOfOffice,
        "purpose": !isOutOfOffice ? '' : selectedItem,
        "remark": !isOutOfOffice ? 'In The Office' : _remarks.text,
        "type": dataType['type'] == 'Check In' ? 'CHECKIN' : 'CHECKOUT'
      };
      print(takePhoto);
      if (takePhoto) {
        if (image == null) {
          showSnackbarError(context, 'You must take Photo!');
          mainService.hideLoading();
          return;
        } else {
          // formData = {'checkinout': payload, 'file': imageBytes};
          var imgByte = image!.readAsBytesSync();
          var fileName = image!.path.split('/').last;
          var ext = fileName.split('.').last;

          formData = http.MultipartFile.fromBytes(
            'file',
            imgByte,
            filename: fileName,
            contentType: MediaType(
              'image',
              ext,
            ),
          );
        }
      } else {
        formData = null;
      }

      if (farFromOffice) {
        if (userLocation == "outOffice") {
          submitData(type, formData, payload);
        } else {
          mainService.hideLoading();
          showSnackbarError(context, "You're too far from Office");
          return;
        }
      } else {
        submitData(type, formData, payload);
      }
    });
  }

  submitData(dynamic type, formdata, dynamic payload) async {
    String urlApi =
        '${await mainService.urlApi()}/api/user/self-service/check-in-out';

    // await mainService.postFormDataUrlApi(urlApi, payload, false, (res) {
    //   print({"res": res.response});
    //   if (res.response == "" || res.response.statusCode != 200) {
    //     mainService.hideLoading();
    //     mainService.errorHandlingDio(res, context);
    //   } else {
    //     mainService.hideLoading();
    //     if (type == 'CHECKOUT') {
    //       mainService.showModalSuccess(
    //         context,
    //         'CheckInOut',
    //         'CheckInOut',
    //         res.response ? res.response : null,
    //         null,
    //       );
    //     } else {
    //       Navigator.of(context)
    //           .pushReplacementNamed(HomeScreen.routeName)
    //           .whenComplete(() => showSnackbarSuccess(
    //               context, 'Thank You! Your Check In Successfully Submitted.'));
    //     }
    //   }
    // });
    mainService.postUrlApiHttpFormData(urlApi, false, formData, payload, (res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        if (type == 'CHECKOUT') {
          http.Response.fromStream(res).then((value) {
            var data = jsonDecode(value.body);
            mainService.showModalSuccess(
              context,
              'CheckInOut',
              'CheckInOut',
              data['id'],
              null,
            );
          });
        } else {
          Navigator.of(context)
              .pushReplacementNamed(HomeScreen.routeName)
              .whenComplete(() => showSnackbarSuccess(
                  context, 'Thank You! Your Check In Successfully Submitted.'));
        }
      } else {
        mainService.errorHandlingHttpForm(res, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dataType =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final type = dataType['type'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: TextAppbar(text: 'Check ${type == "CHECKIN" ? "In" : "Out"}'),
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type == 'CHECKIN'
                          ? 'New Day, New Spirit !'
                          : 'What a Great Day !',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedRotation(
                      turns: reload,
                      duration: const Duration(milliseconds: 1500),
                      child: InkWell(
                        onTap: () {
                          reloadMap();
                        },
                        child: const Icon(Icons.replay_outlined),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: maps
                      ? MapScreen(
                          lat: lat,
                          lng: lng,
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey,
                          child: Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: const EdgeInsets.only(top: 15),
                  child: CupertinoSegmentedControl(
                    selectedColor: '#3DC0F0'.toColor(),
                    borderColor: '#3DC0F0'.toColor(),
                    pressedColor: Colors.blue.shade300,
                    groupValue: groupValue,
                    children: const {
                      0: Text(
                        'In The Office',
                        style: TextStyle(fontSize: 14),
                      ),
                      1: Text(
                        'Outside The Office',
                        style: TextStyle(fontSize: 14),
                      ),
                    },
                    onValueChanged: (val) {
                      changeLoc(val);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            !takePhoto
                                ? const Text(
                                    'Take a photo!',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const Text('Selfie your passion !',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                            if (!requiredSelfie)
                              Switch(
                                  value: takePhoto,
                                  onChanged: (v) {
                                    handleTogglePhoto();
                                  })
                          ],
                        ),
                        if (takePhoto)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.shade200,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                showBottomSheet(context);
                              },
                              child: image == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.camera_enhance,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Take / Upload Photos',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    )
                                  : Image.file(image!),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (groupValue == 1)
                  Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Purpose ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          hintText: 'Example : Work From Home',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        items: purposeList.map((element) {
                          return DropdownMenuItem(
                            value: element['value'],
                            child: Text(element['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedPurpose(value);
                        },
                        value: selectedItem,
                      ),
                    ],
                  ),
                if (groupValue == 1)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Remarks ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        TextField(
                          controller: _remarks,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Example : Fixing Module',
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: '#3DC0F0'.toColor(),
                              ),
                            ),
                          ),
                          cursorColor: '#3DC0F0'.toColor(),
                        )
                      ],
                    ),
                  ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: ['#3DC0F0'.toColor(), '#3D8FF0'.toColor()],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.5, 0.8]),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: isButtonActive || !isOutOfOffice
                        ? () {
                            submitCheckInOut(type);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.blue.shade200,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // backgroundColor: Colors.transparent,
                      // shadowColor: Colors.transparent,
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
        ));
  }
}
