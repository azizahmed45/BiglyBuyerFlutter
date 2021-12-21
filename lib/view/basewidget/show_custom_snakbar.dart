import 'package:flutter/material.dart';
import 'package:bigly24/utill/color_resources.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? ColorResources.getRed(context) : Colors.green,
    content: Text(message),
  ));
}
