import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/modules/detail/widgets/doing_list.dart';
import 'package:getx_todo_list/app/modules/detail/widgets/done_list.dart';
import 'package:getx_todo_list/app/modules/home/controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});
  final homeCtrl = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);
    return Scaffold(
        body: Form(
      key: homeCtrl.formKey,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(3.0.wp),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                    homeCtrl.updateTodos();
                    homeCtrl.changeTask(null);
                    homeCtrl.editController.clear();
                  },
                  // icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8.0.wp,
            ),
            child: Row(
              children: [
                Icon(
                  color: color,
                  IconData(
                    task.icon,
                    fontFamily: "MaterialIcons",
                  ),
                ),
                SizedBox(
                  width: 3.0.wp,
                ),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            var totalTodos =
                homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 13.0.wp,
                vertical: 3.0.wp,
              ),
              child: Row(
                children: [
                  Text(
                    "$totalTodos Tasks",
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 3.0.wp,
                  ),
                  Expanded(
                    child: StepProgressIndicator(
                      totalSteps: totalTodos == 0 ? 1 : totalTodos,
                      currentStep: homeCtrl.doneTodos.length,
                      size: 5,
                      padding: 0,
                      selectedGradientColor: LinearGradient(
                        colors: [
                          color.withOpacity(.5),
                          color,
                        ],
                      ),
                      unselectedGradientColor: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[300]!,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.0.wp,
              horizontal: 5.0.wp,
            ),
            child: TextFormField(
              controller: homeCtrl.editController,
              autofocus: true,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                prefixIcon: Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.grey[300],
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (homeCtrl.formKey.currentState!.validate()) {
                      var success = homeCtrl.addTodo(
                        homeCtrl.editController.text,
                      );
                      if (success) {
                        EasyLoading.showSuccess("Todo item added successfully");
                      } else {
                        EasyLoading.showError("Todo item is already exist");
                      }
                      homeCtrl.editController.clear();
                    }
                  },
                  icon: const Icon(Icons.done),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your todo item";
                }
                return null;
              },
            ),
          ),
          DoingList(),
          DoneList(),
        ],
      ),
    ));
  }
}
