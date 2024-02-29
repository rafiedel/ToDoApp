import 'package:todoapp/data/database.dart';
import 'package:todoapp/themes/dark_mode.dart';
import 'package:todoapp/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState{
  ThemeData currentTheme;
  bool isDarkMode;

  ThemeState({
    required this.currentTheme,
    required this.isDarkMode
  });
}


class ThemeCubit extends Cubit<ThemeState>{
  ThemeCubit() :super(ThemeState(currentTheme: darkMode, isDarkMode: true));

  void changeTheme() {
    if (state.currentTheme == lightMode && currentUser.lastThemeData == 'darkMode') {
      emit(ThemeState(currentTheme: darkMode, isDarkMode: true));
    }
    else if (state.currentTheme == darkMode && currentUser.lastThemeData == 'lightMode') {
      emit(ThemeState(currentTheme: lightMode, isDarkMode: false));
    }
    saveData();
  }
}