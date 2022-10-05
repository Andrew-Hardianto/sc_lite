import 'package:flutter/material.dart';

class TextDate extends StatelessWidget {
  final VoidCallback onClick;
  final TextEditingController ctrl;
  final String hint;
  final TextAlign align;

  const TextDate({
    Key? key,
    required this.onClick,
    required this.ctrl,
    required this.hint,
    required this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 50,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        textAlign: align,
        style: const TextStyle(fontSize: 14),
        controller: ctrl,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: -10),
          icon: const Icon(
            Icons.calendar_today,
            size: 18,
          ),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12),
          border: InputBorder.none,
        ),
        readOnly: true,
        onTap: onClick,
      ),
    );
  }
}
