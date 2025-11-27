import 'dart:io';

import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/app_config/constant/responsive.dart';
import 'package:amonoroze_panel_admin/feature/feature_upload/upload_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CircleAvatarGlobal extends StatelessWidget {
  const CircleAvatarGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return GetBuilder<UploadController>(
      initState: (state) {
        Get.lazyPut(() => UploadController());
      },
      builder: (logic) {
        return SizedBox(
          height: isMobile ? 80.w : 25.w,
          width: isMobile ? 80.w : 25.w,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Positioned.fill(
                child: ClipOval(
                  child: logic.webImageUrl == null
                      ? Image.network(
                          "https://i.postimg.cc/6qwD52gs/image.png",
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        )
                      : kIsWeb
                      ? Image.network(logic.webImageUrl!, fit: BoxFit.cover)
                      : logic.imageName == ''? Image.file(
                          File(logic.pickedFile!.path),
                          fit: BoxFit.cover,
                        ): Image.network(
                          "$baseImageUrl/${logic.imageName}",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  alignment: Alignment.bottomLeft,
                  onPressed: () {
                    logic.uploadImage();
                  },
                  icon: Icon(Icons.upload),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
