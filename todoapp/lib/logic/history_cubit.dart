import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/data/database.dart';

class HistoryState{
  List<History> historyList;
  HistoryState({
    required this.historyList
  });
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryState(historyList: userHistoryList));

  void createTask(taskName) {
    userHistoryList.insert(0, History(taskName: taskName, action: 'create', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
    saveData();
  }

  void updateTask(taskName) {
    userHistoryList.insert(0, History(taskName: taskName, action: 'update', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
  }

  void finishTask(taskName) {
    userHistoryList.insert(0, History(taskName: taskName, action: 'finish', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
  }

  void deleteTask(taskName) {
    userHistoryList.insert(0, History(taskName: taskName, action: 'delete', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
  }

}