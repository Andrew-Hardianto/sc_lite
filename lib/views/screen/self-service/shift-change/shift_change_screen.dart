import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/home/home_screen.dart';
import 'package:sc_lite/views/widget/action-modal/modal_delete.dart';
import 'package:sc_lite/views/widget/self-service/add-shift-change/add_shift_change.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';

class ShiftChangeScreen extends StatefulWidget {
  static const String routeName = '/self-service/shift-change';
  const ShiftChangeScreen({Key? key}) : super(key: key);

  @override
  State<ShiftChangeScreen> createState() => _ShiftChangeScreenState();
}

class _ShiftChangeScreenState extends State<ShiftChangeScreen> {
  final mainService = MainService();
  TextEditingController remark = TextEditingController();

  List<dynamic> shiftList = [];
  List<dynamic> finalShiftList = [];
  bool drag = false;
  bool isButtonActive = false;

  @override
  void dispose() {
    shiftList.clear();
    finalShiftList.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  addShift(action, int? index) {
    showDialog(
        context: context,
        builder: (context) {
          return AddShiftChange(
            action: action,
            data: action == 'add' ? null : shiftList[index!],
          );
        }).then((value) {
      print(value);
      if (value != null) {
        if (action == 'add') {
          setState(() {
            shiftList.add(value);
          });
        } else {
          setState(() {
            shiftList[index!] = value;
          });
        }
      }
    });
  }

  void deleteShift(int index) {
    setState(() {
      shiftList.removeAt(index);
    });
  }

  Future submitData() async {
    shiftList.forEach((element) {
      finalShiftList.add({
        'scheduleDateFrom':
            DateFormat('yyyy-MM-dd').format(element['shiftStartDate']),
        'scheduleDateTo':
            DateFormat('yyyy-MM-dd').format(element['shiftEndDate']),
        'shiftId': element['shiftId'],
      });
    });

    Map<String, dynamic> payload = {
      'remark': remark.text,
      'details': finalShiftList
    };
    // print(payload);
    var url = await mainService.urlApi() + '/api/v1/user/tm/changeshift';

    mainService.postUrlApi(url, true, payload, (res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        finalShiftList.clear();
        shiftList.clear();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()))
            .whenComplete(() {
          showSnackbarSuccess(context, res['message']);
        });
      } else {
        mainService.hideLoading();
        finalShiftList.clear();
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
        title: const TextAppbar(text: 'Shift Change'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'What is the reason for shift change?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextField(
                    maxLines: 5,
                    controller: remark,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Example: Shift change due health issues',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  height: 40,
                  width: double.infinity,
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
                      addShift('add', null);
                    },
                    // style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ),
                if (shiftList.length != 0 || shiftList.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: shiftList.asMap().entries.map((e) {
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      addShift('edit', e.key);
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
                                                deleteShift(e.key);
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
                                    border:
                                        Border.all(color: '#C0C0C0'.toColor()),
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
                                        'Shift Change ${e.key + 1}',
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
                                      height: 50,
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            '${DateFormat('dd MMM yyyy').format(e.value['shiftStartDate'])} - ${DateFormat('dd MMM yyyy').format(e.value['shiftEndDate'])}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text('${e.value['shiftName']}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                  ),
                Container(
                  height: 40,
                  width: double.infinity,
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
                            submitData();
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
        ),
      ),
    );
  }
}
