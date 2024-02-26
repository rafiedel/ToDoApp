import 'package:todoapp/data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EditTaskState{
  Task task;
  bool hasChange;

  EditTaskState({
    required this.task,
    required this.hasChange
  });
}



class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit() : super(
    EditTaskState(
      task: Task(
        id: 0, 
        name: '', 
        description: '', 
        isDone: false, 
        isTopPriority: false,
        starts: DateTime.now(), 
        ends: DateTime.now().add(const Duration(days: 1)), 
        category: ''
      ),
      hasChange: false
    )
  );

  void initTask(Task task) {
    emit(EditTaskState(task: task, hasChange: false));
  }

  void upForChange(bool hasChange, Task task) {
    emit(EditTaskState(task: task, hasChange:  hasChange));
  } 
}