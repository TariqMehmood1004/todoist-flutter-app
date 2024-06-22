import 'package:flutter/material.dart';

void showSnackBarMessenger(BuildContext context,
    {String message = '', bool error = false}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: error ? Colors.white : Colors.white),
    ),
    backgroundColor: error ? Colors.red : Colors.grey.shade900,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
