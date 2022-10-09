import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:shimmer/shimmer.dart';

class PayslipDetailScreen extends StatefulWidget {
  static const String routeName = '/self-service/payslip/payslip-detail';
  const PayslipDetailScreen({super.key});

  @override
  State<PayslipDetailScreen> createState() => _PayslipDetailScreenState();
}

class _PayslipDetailScreenState extends State<PayslipDetailScreen> {
  final mainService = MainService();
  dynamic data;
  String? payslipToken;
  String? fileName;

  num? netSalary;
  num? totalIncome;
  num? totalDeduction;
  List payslipEarnings = [];
  List payslipDeductions = [];
  bool payslipEarningsOpen = true;
  bool payslipDeductionsOpen = false;
  bool isSkeletonLoading = true;

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  getDetail() async {
    // micro
    String urlApi =
        "${await mainService.urlApi()}/api/user/self-service/payslip/detail?period=${data['period']}&runtypeid=${data['id']}";
    // mono
    "${await mainService.urlApi()}/api/user/payslip/detail?period=${data['period']}&runtypeid=${data['id']}";

    mainService.getUrlHttp(urlApi, true, (dynamic res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        mainService.hideLoading();
        print(data);
        setState(() {
          netSalary = data['jumlahDiterima'];
          totalIncome = data['gajiKotor'];
          totalDeduction = data['totalPotongan'];
          payslipEarnings = data['payslipEarnings'];
          payslipDeductions = data['payslipDeductions'];
          payslipToken = data['token'];
          fileName =
              data['nip'] + " " + data['employeeName'] + " " + data['period'];
          isSkeletonLoading = false;
        });
        toggleIncome();
      } else {
        setState(() {
          isSkeletonLoading = false;
        });
        mainService.hideLoading();
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  toggleIncome() {
    setState(() {
      payslipEarningsOpen = !payslipEarningsOpen;
    });
  }

  toggleDeduction() {
    setState(() {
      payslipDeductionsOpen = !payslipDeductionsOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const TextAppbar(text: 'Payslip'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  colors: [
                    '#3DC0F0'.toColor(),
                    '#3D8FF0'.toColor(),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const [0.1, 0.5],
                  tileMode: TileMode.clamp,
                  transform: const GradientRotation(pi / 6),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'This month net salary',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (!isSkeletonLoading)
                            Text(
                              'dwd',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (isSkeletonLoading)
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey,
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      if (isSkeletonLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey,
                          child: Container(
                            width: double.infinity,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      if (!isSkeletonLoading)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 60,
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Income',
                                    style: TextStyle(
                                      color: '#231F21'.toColor(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'data',
                                        style: TextStyle(
                                          color: '#231F21'.toColor(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          toggleIncome();
                                        },
                                        child: payslipEarningsOpen
                                            ? Icon(
                                                Icons.arrow_drop_up,
                                                color: '#3DC0F0'.toColor(),
                                                size: 40,
                                              )
                                            : const Icon(
                                                Icons.arrow_drop_down,
                                                size: 40,
                                              ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!isSkeletonLoading && payslipEarningsOpen)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 100,
                            constraints: const BoxConstraints(
                              minHeight: 100,
                              maxHeight: 200,
                            ),
                            // height: 200,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 70),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: '#F3F3F3'.toColor(),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'data',
                                      style: TextStyle(
                                        color: '#231F21'.toColor(),
                                      ),
                                    ),
                                    Text(
                                      'data',
                                      style: TextStyle(
                                        color: '#848484'.toColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Stack(
                    children: [
                      if (isSkeletonLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey,
                          child: Container(
                            width: double.infinity,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      if (!isSkeletonLoading)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 60,
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deduction',
                                    style: TextStyle(
                                      color: '#231F21'.toColor(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'data',
                                        style: TextStyle(
                                          color: '#231F21'.toColor(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          toggleDeduction();
                                        },
                                        child: payslipDeductionsOpen
                                            ? Icon(
                                                Icons.arrow_drop_up,
                                                color: '#3DC0F0'.toColor(),
                                                size: 40,
                                              )
                                            : const Icon(
                                                Icons.arrow_drop_down,
                                                size: 40,
                                              ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!isSkeletonLoading && payslipDeductionsOpen)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 100,
                            constraints: const BoxConstraints(
                              minHeight: 100,
                              maxHeight: 200,
                            ),
                            // height: 200,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 70),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: '#F3F3F3'.toColor(),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'data',
                                      style: TextStyle(
                                        color: '#231F21'.toColor(),
                                      ),
                                    ),
                                    Text(
                                      'data',
                                      style: TextStyle(
                                        color: '#848484'.toColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
