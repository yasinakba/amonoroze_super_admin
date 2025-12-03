import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const String baseUrl  = "http://amonoroz.com/api/v1";
const String baseImageUrl  = "http://amonoroz.com/api/v1/stream-image";
const String baseVideoUrl  = "http://amonoroz.com/api/v1/stream-image";
void showSnackBar({required String message,required String status,required bool isSucceed}){
  Get.snackbar(colorText: Colors.white,status, message,snackStyle: SnackStyle.FLOATING,backgroundColor: isSucceed?Colors.greenAccent.shade700 :Colors.redAccent.shade200,snackPosition: SnackPosition.BOTTOM,);
}

Future<void> showCustomDialog({
  required BuildContext context,
  required VoidCallback onYesPressed,
  required String text,
  required String objectName,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user can't close by tapping outside
    builder: (context) {
      bool isDesktop = Responsive.isDesktop(context);
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width:isDesktop?100.w:200.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center, text: TextSpan(
                  children: [
                    TextSpan(text: text,style: styleText),
                    TextSpan(text: objectName,style: styleText.copyWith(color: Colors.redAccent.shade100,overflow: TextOverflow.ellipsis)),
                    TextSpan(text: '?',style: styleText),
                  ]
                ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text('Cancel',style: styleButton.copyWith(color: Colors.black,fontSize: 20),),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        child: Text('Yes',style: styleButton.copyWith(color: Colors.redAccent.shade100,fontSize: 20),),
                        onPressed: () {
                          Navigator.of(context).pop();
                          onYesPressed();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


TextStyle styleButton = TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600,color: Colors.white,);
TextStyle styleText = TextStyle(fontSize: 9.sp,fontWeight: FontWeight.w500,color: Colors.black54,);