import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/modules/home/controller.dart';

class DoneList extends StatelessWidget {
  DoneList({super.key});
  var homeCtrl = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doneTodos.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.0.wp,
                    vertical: 2.0.wp,
                  ),
                  child: Text(
                    "Completed (${homeCtrl.doneTodos.length})",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0.sp,
                    ),
                  ),
                ),
                ...homeCtrl.doneTodos.map(
                  (element) => Dismissible(
                    key: ObjectKey(element),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      homeCtrl.deleteDoneTodo(element);
                    },
                    background: Container(
                      color: Colors.red.withOpacity(0.8),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        color: Colors.white,
                        Icons.delete,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 9.0.wp,
                        vertical: 3.0.wp,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.done,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 4.0.wp,
                            ),
                            child: Text(
                              element["title"],
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
