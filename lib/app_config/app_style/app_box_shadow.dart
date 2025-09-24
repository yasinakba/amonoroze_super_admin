import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBoxShadow {
  AppBoxShadow._();

  static final ThemeData _theme = Theme.of(Get.context!);

  static List<BoxShadow> boxShadow1 = [
    BoxShadow(
      color: _theme.colorScheme.onSecondary.withOpacity(0.05),
      offset: const Offset(0, 0),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> boxShadow2 = [
    BoxShadow(
      color: _theme.colorScheme.onSecondary.withOpacity(0.25),
      offset: const Offset(0, 0),
      blurRadius: 13,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> boxShadow3 = [
    BoxShadow(
      color: _theme.colorScheme.onSecondary.withOpacity(0.1),
      offset: Offset(0, 4),

      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];

  static List<BoxShadow> boxShadow4 = [
    BoxShadow(
      color: _theme.colorScheme.onSecondary.withOpacity(0.25),
      offset: Offset(0, 0),
      blurRadius: 9.7,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> boxShadow5 = [
    BoxShadow(
      color: _theme.colorScheme.onSecondary.withOpacity(0.25),
      offset: Offset(0, 0),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> boxShadow6 = [
    BoxShadow(
      color: _theme.colorScheme.onSecondary.withOpacity(0.05),
      offset: Offset(0, -7),
      blurRadius: 11.3,
      spreadRadius: 0,
    ),
  ];
}
