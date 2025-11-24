import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_auth_sentences/entity/sentence_entity.dart';
import 'package:amonoroze_panel_admin/feature/feature_specification/controller/specification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpecificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecificationController>(initState: (state) {
      Get.lazyPut(() => SpecificationController(),);
    }, builder: (controller) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.specification.length,
              itemBuilder: (context, index) {
                SentenceEntity specify = controller.specification[index];
                return Table(
                  columnWidths: const {
                    0: FixedColumnWidth(150), // Image column
                    1: FlexColumnWidth(), // Text column
                  },
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade100,),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "$baseImageUrl/${specify.image}",
                              height: 80,
                              width: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 40),
                            ),
                          ),
                        ),

                        // Banner Title + Details
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            specify.title ?? "No Title",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Padding(padding: EdgeInsets.all(12),
                              child: IconButton(onPressed: () {
                                controller.editBottomSheet(
                                    id: specify.id, context: context);
                              },
                                  icon: Icon(
                                    Icons.edit, color: Colors.green,)),),
                            Padding(padding: EdgeInsets.all(12),
                              child: IconButton(onPressed: () {
                                showCustomDialog(context: context,
                                    onYesPressed: () =>
                                        controller.d(
                                        id: specify.id, context: context),
                                    text: 'Do you want delete',
                                    objectName: specify.title ?? '');
                              },
                                  icon: Icon(Icons.delete,
                                    color: Colors.pink.shade200,)),),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }}
