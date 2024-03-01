// ignore_for_file: non_constant_identifier_names

import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/utils/task_customize_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewAllOngoingScreen extends StatelessWidget {
  final String taskSectionName;
  const ViewAllOngoingScreen({super.key, required this.taskSectionName});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: ListView(
          children: [
            OngoingScreenAppBar(context, phoneWidth),
            SizedBox(height: phoneWidth/15,),
            OnGoingTasksContent(context, phoneWidth)
          ],
        )
    );
  }

  Widget OngoingScreenAppBar(
    BuildContext context, double phoneWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: EdgeInsets.only(left: phoneWidth/20),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, size: phoneWidth / 20),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: phoneWidth / 30),
              child: Text(
                taskSectionName,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: phoneWidth / 20,
                    letterSpacing: phoneWidth / 100,
                    fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(
              width: phoneWidth / 50,
            ),
          ],
        )
      ],
    );
  }

  Widget OnGoingTasksContent(BuildContext context, double phoneWidth) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        List<Task> ongoingTask = state.taskList.where(
        (task) {
          return DateTime.now().isAfter(task.starts) && DateTime.now().isBefore(task.ends) && task.isDone == false;
        }).toList();
        List<DateTime> allDeadlines = ongoingTask.map((task) => DateTime(task.ends.year, task.ends.month, task.ends.day)).toSet().toList();
        allDeadlines.sort((a,b) => a.compareTo(b));
        List<Map> tasksGroupedWithDeadline = allDeadlines.map(
          (deadline) {
            List<Task> tasksSorted = ongoingTask.where(
              (task) {
                return task.ends.year == deadline.year &&
                       task.ends.month == deadline.month &&
                       task.ends.day == deadline.day;
              }
            ).toList();
            return {
              'deadline' : DateTime(deadline.year, deadline.month, deadline.day)
                            == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1))
                            ? 'Today'
                            : DateFormat('MMMM, EEEE dd').format(deadline),
              'tasks' : tasksSorted
            };
          }
        ).toList();
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: tasksGroupedWithDeadline.map(
            (taskGroup) {
              String deadline = taskGroup['deadline'];
              List<Task> tasks = taskGroup['tasks'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: phoneWidth/20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          deadline,
                          style: TextStyle(
                            fontSize: phoneWidth/24,
                            fontWeight: FontWeight.w900
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: phoneWidth/100),
                          child: Text(
                            '(ends)',
                            style: TextStyle(
                              fontSize: phoneWidth/40
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: phoneWidth/20),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: tasks.map(
                        (task) {
                          return TaskCustomizeTile(task: task, phoneWidth: phoneWidth);
                        }
                      ).toList(),
                    ),
                  ),
                  SizedBox(height: phoneWidth/25,)
                ],
              );
            }
          ).toList(),
        );
      },
    );
  }
}