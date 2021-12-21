import 'package:flutter/material.dart';
import 'package:bigly24/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}