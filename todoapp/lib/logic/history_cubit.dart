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

  void createTask(taskName, id) {
    userHistoryList.insert(0, History(id: id,taskName: taskName, action: 'create', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
    saveData();
  }

  void updateTask(taskName, id) {
    userHistoryList.insert(0, History(id: id,taskName: taskName, action: 'update', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
    saveData();
  }

  void finishTask(taskName, id) {
    userHistoryList.insert(0, History(id: id,taskName: taskName, action: 'finish', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
    saveData();
  }

  void deleteTask(taskName, id) {
    userHistoryList.insert(0, History(id: id,taskName: taskName, action: 'delete', when: DateTime.now()));
    emit(HistoryState(historyList: userHistoryList));
    saveData();
  }

}