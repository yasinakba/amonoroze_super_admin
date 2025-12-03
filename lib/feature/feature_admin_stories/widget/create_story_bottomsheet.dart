import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Import your controllers and widgets
import '../../feature_category/view/widget/drop_down_category.dart';
import '../../feature_upload/upload_controller.dart';
import '../controller/admin_stories_controller.dart';

class CreateStoryBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminStoriesController>(
        initState: (state) {
          Get.lazyPut(() => AdminStoriesController(),);
        },
        builder: (controller) {
      return Container(
        padding: EdgeInsets.all(16.w),
        height: 600.h, // Adjust height as needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New Story",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              // --- 1. Image Upload Section ---
              Center(
                child: GetBuilder<UploadController>(
                  builder: (uploadCtrl) {
                    return GestureDetector(
                      onTap: () => uploadCtrl.uploadImage(),
                      // Assuming this method exists
                      child: Container(
                        height: 150.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey),
                          image: uploadCtrl.selectedImage.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(uploadCtrl.imageURL),
                            // Or FileImage if local
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: uploadCtrl.selectedImage.isEmpty
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 30.sp,
                                color: Colors.grey),
                            Text("Upload Image",
                                style: TextStyle(fontSize: 12.sp)),
                          ],
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),

              // --- 2. Main Title ---
              TextField(
                controller: controller.storyTitleController,
                decoration: InputDecoration(
                  labelText: "Story Group Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15.h),

              // --- 3. Category Dropdown ---
              Text("Select Category:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5.h),
              DropDownCategory(), // Your existing widget
              SizedBox(height: 15.h),

              // --- 4. Link Type & Product ID ---
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<AdminStoriesController>(
                        builder: (ctrl) {
                          return DropdownButtonFormField<String>(
                            value: ctrl.selectedLinkType,
                            decoration: InputDecoration(
                              labelText: "Link Type",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                            ),
                            items: ctrl.linkTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (val) {
                              ctrl.selectedLinkType = val!;
                              ctrl.update();
                            },
                          );
                        }
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.productIdController,
                      decoration: InputDecoration(
                        labelText: "Product ID",
                        hintText: "Optional",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // --- 5. Duration and Order ---
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.durationController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Duration (sec)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.orderController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Order",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // --- 6. Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    controller.createStories();
                  },
                  child: Text(
                    "Create Story",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
