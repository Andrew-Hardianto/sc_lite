import 'package:flutter/material.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';

class SickScreen extends StatefulWidget {
  static const String routeName = '/self-service/sick';
  const SickScreen({super.key});

  @override
  State<SickScreen> createState() => _SickScreenState();
}

class _SickScreenState extends State<SickScreen> {
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
        child: Container(),
      ),
    );
  }
}
