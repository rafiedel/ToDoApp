import 'package:todoapp/data/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchTaskState{
  List<Task> taskBeingSearched;

  SearchTaskState({
    required this.taskBeingSearched
  });
}



class SearchTaskCubit extends Cubit<SearchTaskState>{

  List<Task> selectedTaskByDate = [];
  List<String> selectedCategory = [];

  SearchTaskCubit() : super(
    SearchTaskState(
      taskBeingSearched: taskList.where((task) => task.isDone == false).toList()
    )
  );

  void refreshTaskList() {
    saveData();
    emit(SearchTaskState(
      taskBeingSearched: taskList.where((task) => task.isDone == false).toList()));
      selectedTaskByDate.clear();
  }

  void searchTaskWithKeyword(String keyWord, DateTime selectedDay){
    List<Task> updatedList = [];
    if (selectedTaskByDate.isEmpty) {
      if (selectedCategory.isNotEmpty) {
        String selectedCategoryString = selectedCategory.join();
        updatedList = taskList.where(
          (task) {
            return 
            task.name.toLowerCase().contains(keyWord.toLowerCase()) &&
            selectedCategoryString.contains(task.category) &&
            task.isDone == false;
          }
        ).toList();
      }
      else {
        updatedList = taskList.where(
        (task) {
          return 
          task.name.toLowerCase().contains(keyWord.toLowerCase()) &&
          task.isDone == false;
        }
      ).toList();
      }
    }
    else if (selectedTaskByDate.isNotEmpty) {
      if (selectedCategory.isNotEmpty) {
        String selectedCategoryString = selectedCategory.join();
        updatedList = selectedTaskByDate.where(
        (task) {
          return 
            task.name.toLowerCase().contains(keyWord.toLowerCase())
            &&(
                task.category != 'Daily' && 
                task.starts.year == selectedDay.year &&
                task.starts.month == selectedDay.month &&
                task.starts.day == selectedDay.day
              ) || ( task.category != 'Daily' && 
                    task.ends.year == selectedDay.year &&
                    task.ends.month == selectedDay.month &&
                    task.ends.day == selectedDay.day
                    ) &&
                      selectedCategoryString.contains(task.category) &&
                      task.isDone == false;
          }
        ).toList();
      } 
      else {
        updatedList = selectedTaskByDate.where(
        (task) {
          return 
          task.name.toLowerCase().contains(keyWord.toLowerCase())
          &&(
              task.category != 'Daily' && 
              task.starts.year == selectedDay.year &&
              task.starts.month == selectedDay.month &&
              task.starts.day == selectedDay.day
            ) || ( task.category != 'Daily' && 
                  task.ends.year == selectedDay.year &&
                  task.ends.month == selectedDay.month &&
                  task.ends.day == selectedDay.day
                  ) &&
                    task.isDone == false;
          }
        ).toList();
      }
    }
    emit(SearchTaskState(taskBeingSearched: updatedList));
  }

  void searchTaskByCategorySelected(String category) {
    if (selectedCategory.contains(category)) {
      selectedCategory.remove(category);
    } else {
      selectedCategory.add(category);
    }
  }

  void clearCategorySelected() {
    selectedCategory = [];
  }

  void searchTaskByDateSelected(DateTime selectedDay) {
    selectedTaskByDate = taskList.where((task) {
    return (
      task.category != 'Daily' && 
      task.starts.year == selectedDay.year &&
      task.starts.month == selectedDay.month &&
      task.starts.day == selectedDay.day
    ) || ( task.category != 'Daily' && 
           task.ends.year == selectedDay.year &&
           task.ends.month == selectedDay.month &&
           task.ends.day == selectedDay.day
          ) &&
            task.isDone == false;
    }).toList();
    emit(SearchTaskState(taskBeingSearched: selectedTaskByDate));
  }
}