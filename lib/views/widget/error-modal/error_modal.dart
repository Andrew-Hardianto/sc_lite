import 'package:flutter/material.dart';
import 'package:sc_lite/utils/extension.dart';

class ErrorModal extends StatelessWidget {
  final String message;
  const ErrorModal({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Error',
              style: TextStyle(
                color: '#595959'.toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: '#767676'.toColor(),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: '#e63232'.toColor(),
                  shadowColor: '#e63232'.toColor(),
                ),
                child: const Text('OK',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
