// ignore_for_file: prefer_const_constructors_in_immutables, use_build_context_synchronously, non_constant_identifier_names, prefer_const_constructors

import 'dart:typed_data';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/logic/user_cubit.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:todoapp/screens/view_all_ongoing_screen.dart';
import 'package:todoapp/utils/create_task.dart';
import 'package:todoapp/utils/task_customize_tile.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [HomeScreenCustomTopBar(context), HomeScreenContents(context)],
    ));
  }

  Widget HomeScreenCustomTopBar(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return SliverAppBar(
      floating: false,
      pinned: false,
      expandedHeight: phoneWidth / 2.25,
      actions: [
        Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(phoneWidth / 30),
                child: const CreateTaskButton())
          ],
        ),
      ],
      flexibleSpace: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return FlexibleSpaceBar(
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: phoneWidth / 50),
              decoration: BoxDecoration(
                  image: state.user.homeTopBarBG != ''
                    ? DecorationImage(
                        image: MemoryImage(Uint8List.fromList(state.user.homeTopBarBG.codeUnits)),
                      fit: BoxFit.fitWidth) 
                    : DecorationImage(
                      image: AssetImage('assets/images/space.jpg'),
                      fit: BoxFit.fitWidth
                    )
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: phoneWidth / 7.5,
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return Text(
                        'Hello, ${state.user.displayName}',
                        style: TextStyle(
                            fontSize: phoneWidth / 15,
                            letterSpacing: phoneWidth / 50,
                            fontWeight: FontWeight.w900,
                            shadows: List.generate(10, (index) {
                              return Shadow(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  blurRadius: 5);
                            })),
                      );
                    },
                  ),
                  Text(
                    "Let's be productive!",
                    style: TextStyle(
                        fontSize: phoneWidth / 30,
                        letterSpacing: phoneWidth / 75,
                        fontWeight: FontWeight.w900,
                        shadows: List.generate(5, (index) {
                          return Shadow(
                              color: Theme.of(context).colorScheme.background,
                              blurRadius: 5);
                        })),
                  ),
                  SizedBox(
                    height: phoneWidth / 20,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget HomeScreenContents(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return SliverList.list(
      children: [
        SizedBox(
          height: phoneWidth / 20,
        ),
        OngoingTaskSection(context),
        SizedBox(
          height: phoneWidth / 15,
        ),
        UpcomingTask()
      ],
    );
  }

  Widget OngoingTaskSection(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        List<Task> ongoingTask = state.taskList.where((task) {
          return DateTime.now().isAfter(task.starts) && DateTime.now().isBefore(task.ends) && task.isDone == false;
        }).toList();
        ongoingTask.sort((a,b) => a.ends.compareTo(b.ends));
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: phoneWidth / 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ongoing",
                    style: TextStyle(
                        fontSize: phoneWidth / 22.5, fontWeight: FontWeight.w400),
                  ),
                  Visibility(
                    visible: ongoingTask.length > 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const ViewAllOngoingScreen(
                                        taskSectionName: "ONGOING TASKS")));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: phoneWidth / 50,
                            vertical: phoneWidth / 200),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: phoneWidth/40
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: phoneWidth / 50,
            ),
            ongoingTask.isNotEmpty
                ? Column(
                    children: ongoingTask.take(3).map((task) {
                    return TaskCustomizeTile(
                        task: task, phoneWidth: phoneWidth);
                  }).toList())
                : Center(
                    child: Text(
                      "~~ you've done great today ~~",
                      style: TextStyle(
                        fontSize: phoneWidth/35
                      ),
                    ),
                  )
          ],
        );
      },
    );
  }
}


class UpcomingTask extends StatefulWidget {
  UpcomingTask({super.key});

  @override
  State<UpcomingTask> createState() => _UpcomingTaskState();
}

class _UpcomingTaskState extends State<UpcomingTask> {
  final SwiperController _swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        List<Task> upcomingTask = state.taskList.where((task) {
          return task.starts.isAfter(DateTime.now()) && task.isDone == false;
        }).toList();
        List<DateTime> allStarts = upcomingTask
            .map((task) =>
                DateTime(task.starts.year, task.starts.month, task.starts.day))
            .toSet()
            .toList();
        allStarts.sort((a, b) => a.compareTo(b));
        double maxItems = 0.0;
        List<Map> tasksGroupedWithStart = allStarts.map((starts) {
          List tasksSorted = upcomingTask.where((task) {
            return task.starts.year == starts.year &&
                task.starts.month == starts.month &&
                task.starts.day == starts.day;
          }).toList();
          if (maxItems < tasksSorted.length) {
            maxItems = tasksSorted.length.toDouble();
          }
          return {
            'startsAt': DateTime(starts.year, starts.month, starts.day)   
                          == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1))
                ? 'Tomorrow'
                : DateFormat('MMMM, EEEE dd').format(starts),
            'tasks': tasksSorted
          };
        }).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: phoneWidth / 30),
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                        fontSize: phoneWidth / 22.5, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: phoneWidth / 30),
                  child: Text(
                    tasksGroupedWithStart.isEmpty? '0/0' : '${_swiperController.index+1}/${tasksGroupedWithStart.length}',
                    style: TextStyle(
                      fontSize: phoneWidth/40
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: phoneWidth / 30,
            ),
            upcomingTask.isNotEmpty
            ?SizedBox(
              height: phoneWidth/9 + phoneWidth/8.25 * maxItems,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), 
                child: Swiper(
                  controller: _swiperController,
                  onIndexChanged: (value) {
                    setState(() {
                      _swiperController.index = value;
                    });
                  },
                  duration: 1200,
                  loop: false,
                  customLayoutOption: CustomLayoutOption(
                    startIndex: 0,
                  ),
                  viewportFraction: 0.9,
                  scale: 1,
                  itemCount: tasksGroupedWithStart.length,
                  itemBuilder: (context, index) {
                    Map taskGroup = tasksGroupedWithStart[index];
                    String startsAt = taskGroup['startsAt'];
                    List<Task> tasks = taskGroup['tasks'];
                    return Transform.translate(
                      offset: Offset(-phoneWidth / 30, 0),
                      child: Container(
                          margin: EdgeInsets.only(
                              left: phoneWidth / 50, top: phoneWidth / 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: phoneWidth / 40,
                                        vertical: phoneWidth / 75),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary)),
                                    child: Text(
                                      startsAt,
                                      style: TextStyle(
                                        fontSize: phoneWidth / 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: phoneWidth / 100,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: phoneWidth / 50),
                                    child: Text(
                                      'STARTS',
                                      style: TextStyle(
                                          fontSize: phoneWidth / 60,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: tasks.map((task) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      DetailScren(task: task)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: phoneWidth / 20),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: phoneWidth / 100,
                                              ),
                                              Icon(
                                                Icons.circle,
                                                size: phoneWidth / 40,
                                                color: task.isTopPriority
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                              SizedBox(
                                                width: phoneWidth / 25,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  task.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          phoneWidth / 27.5),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          )),
                    );
                  },
                ),
              ),
            ) : Center(
                    child: Text(
                      "~~ enjoy your peaceful life ~~",
                      style: TextStyle(
                        fontSize: phoneWidth/35
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
