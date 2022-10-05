import 'package:flutter/material.dart';
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
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController timeoffNotes = TextEditingController();
  DateTime timeStartTime = DateTime.now();
  DateTime timeEndTime = DateTime.now();

  List optPupose = [];
  String? selectedItem;
  String? selectedName;

  selectedPurpose(dynamic value) {}

  addTimeOff() {}

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
                        onClick: () {},
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
                        onClick: () {},
                        ctrl: startTime,
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
                items: optPupose.map((element) {
                  return DropdownMenuItem(
                    value: element['id'],
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
                onChanged: (value) {
                  setState(() {
                    print(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Max. 225 words',
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
                        child: const Text('CANCEL'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        )),
                  ),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: addTimeOff,
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
