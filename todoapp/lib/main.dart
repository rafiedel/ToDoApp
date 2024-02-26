import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/create_task_cubit.dart';
import 'package:todoapp/logic/edit_task_cubit.dart';
import 'package:todoapp/logic/history_cubit.dart';
import 'package:todoapp/logic/search_task_cubit.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/logic/theme_cubit.dart';
import 'package:todoapp/logic/user_cubit.dart';
import 'package:todoapp/router/main_screen_navigator.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final cron = Cron();
  cron.schedule(Schedule.parse('0 3 * * *'), () async {
    await refreshDailyTask();
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp  
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(UserAdapter());
  // ignore: unused_local_variable
  var myBox = await Hive.openBox('mybox');

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskListCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => CreateTaskCubit(),
        ),
        BlocProvider(
          create: (context) => SearchTaskCubit(),
        ),
        BlocProvider(
          create: (context) => EditTaskCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(),
        )
      ], 
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context,state) {
          return MaterialApp(
            theme: state.currentTheme,
            home: const MainScreenNavigator()
          );
        },
      )
    );
  }
}