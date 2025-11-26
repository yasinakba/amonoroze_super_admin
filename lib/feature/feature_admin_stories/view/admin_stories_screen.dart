import 'package:amonoroze_panel_admin/app_config/constant/contstant.dart';
import 'package:amonoroze_panel_admin/feature/feature_admin_stories/controller/admin_stories_controller.dart';
import 'package:amonoroze_panel_admin/feature/feature_admin_stories/entity/story_enitity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AdminStoriesScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminStoriesController>(
      initState: (state) {
        Get.lazyPut(() => AdminStoriesController());
      },
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: PagingListener<int, StoryEntity>(
                controller: controller.pagingStory,
                builder:
                    (
                      BuildContext context,
                      PagingState<int, StoryEntity> state,
                      void Function() fetchNextPage,
                    ) {
                      return PagedListView(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        builderDelegate: PagedChildBuilderDelegate<StoryEntity>(
                          itemBuilder: (context, StoryEntity item, index) {
                            return Table(
                              columnWidths: const {
                                0: FixedColumnWidth(150), // Creator
                                1: FlexColumnWidth(), // Title
                                2: FixedColumnWidth(60), // Delete button
                              },
                              border: TableBorder.all(color: Colors.grey),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        item.creatorName ?? "No Creator",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        item.title ?? "No Title",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.pink.shade200,
                                        ),
                                        onPressed: () {
                                          showCustomDialog(
                                            context: context,
                                            onYesPressed: () =>
                                                controller.deleteStories(
                                                  id: item.id ?? '',
                                                  index: index,
                                                ),
                                            text: 'Do you want to delete?',
                                            objectName: item.title ?? '',
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
              ),
            ),
          ],
        );
      },
    );
  }
}

AppBar adminStoreAppBar = AppBar(backgroundColor: Colors.white);
