import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppGradient{
  AppGradient._();

  static final ThemeData _theme=Theme.of(Get.context!);

 static LinearGradient  linearGradient1=LinearGradient(
     begin: AlignmentDirectional.topCenter,
     end: AlignmentDirectional.bottomCenter,

     colors: [

   _theme.colorScheme.primary,
   _theme.colorScheme.surfaceDim
 ]);



  static LinearGradient  linearGradient2=LinearGradient(
      begin: AlignmentDirectional.topCenter,
      end: AlignmentDirectional.bottomCenter,

      colors: [

        _theme.colorScheme.onSecondary.withAlpha(0),
        _theme.colorScheme.onSecondary
      ]);

}

