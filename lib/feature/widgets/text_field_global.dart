import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TextFiledGlobal extends StatelessWidget {
  TextEditingController controller;
  String hint;
  TextInputType type;
  IconData? icon;
  TextInputFormatter filteringTextInputFormatter;
  TextFiledGlobal({required this.type, required this.controller,required this.hint,required this.icon,required this.filteringTextInputFormatter});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool isDesktop = Responsive.isDesktop(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w),
      margin: EdgeInsetsDirectional.symmetric(vertical: 5.h),
      width:isMobile?300.w:100.w,
      height: 40.h,
      child: TextField(
        keyboardType: type,
        inputFormatters: <TextInputFormatter>[
         filteringTextInputFormatter,
        ],
        controller: controller,
        style: TextStyle(fontSize:isMobile? 14.sp:isDesktop?3.sp:6.sp,),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(icon),
          labelText: hint.tr,
        ),),
    );
  }
}