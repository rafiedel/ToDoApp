import 'package:flutter/material.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/utils/task_customize_tile.dart';

class ViewSummaryTask extends StatelessWidget {
  final List<Task> tasks;
  final String tasksTitle;
  const ViewSummaryTask({super.key, required this.tasks, required this.tasksTitle});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('$tasksTitle TASKS'),
        centerTitle: true,
        titleTextStyle: TextStyle(letterSpacing: phoneWidth/100, fontSize: phoneWidth/20, fontWeight: FontWeight.w900),
      ),
      body: ListView(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context,index) {
              return TaskCustomizeTile(task: tasks[index], phoneWidth: phoneWidth);
            },
          )
        ],
      )
    );
  }
}