import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_auth_sentences/controller/auth_sentence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/sentence_entity.dart';


class AuthSentenceScreen extends StatelessWidget {
  const AuthSentenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthSentenceController>(initState: (state) {
      Get.lazyPut(() => AuthSentenceController(),);
    }, builder: (controller) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.sentences.length,
              itemBuilder: (context, index) {
                SentenceEntity sentence = controller.sentences[index];
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
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            sentence.text ?? "No Title",
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
                                controller.textContoller.text = sentence.text??'null';
                                controller.showBottomSheetEdit(
                                    id: sentence.id, context: context);
                              },
                                  icon: Icon(
                                    Icons.edit, color: Colors.green,)),),
                            Padding(padding: EdgeInsets.all(12),
                              child: IconButton(onPressed: () {
                                showCustomDialog(context: context,
                                    onYesPressed: () =>
                                        controller.deleteSentence(
                                            id: sentence.id,),
                                    text: 'Do you want delete',
                                    objectName: sentence.text ?? '');
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
  }
}
