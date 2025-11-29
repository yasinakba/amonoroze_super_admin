import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../feature_upload/upload_controller.dart';
import '../../controller/specification_controller.dart';

class EditSpecification extends StatelessWidget {
  final String specificationId;

  EditSpecification({required this.specificationId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecificationController>(initState: (state) {
      Get.lazyPut(() => SpecificationController(),);
    }, builder: (logic) {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Specification",),
          backgroundColor: Colors.white,),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Basic Info ---
              _buildSectionTitle("Basic Info"),
              SizedBox(height: 10.h),
              TextField(
                controller: logic.editTitleController,
                decoration: const InputDecoration(
                    labelText: "Title", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: logic.editDescriptionController,
                decoration: const InputDecoration(
                    labelText: "Description", border: OutlineInputBorder()),
                maxLines: 3,
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: logic.editOrderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Display Order", border: OutlineInputBorder()),
              ),

              SizedBox(height: 20.h),

              // --- 2. Settings (Type & Required) ---
              _buildSectionTitle("Settings"),
              Row(
                children: [
                  Expanded(
                    child: Obx(() =>
                        DropdownButtonFormField<String>(
                          value: logic.selectedType.value,
                          decoration: const InputDecoration(
                              labelText: "Type", border: OutlineInputBorder()),
                          items: logic.inputTypes.map((type) {
                            return DropdownMenuItem(
                                value: type, child: Text(type));
                          }).toList(),
                          onChanged: (val) => logic.selectedType.value = val!,
                        )),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() =>
                        CheckboxListTile(
                          title: const Text("Is Required?"),
                          value: logic.isRequired.value,
                          onChanged: (val) => logic.isRequired.value = val!,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        )),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // --- 3. Guide Video Upload ---
              _buildSectionTitle("Guide Video"),
              SizedBox(height: 10.h),
              GetBuilder<UploadController>(
                builder: (controller) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: controller.webVideoBytes != null ||
                            controller.videoPicked != null
                            ? const Center(child: Icon(
                            Icons.check_circle, color: Colors.green, size: 50))
                            : Center(
                          child: IconButton(
                            onPressed: () => controller.uploadVideo(),
                            icon: const Icon(Icons.cloud_upload, size: 40),
                          ),
                        ),
                      ),
                      Text("Uploaded: ${controller.selectedVideo}",
                          style: const TextStyle(color: Colors.green)),
                    ],
                  );
                },
              ),

              SizedBox(height: 20.h),

              // --- 4. Dynamic Options List ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle("Options"),
                  ElevatedButton.icon(
                    onPressed: logic.addOption,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add Option"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 10.h),

              // The Dynamic List
              Obx(() =>
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logic.optionsList.length,
                    itemBuilder: (context, index) {
                      var row = logic.optionsList[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Order Input
                              SizedBox(
                                width: 60.w,
                                child: TextField(
                                  controller: row.orderController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "Ord", isDense: true),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Value Input
                              Expanded(
                                child: TextField(
                                  controller: row.valueController,
                                  decoration: const InputDecoration(
                                      labelText: "Value (e.g. Red, XL)",
                                      isDense: true),
                                ),
                              ),
                              // Delete Button
                              IconButton(
                                icon: const Icon(
                                    Icons.delete, color: Colors.red),
                                onPressed: () => logic.removeOption(index),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )),

              SizedBox(height: 30.h),

              // --- 5. Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {
                    logic.editSpecifications(id: specificationId);
                  },
                  child: const Text("Create Specification"),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 4.sp, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
