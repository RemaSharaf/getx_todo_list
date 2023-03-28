import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/data/models/task.dart';
import 'package:getx_todo_list/app/modules/home/controller.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/modules/home/widgets/add_card.dart';
import 'package:getx_todo_list/app/modules/home/widgets/add_dialog.dart';
import 'package:getx_todo_list/app/modules/home/widgets/task_card.dart';
import 'package:getx_todo_list/app/modules/report/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              SafeArea(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6.0.sp),
                      child: Text(
                        "My List",
                        style: TextStyle(
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(
                      () => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          ...controller.tasks
                              .map(
                                (element) => LongPressDraggable(
                                  data: element,
                                  onDragStarted: () {
                                    controller.changeDeleting(true);
                                  },
                                  onDraggableCanceled: (velocity, offset) {
                                    controller.changeDeleting(false);
                                  },
                                  onDragEnd: (details) =>
                                      controller.changeDeleting(false),
                                  feedback: Opacity(
                                    opacity: 0.8,
                                    child: TaskCard(
                                      task: element,
                                    ),
                                  ),
                                  child: TaskCard(
                                    task: element,
                                  ),
                                ),
                              )
                              .toList(),
                          AddCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ReportPage()
            ],
          )),
      floatingActionButton: DragTarget<Task>(
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess("Delete Success");
        },
        builder: (context, candidateData, rejectedData) {
          return Obx(
            () => FloatingActionButton(
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(
                    () => AddDialog(),
                    transition: Transition.downToUp,
                  );
                } else {
                  EasyLoading.showInfo("Please create your task type");
                }
              },
              backgroundColor:
                  controller.deleting.value ? Colors.red : Colors.blue,
              child: controller.deleting.value
                  ? const Icon(Icons.delete)
                  : const Icon(Icons.add),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Obx(
            () => BottomNavigationBar(
              onTap: (value) {
                controller.changeTab(value);
              },
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Padding(
                    padding: EdgeInsets.only(
                      right: 15.0.wp,
                    ),
                    child: const Icon(
                      Icons.apps,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Reports",
                  icon: Padding(
                    padding: EdgeInsets.only(
                      left: 15.0.wp,
                    ),
                    child: const Icon(
                      Icons.data_usage,
                    ),
                  ),
                ),
              ],
              currentIndex: controller.tabIndex.value,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          )),
    );
  }
}
