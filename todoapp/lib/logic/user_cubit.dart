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
          profilePicture: state.user.profilePicture, 
          homeTopBarBG: state.user.homeTopBarBG
        )
      )
    );
    currentUser = state.user;
    saveData();
  }

  void changeProfilePicture(String newImage) {
    emit(
      UserState(
        user: User(displayName: state.user.displayName, profilePicture: newImage, homeTopBarBG: state.user.homeTopBarBG)
      )
    );
    saveData();
  }

  void changeHomeTopBarBG(String newImage) {
     emit(
      UserState(
        user: User(displayName: state.user.displayName, profilePicture: state.user.profilePicture, homeTopBarBG: newImage)
      )
    );
    saveData();
  }
  

}