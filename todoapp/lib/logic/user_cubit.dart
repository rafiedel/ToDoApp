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
          homeTopBarBG: state.user.homeTopBarBG,
          lastLogin: state.user.lastLogin,
          lastThemeData: state.user.lastThemeData
        )
      )
    );
    currentUser = state.user;
    saveData();
  }

  void changeProfilePicture(String newImage) {
    emit(
      UserState(
        user: User(
          displayName: state.user.displayName, 
          profilePicture: newImage, 
          homeTopBarBG: state.user.homeTopBarBG, 
          lastLogin:  state.user.lastLogin,
          lastThemeData: state.user.lastThemeData
        )
      )
    );
    currentUser = state.user;
    saveData();
  }

  void changeHomeTopBarBG(String newImage) {
     emit(
      UserState(
        user: User(
          displayName: state.user.displayName, 
          profilePicture: state.user.profilePicture, 
          homeTopBarBG: newImage, 
          lastLogin:  state.user.lastLogin,
          lastThemeData: state.user.lastThemeData
        )
      )
    );
    currentUser = state.user;
    saveData();
  }

  void changeTheme() {
    String changeThemeTo = '';
    if (state.user.lastThemeData == 'lightMode') {
      changeThemeTo = 'darkMode';
    } else if (state.user.lastThemeData == 'darkMode') {
      changeThemeTo = 'lightMode';
    }
    emit(
      UserState(
        user: User(
          displayName: state.user.displayName, 
          profilePicture: state.user.profilePicture, 
          homeTopBarBG: state.user.homeTopBarBG, 
          lastLogin: state.user.lastLogin, 
          lastThemeData: changeThemeTo
        )
      )
    );
    currentUser = state.user;
    saveData();
  }
  

}