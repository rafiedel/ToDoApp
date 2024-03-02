import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/data/database.dart';

class ReOrderDailyTasksState{
  List<Task> dailyTasksList;
  List<int> dailyTasksIDs;
  
  ReOrderDailyTasksState({
    required this.dailyTasksList,
    required this.dailyTasksIDs
  });
}

List<Task> dailyTasksList = taskList.where((task) => task.category == 'Daily').toList();
List<int> dailyTasksIDs = dailyTasksList.map((task) => task.id).toList();

class ReOrderDailyTaskCubit extends Cubit<ReOrderDailyTasksState> {
  ReOrderDailyTaskCubit() : super(
    ReOrderDailyTasksState(
      dailyTasksList: dailyTasksList, dailyTasksIDs: dailyTasksIDs));

  void updateDailyOrder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      final task = state.dailyTasksList.removeAt(oldIndex);
      state.dailyTasksList.insert(newIndex, task);
      emit(ReOrderDailyTasksState(
        dailyTasksList: state.dailyTasksList, dailyTasksIDs: state.dailyTasksIDs));
  }

  void saveDailyTaskOrder() {
    for (int i = 0 ; i < state.dailyTasksIDs.length ; i++) {
      Task oldTask = state.dailyTasksList[i];
      Task editedDailyTask = 
        Task(
          id: state.dailyTasksIDs[i], 
          name: oldTask.name, 
          description: oldTask.description, 
          isDone: oldTask.isDone, 
          isTopPriority: oldTask.isTopPriority, 
          starts: oldTask.starts, 
          ends: oldTask.ends, 
          category: oldTask.category,
          imagesRelated: oldTask.imagesRelated
        );
      int targetedIndex = taskList.indexWhere((task) => task == oldTask);
      taskList[targetedIndex] = editedDailyTask;
    }
    taskList.sort((a,b) => a.id.compareTo(b.id));
    List<Task> updatedDailyTasksList = taskList.where((task) => task.category == 'Daily').toList();
    List<int> updatedDailyTasksIDs = updatedDailyTasksList.map((task) => task.id).toList();
    emit(ReOrderDailyTasksState(dailyTasksList: updatedDailyTasksList, dailyTasksIDs: updatedDailyTasksIDs));
  }

  void refreshDailyTaskOrder() {
    List<Task> lastDailyTasksList = taskList.where((task) => task.category == 'Daily').toList();
    List<int> lastDailyTasksIDs = lastDailyTasksList.map((task) => task.id).toList();
    emit(ReOrderDailyTasksState(dailyTasksList: lastDailyTasksList, dailyTasksIDs: lastDailyTasksIDs));
  }

}