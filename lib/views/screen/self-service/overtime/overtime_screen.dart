import 'package:flutter/material.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/views/widget/textdate/text_date.dart';

class OvertimeScreen extends StatefulWidget {
  static const String routeName = '/self-service/overtime';
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  final mainService = MainService();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController overtimeNotes = TextEditingController();

  DateTime? overtimeStartDate;
  DateTime? overtimeEndDate;

  DateTime? overtimeHours;
  DateTime? overtimeMinutes;

  bool isFaceId = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const TextAppbar(text: 'Overtime'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Start',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextDate(
                      align: TextAlign.end,
                      ctrl: startDate,
                      hint: 'dd/mm/yyyy',
                      onClick: () {},
                    ),
                  ),
                  const Text(
                    'End',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextDate(
                      align: TextAlign.end,
                      ctrl: endDate,
                      hint: 'dd/mm/yyyy',
                      onClick: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    height: 30,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: '#a1e6ff'.toColor()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                          textAlign: TextAlign.end,
                        ),
                        Text(
                          '$overtimeHours Hour(s) $overtimeMinutes Minute(s)',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Remark',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: TextField(
                      maxLines: 3,
                      controller: overtimeNotes,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Example : Overtime for deadline project',
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
                ],
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
                  onPressed: () {},
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
    );
  }
}
