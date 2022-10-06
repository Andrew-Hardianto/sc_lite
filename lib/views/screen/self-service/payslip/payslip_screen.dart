import 'package:flutter/material.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';

class PayslipScreen extends StatefulWidget {
  static const String routeName = '/self-service/payslip';
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
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
        child: Container(),
      ),
    );
  }
}
