import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/reorder_daily_task_cubit.dart';
import 'package:todoapp/logic/search_task_cubit.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/screens/detail_screen.dart';

class ManageDailyTasks extends StatelessWidget {
  const ManageDailyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height:  phoneWidth/20,),
          Center(
            child: Column(
              children: [
                Text(
                  'Manage Daily Task'.toUpperCase(),
                  style: TextStyle(
                    fontSize: phoneWidth/25,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text('~~ reorder & detail ~~', style: TextStyle(fontSize: phoneWidth/40, fontStyle: FontStyle.italic),)
              ],
            ),
          ),
          SizedBox(height:  phoneWidth/40,),
          BlocBuilder<ReOrderDailyTaskCubit, ReOrderDailyTasksState >(
            builder: (context, state) {
              return ReorderableListView(
                shrinkWrap: true,
                onReorder: (oldIndex, newIndex) {
                  BlocProvider.of<ReOrderDailyTaskCubit>(context).updateDailyOrder(oldIndex, newIndex);
                },
                children: [
                  for (Task task in state.dailyTasksList) 
                    ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailScren(task: task)));
                      },
                      key: ValueKey(task.name),
                      title: Text(task.name, style: TextStyle(fontSize: phoneWidth / 30, decoration: task.isDone == true? TextDecoration.lineThrough : TextDecoration.none, decorationColor: Theme.of(context).colorScheme.inversePrimary,)),
                      trailing: Icon(Icons.menu, size: phoneWidth / 25),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: phoneWidth/10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ReOrderDailyTaskCubit>(context).saveDailyTaskOrder();
                  BlocProvider.of<TaskListCubit>(context).refreshTaskList();
                  BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: phoneWidth/20, vertical: phoneWidth/100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green
                    ),
                    child: Text('SAVE', style: TextStyle(fontSize: phoneWidth/35),))
                ),
              ),
              SizedBox(width: phoneWidth/30,),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<ReOrderDailyTaskCubit>(context).refreshDailyTaskOrder();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: phoneWidth/40, vertical: phoneWidth/100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red
                    ),
                    child: Text('CANCEL', style: TextStyle(fontSize: phoneWidth/35),))),
              ),
              SizedBox(width: phoneWidth/30,),
            ],
          ),
          SizedBox(height:  phoneWidth/20,),
        ],
      ),
    );
  }
}