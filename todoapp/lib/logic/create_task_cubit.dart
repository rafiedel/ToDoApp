import 'package:todoapp/data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class CreateTaskState{
  Task newTask;
  
  CreateTaskState({
    required this.newTask
  });
}


int latestId = taskList.map((task) => task.id).toList().reduce(max) + 1;
class CreateTaskCubit extends Cubit<CreateTaskState>{

  CreateTaskCubit() : super(
    CreateTaskState(
      newTask: Task(
      id: latestId, 
      name: '', 
      description: '', 
      isDone: false, 
      isTopPriority: false,
      starts: DateTime.now(), 
      ends: DateTime.now().add(const Duration(days: 1)), 
      category: ''
      )
    )
  );

  void refreshState() {
    latestId  = taskList.map((task) => task.id).toList().reduce(max) + 1;
    emit(
      CreateTaskState(
        newTask: Task(
        id: latestId, 
        name: '', 
        description: '', 
        isDone: false, 
        isTopPriority: false,
        starts: DateTime.now(), 
        ends: DateTime.now().add(const Duration(days: 1)), 
        category: ''
        )
      )
    );
    saveData();
  }

  void setStarts(DateTime newStartDate) {
    emit(CreateTaskState(
      newTask: Task(
        id: state.newTask.id, 
        name: state.newTask.name, 
        description: state.newTask.description, 
        isDone: state.newTask.isDone, 
        isTopPriority: state.newTask.isTopPriority,
        starts: newStartDate, 
        ends: newStartDate.add(const Duration(days: 1)), 
        category: state.newTask.category
      )
    ));
  }

  void setEnds(DateTime newEndDate) => emit(
    CreateTaskState(
      newTask: Task(
        id: state.newTask.id, 
        name: state.newTask.name, 
        description: state.newTask.description, 
        isDone: state.newTask.isDone, 
        isTopPriority: state.newTask.isTopPriority,
        starts: state.newTask.starts, 
        ends: newEndDate, 
        category: state.newTask.category
      )
    )
  );

  void setname(String newname) => emit(
    CreateTaskState(
      newTask: Task(
        id: state.newTask.id, 
        name: newname, 
        description: state.newTask.description, 
        isDone: state.newTask.isDone, 
        isTopPriority: state.newTask.isTopPriority,
        starts: state.newTask.starts, 
        ends: state.newTask.ends, 
        category: state.newTask.category
      )
    )
  );

  void setDescription(String newDescription) => emit(
    CreateTaskState(
      newTask: Task(
        id: state.newTask.id, 
        name: state.newTask.name, 
        description: newDescription, 
        isDone: state.newTask.isDone, 
        isTopPriority: state.newTask.isTopPriority,
        starts: state.newTask.starts, 
        ends: state.newTask.ends, 
        category: state.newTask.category
      )
    )
  );


  void setCategory(String newCategory) => emit(
    CreateTaskState(
      newTask: Task(
        id: state.newTask.id, 
        name: state.newTask.name, 
        description: state.newTask.description, 
        isDone: state.newTask.isDone, 
        isTopPriority: state.newTask.isTopPriority,
        starts: state.newTask.starts, 
        ends: state.newTask.ends, 
        category: newCategory
      )
    )
  );

  void setTopPriority(bool newCondition) => emit(
    CreateTaskState(
      newTask: Task(
        id: state.newTask.id, 
        name: state.newTask.name, 
        description: state.newTask.description, 
        isDone: state.newTask.isDone, 
        isTopPriority: newCondition,
        starts: state.newTask.starts, 
        ends: state.newTask.ends, 
        category: state.newTask.category
      )
    )
  );
}