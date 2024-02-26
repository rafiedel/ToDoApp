import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/data/database.dart';


class UserState{
  User user;

  UserState({
    required this.user
  });
}

class UserCubit extends Cubit<UserState>{
  UserCubit() : super(UserState(user: currentUser));
  

  void changeName(String newName) {
    emit(
      UserState(
        user: User(
          displayName: newName, 
          linkAppBarBG: state.user.linkAppBarBG, 
          linkPfp: state.user.linkPfp
        )
      )
    );
    currentUser = state.user;
    saveData();
  }

  void changePfp(String newLink) {
    emit(
      UserState(
        user: User(
          displayName: state.user.displayName, 
          linkAppBarBG: state.user.linkAppBarBG, 
          linkPfp: newLink
        )
      )
    );
    currentUser = state.user;
    saveData();
  }

  void changeAppBarBG(String newLink) {
    emit(
      UserState(
        user: User(
          displayName: state.user.displayName, 
          linkAppBarBG: newLink, 
          linkPfp: state.user.linkPfp
        )
      )
    );
    currentUser = state.user;
    saveData();
  }
}