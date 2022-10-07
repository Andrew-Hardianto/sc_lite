import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/self-service/payslip/payslip-detail/payslip_detail.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:shimmer/shimmer.dart';

class PayslipScreen extends StatefulWidget {
  static const String routeName = '/self-service/payslip';
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  final mainService = MainService();

  List listPayslip = [];
  bool isSkeletonLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getListPayslip();
  }

  getListPayslip() async {
    String urlApi =
        "${await mainService.urlApi()}/api/user/self-service/payslip";

    mainService.getUrlHttp(urlApi, true, (dynamic res) {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        setState(() {
          listPayslip = data;
        });
      } else {
        mainService.errorHandlingHttp(res, context);
      }
      mainService.hideLoading();
      setState(() {
        isSkeletonLoading = false;
      });
    });
  }

  goToPayslipDetail(id, period) {
    Map params = {'id': id, 'period': period};

    Navigator.of(context)
        .pushNamed(PayslipDetailScreen.routeName, arguments: params);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                  mainService.convertBase64Image(mainService.imgBack)),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            margin: const EdgeInsets.only(top: 20),
            child: ListView(
              children: [
                if (isSkeletonLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey,
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black,
                      ),
                    ),
                  ),
                if (listPayslip.isEmpty && !isSkeletonLoading)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        Image.asset('assets/image/profile/no-data.png'),
                        const Text(
                          'No Data Found',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                if (listPayslip.isNotEmpty && !isSkeletonLoading)
                  const Text(
                    'Payslip List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                if (listPayslip.isNotEmpty && !isSkeletonLoading)
                  const Text(
                    'Last 3 Month',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(
                  height: 40,
                ),
                if (listPayslip.isNotEmpty && !isSkeletonLoading)
                  Column(
                    children: listPayslip.map((e) {
                      return SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Card(
                          color: '#F3F3F3'.toColor(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$e["period"] - $e["runTypeName"]',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      NumberFormat.currency(locale: 'id')
                                          .format(e["value"]),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (e['upOrDownValue'] == 1)
                                  InkWell(
                                    onTap: () {
                                      getListPayslip();
                                    },
                                    child: SvgPicture.asset(
                                        'assets/icon/self-service/payslip/arrow-up-thick.svg'),
                                  ),
                                if (e['upOrDownValue'] == -1)
                                  InkWell(
                                    onTap: () {
                                      getListPayslip();
                                    },
                                    child: SvgPicture.asset(
                                        'assets/icon/self-service/payslip/arrow-down-thick.svg'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
