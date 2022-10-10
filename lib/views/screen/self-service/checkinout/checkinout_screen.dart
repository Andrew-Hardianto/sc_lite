import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/map/google_map_screen.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:location/location.dart';
import 'package:sc_lite/utils/extension.dart';

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

  bool takePhoto = false;
  File? image;

  int groupValue = 0;
  bool userLoc = false;
  final Location location = Location();

  double lat = 0.0;
  double lng = 0.0;

  String? selectedItem;

  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  reloadMap() {
    setState(() {
      reload -= 1 / 1;
    });
  }

  submitData(BuildContext context) {}

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
                  child: const MapScreen(),
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
                      setState(() {
                        groupValue = val;
                        if (val == 1) {
                          userLoc = true;
                        } else {
                          userLoc = false;
                        }
                      });
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
                            const Text('Take a photo!'),
                            Switch(
                                value: takePhoto,
                                onChanged: (v) {
                                  setState(() {
                                    takePhoto = v;
                                  });
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
                                // showBottomSheet(context);
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
                                          'Take Photo',
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
                          print(value);
                          setState(() {
                            selectedItem = value as String?;
                          });
                          print(value);
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
                    onPressed: isButtonActive
                        ? () {
                            submitData(context);
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
