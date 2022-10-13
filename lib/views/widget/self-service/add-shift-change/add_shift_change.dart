import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/textdate/text_date.dart';

class AddShiftChange extends StatefulWidget {
  final String action;
  final Map<String, dynamic>? data;
  const AddShiftChange({Key? key, required this.action, this.data})
      : super(key: key);

  @override
  State<AddShiftChange> createState() => _AddShiftChangeState();
}

class _AddShiftChangeState extends State<AddShiftChange> {
  final mainService = MainService();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  DateTime shiftStartDate = DateTime.now();
  DateTime shiftEndDate = DateTime.now();

  List<dynamic> optShift = [];

  String? selectedItem;
  String? selectedName;

  @override
  void initState() {
    super.initState();
    getShift(context);
    if (widget.action == 'edit') {
      shiftStartDate = widget.data!['shiftStartDate'];
      shiftEndDate = widget.data!['shiftEndDate'];
      startDate.text =
          DateFormat('dd MMM yyyy').format(widget.data!['shiftStartDate']);
      endDate.text =
          DateFormat('dd MMM yyyy').format(widget.data!['shiftEndDate']);
      selectedItem = widget.data!['shiftId'];
      selectedName = widget.data!['shiftName'];
    }
  }

  selectedDate(String type) async {
    DatePicker.showDatePicker(
      context,
      theme: const DatePickerTheme(
        containerHeight: 250.0,
      ),
      minTime: type == 'end' ? shiftStartDate : DateTime(2000),
      maxTime: DateTime(DateTime.now().year, 12, 31),
      onConfirm: (time) {
        if (type == 'start') {
          shiftStartDate = time;
          startDate.text = DateFormat('dd MMM yyyy').format(time);
          shiftEndDate = DateTime.now();
          endDate.clear();
        } else {
          shiftEndDate = time;
          endDate.text = DateFormat('dd MMM yyyy').format(time);
        }
      },
    );
  }

  getShift(BuildContext context) async {
    mainService.getLookUpX('shift/shift-change', (dynamic data) {
      if (data.statusCode == 200) {
        mainService.hideLoading();
        List<dynamic> resData = jsonDecode(data.body);
        if (mounted) {
          setState(() {
            optShift = resData;
          });
        }
        return optShift;
      } else {
        mainService.hideLoading();
        // mainService.errorHandlingHttp(data, context);
      }
    });
  }

  selectedShift(value) {
    var nameShift =
        optShift.where((element) => element['id'] == value).toList();

    setState(() {
      selectedItem = value as String?;
      selectedName = nameShift[0]['name'];
    });
  }

  addShift() {
    Map<String, dynamic> data = {
      'shiftStartDate': shiftStartDate,
      'shiftEndDate': shiftEndDate,
      'shiftId': selectedItem,
      'shiftName': selectedName,
    };
    return Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: MediaQuery.of(context).size.height - 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Shift Change',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: const Text(
                'Your requested date(s) is..',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                    child: const Text(
                      'From',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                    child: const Text(
                      'To',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 32.5,
                    child: TextDate(
                      onClick: () {
                        selectedDate('start');
                      },
                      ctrl: startDate,
                      hint: 'DD/MM/YYYY',
                      align: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 20,
                    child: const Center(
                      child: Text(
                        '-',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 32.5,
                    child: TextDate(
                      onClick: () {
                        selectedDate('end');
                      },
                      ctrl: endDate,
                      hint: 'DD/MM/YYYY',
                      align: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: const Text(
                'Choose your new shift for selected date(s)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              height: 70,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'Select Shift',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                items: optShift.map((element) {
                  return DropdownMenuItem(
                    child: Text(element['name']),
                    value: element['id'],
                  );
                }).toList(),
                onChanged: (value) {
                  selectedShift(value);
                },
                value: selectedItem,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // return null;
                        },
                        child: const Text('CANCEL'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        )),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                    child: ElevatedButton(
                      onPressed: addShift,
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
