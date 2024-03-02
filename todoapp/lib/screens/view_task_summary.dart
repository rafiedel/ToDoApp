import 'package:flutter/material.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/utils/task_customize_tile.dart';

class ViewSummaryTask extends StatelessWidget {
  final List<Task> tasks;
  final String tasksTitle;
  const ViewSummaryTask({super.key, required this.tasks, required this.tasksTitle});

  @override
  Widget build(BuildContext context) {
    if (tasksTitle == 'LATE') {
      tasks.sort((a,b) => a.ends.compareTo(b.ends));
    } else {
      tasks.sort((a,b) => b.ends.compareTo(a.ends));
    }
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.only(left: phoneWidth / 100),
            child: Center(
              child: Text(
                '«',
                style: TextStyle(fontSize: phoneWidth / 15),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text('$tasksTitle TASKS', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        centerTitle: true,
        titleTextStyle: TextStyle(letterSpacing: phoneWidth/100, fontSize: phoneWidth/20, fontWeight: FontWeight.w900),
      ),
      body: ListView(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
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