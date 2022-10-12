import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/textdate/text_date.dart';

class AddTimeOff extends StatefulWidget {
  final String action;
  final Map<String, dynamic>? data;
  const AddTimeOff({
    super.key,
    required this.action,
    this.data,
  });

  @override
  State<AddTimeOff> createState() => _AddTimeOffState();
}

class _AddTimeOffState extends State<AddTimeOff> {
  final mainService = MainService();

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController timeoffNotes = TextEditingController();
  DateTime timeStartTime = DateTime.now();
  DateTime timeEndTime = DateTime.now();

  List optPurpose = [];
  String? selectedItem;
  String? selectedName;

  bool isButtonActive = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.action == 'edit') {
      timeStartTime = widget.data!['shiftStartDate'];
      timeEndTime = widget.data!['shiftEndDate'];
      startTime.text =
          DateFormat('dd MMM yyyy').format(widget.data!['shiftStartDate']);
      endTime.text =
          DateFormat('dd MMM yyyy').format(widget.data!['shiftEndDate']);
      selectedItem = widget.data!['shiftId'];
      selectedName = widget.data!['shiftName'];
      timeoffNotes.text = widget.data!['timeoffNotes'];
    }
    timeoffNotes.addListener(isEmpty);
    startTime.addListener(isEmpty);
    endTime.addListener(isEmpty);
    getPupose();
  }

  getPupose() {
    print(startTime.text);
    mainService.getGlobalKey(
      'TM_TIMEOFF_PURPOSES',
      (res) {
        if (res != null) {
          var data = jsonDecode(res);

          setState(() {
            optPurpose = data;
          });
        }
      },
      context,
    );
  }

  selectTime(String type) {
    DatePicker.showTimePicker(
      context,
      theme: const DatePickerTheme(
        containerHeight: 250.0,
      ),
      onConfirm: (time) {
        if (type == 'start') {
          setState(() {
            timeStartTime = time;
            startTime.text = DateFormat('HH:mm').format(time);
            timeEndTime = DateTime.now();
            endTime.clear();
          });
        } else {
          setState(() {
            timeEndTime = time;
            endTime.text = DateFormat('HH:mm').format(time);
            print(endTime.text);
          });
        }
      },
    );
  }

  isEmpty() {
    if ((timeoffNotes.text.trim() != "") &&
        (startTime.text.trim() != "") &&
        (endTime.text.trim() != "")) {
      setState(() {
        isButtonActive = true;
      });
    } else {
      setState(() {
        isButtonActive = false;
      });
    }
  }

  selectedPurpose(dynamic value) {
    var namePurpose =
        optPurpose.where((element) => element['value'] == value).toList();

    setState(() {
      selectedItem = value as String?;
      selectedName = namePurpose[0]['name'];
    });
  }

  addTimeOff() {
    Map<String, dynamic> data = {
      'timeoffStartTime': timeStartTime,
      'timeoffEndTime': timeStartTime,
      'timeoffNotes': timeoffNotes.text,
      'purposeName': selectedName,
    };
    return Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 2.0,
                  ),
                ),
              ),
              child: const Text(
                'Add Time Off',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: const Text(
                'Pick a time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextDate(
                        onClick: () {
                          selectTime('start');
                        },
                        ctrl: startTime,
                        hint: 'HH:mm',
                        align: TextAlign.center,
                      )
                    ],
                  ),
                  Container(
                    width: 30,
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text(
                      '-',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'End',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextDate(
                        onClick: () {
                          selectTime('end');
                        },
                        ctrl: endTime,
                        hint: 'HH:mm',
                        align: TextAlign.center,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                'What is the purpose of this time off?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 70,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'Select Purpose',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                items: optPurpose.map((element) {
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
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                'What notes would you like to give us?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: TextField(
                maxLines: 3,
                controller: timeoffNotes,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'Max. 225 words',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                cursorColor: Colors.grey,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // return null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: !isButtonActive ||
                              timeEndTime.hour < timeStartTime.hour &&
                                  timeEndTime.minute < timeStartTime.minute
                          ? null
                          : addTimeOff,
                      child: Text(widget.action == 'add' ? 'ADD' : 'EDIT'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
