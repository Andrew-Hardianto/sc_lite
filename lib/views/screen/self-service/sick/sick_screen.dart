import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/widget/textdate/text_date.dart';

class SickScreen extends StatefulWidget {
  static const String routeName = '/self-service/sick';
  const SickScreen({super.key});

  @override
  State<SickScreen> createState() => _SickScreenState();
}

class _SickScreenState extends State<SickScreen> {
  final mainService = MainService();
  TextEditingController sickStart = TextEditingController();
  TextEditingController sickEnd = TextEditingController();
  TextEditingController peopleReplace = TextEditingController();
  TextEditingController notesSick = TextEditingController();
  PageController pageCtrl = PageController(initialPage: 0);

  int formPage = 0;
  String? sickType;
  String? sickTypeFinal;
  DateTime? sickStartDate;
  DateTime? sickStartDateFinal;
  DateTime? eligibleSickDate;
  DateTime? sickEndDate;
  DateTime? sickEndDateFinal;
  int totalSickDate = 0;

  bool completeUpload = true;

  List<dynamic> category = [];
  bool? requiredAttachment;

  String? greetingTemplate;

  dynamic acceptType;
  dynamic tempFile;

  String nameFile = "There are no files yet";
  dynamic sizeFile;
  dynamic statusUpload;

  bool isFaceId = false;

  DateTime today = DateTime.now();

  DateTime? maxStartDate;
  DateTime? minEndDate;
  DateTime? maxEndDate;

  String? selectedItem;
  String? selectedName;

  getAbsenceType(String absenceType) async {
    String url =
        "${await mainService.urlApi()}/api/lookup/mobile/tm/absence/category?name=$absenceType";

    mainService.getUrlHttp(url, true, (res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        setState(() {
          category = data;
        });
        mainService.hideLoading();
      } else {
        mainService.hideLoading();
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  selectType(value) {
    var nameShift =
        category.where((element) => element['id'] == value).toList();

    setState(() {
      selectedItem = value as String?;
      selectedName = nameShift[0]['name'];
    });
  }

  selectedDate(String type) async {
    DatePicker.showDatePicker(
      context,
      theme: const DatePickerTheme(
        containerHeight: 250.0,
      ),
      minTime: type == 'end' ? sickStartDate : DateTime(2000),
      maxTime: DateTime(DateTime.now().year, 12, 31),
      onConfirm: (time) {
        if (type == 'start') {
          sickStartDate = time;
          sickStart.text = DateFormat('dd MMM yyyy').format(time);
          sickEndDate = DateTime.now();
          sickEnd.clear();
        } else {
          sickEndDate = time;
          sickEnd.text = DateFormat('dd MMM yyyy').format(time);
        }
      },
    );
  }

  submit() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getAbsenceType("Sick");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const TextAppbar(text: 'Sick'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle_rounded,
                    color: formPage == 0 ? '#3DC0F0'.toColor() : Colors.grey,
                    size: 18,
                  ),
                  Icon(
                    Icons.circle_rounded,
                    color: formPage == 0 ? Colors.grey : '#3DC0F0'.toColor(),
                    size: 18,
                  ),
                ],
              ),
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageCtrl,
                onPageChanged: (int value) {
                  setState(() {
                    formPage = value;
                  });
                },
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [pageContent1(), buttonPage()],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [pageContent2(), buttonPage()],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pageContent1() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What type sick leave you applying for?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            width: MediaQuery.of(context).size.width - 20,
            height: 70,
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: 'Example : Sick with doctor\'s letter',
                // hintStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              items: category.map((element) {
                return DropdownMenuItem(
                  child: Text(
                    element['name'],
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  value: element['id'],
                );
              }).toList(),
              onChanged: (value) {
                selectType(value);
              },
              value: selectedItem,
            ),
          ),
          const Text(
            'From when you want to start a break?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: double.infinity,
            child: TextDate(
              align: TextAlign.right,
              ctrl: sickStart,
              hint: 'dd/mm/yyyy',
              onClick: () {
                selectedDate('start');
              },
            ),
          ),
          const Text(
            'Until when you want to rest?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            child: TextDate(
              align: TextAlign.right,
              ctrl: sickEnd,
              hint: 'dd/mm/yyyy',
              onClick: () {
                selectedDate('end');
              },
            ),
          ),
          if (totalSickDate < 0)
            Container(
              margin: const EdgeInsets.only(top: 10),
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
                    'Total Day(s) :',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    '$totalSickDate Days',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  pageContent2() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Who replaced you when you rest later?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromRGBO(199, 199, 199, 1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: peopleReplace,
              decoration: const InputDecoration(
                icon: Icon(Icons.person_outline),
                iconColor: Colors.grey,
                hintText: 'Example: Joko',
                border: InputBorder.none,
              ),
            ),
          ),
          const Text(
            'What notes would you like to give us?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: TextField(
              maxLines: 3,
              controller: notesSick,
              onChanged: (value) {
                setState(() {
                  print(value);
                });
              },
              decoration: InputDecoration(
                hintText: 'Example : Have an appointment with doctor',
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
          const Text(
            'Please send here a sick letter from your doctor',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (tempFile == null)
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: '#bbbbbb'.toColor(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Insert Document',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                if (tempFile == null) Text(nameFile),
                if (tempFile != null)
                  Container(
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/icon/absence/file-upload.svg'),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 30) / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameFile,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10),
                              ),
                              Text(
                                "$sizeFile",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                              'assets/icon/general/delete.svg'),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
          Text(
            'Documents (Maximum 5 MB)',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: '#008DC0'.toColor()),
          ),
        ],
      ),
    );
  }

  buttonPage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (formPage == 1)
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: ElevatedButton(
                onPressed: () {
                  pageCtrl.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: '#bbedff'.toColor(),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: '#1d96c3'.toColor(),
                  ),
                ),
              ),
            ),
          SizedBox(
            width: formPage == 0
                ? MediaQuery.of(context).size.width - 40
                : (MediaQuery.of(context).size.width - 60) / 2,
            child: ElevatedButton(
              onPressed: () {
                if (formPage == 0) {
                  pageCtrl.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                } else {
                  submit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: '#3dc0f0'.toColor(),
                disabledBackgroundColor: Colors.blue.shade200,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                formPage == 0 ? 'Next' : 'Submit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
