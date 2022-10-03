import 'package:flutter/material.dart';
import 'package:sc_lite/utils/extension.dart';

// Error message
showSnackbarError(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: '#F03D3D'.toColor(),
  ));
}

// Success message
showSnackbarSuccess(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.green,
  ));
}
