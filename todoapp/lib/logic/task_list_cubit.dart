import 'package:todoapp/data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListState{
  List<Task> taskList;

  TaskListState({
    required this.taskList
  });
}


class TaskListCubit extends Cubit<TaskListState>{

  TaskListCubit() : super(TaskListState(taskList: taskList));

  void refreshTaskList() {
    saveData();
    taskList.removeWhere((task) => task.id == 9999);
    List<Task> updatedTaskList = taskList;
    emit(TaskListState(taskList: updatedTaskList));
  }

  void addTemporaryTaskForNewCategory(String newCategory) {
    state.taskList.add(
      Task(
        id: 9999, 
        name: '', 
        description: '', 
        isDone: false, 
        isTopPriority: false, 
        starts: DateTime.now(), 
        ends: DateTime.now().add(const Duration(days: 1)), 
        category: newCategory
      )
    );
    emit(TaskListState(taskList: state.taskList));
    saveData();
  }

}