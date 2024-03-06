// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'package:action_slider/action_slider.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/edit_task_cubit.dart';
import 'package:todoapp/logic/history_cubit.dart';
import 'package:todoapp/logic/reorder_daily_task_cubit.dart';
import 'package:todoapp/logic/search_task_cubit.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/router/main_screen_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:slide_countdown/slide_countdown.dart';
import 'package:todoapp/screens/images_screen.dart';

class DetailScren extends StatefulWidget {
  final Task task;
  const DetailScren({super.key, required this.task});

  @override
  State<DetailScren> createState() => _DetailScrenState();
}

class DateTimeController {
  DateTime? time;

  void dispose() {
    time = null;
  }

  void setTime({required DateTime newDateTime}) {
    time = newDateTime;
  }

  DateTimeController({
    this.time
  });
}


class CategoryController {
  String? text;

  void dispose() {
    text = null;
  }

  CategoryController({
    this.text
  });
}

class _DetailScrenState extends State<DetailScren> {
  late final TextEditingController  _nameController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  late final CategoryController _categoryController = CategoryController();
  late final DateTimeController _startsController = DateTimeController();
  late final DateTimeController _endsController = DateTimeController();
  late int timesLeft;
  late String waitingFor;

  @override
  void initState() {
    _nameController.text = widget.task.name;
    _descriptionController.text = widget.task.description;
    _categoryController.text = widget.task.category;
    _startsController.time = widget.task.starts;
    _endsController.time = widget.task.ends;
    BlocProvider.of<EditTaskCubit>(context).initTask(widget.task);
    super.initState();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _startsController.dispose();
    _endsController.dispose();
    super.dispose();
  }

  void checkIfAnythingChanges(Task originalTask) {
    if (originalTask.name != _nameController.text ||
        originalTask.description != _descriptionController.text ||
        originalTask.category != _categoryController.text ||
        originalTask.starts != _startsController.time ||
        originalTask.ends != _endsController.time){
          BlocProvider.of<EditTaskCubit>(context).upForChange(true, originalTask);
        }
    else {
      BlocProvider.of<EditTaskCubit>(context).upForChange(false, originalTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ColoredAppBar(),
              TaskInformation(phoneWidth)
            ],
          ),
          SizedBox(
            height: phoneWidth / 20,
          ),
          CountDown(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(phoneWidth / 30),
              child: MyTextField(_descriptionController, 'description'),
            ),
          ),
        ],
      ),
      endDrawer: EndDrawer(),
    );
  }

  Widget ColoredAppBar() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<EditTaskCubit, EditTaskState>(
      builder: (context, state) {
        return Container(
          height: phoneWidth / 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: Theme.of(context).colorScheme.background ==
                      Colors.grey.shade900
                  ? state.task.category == 'Daily'
                      ? ([
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                        ])
                      : state.task.isTopPriority
                        ? ([
                            const Color.fromARGB(255, 116, 8, 0),
                            const Color.fromARGB(255, 193, 29, 17),
                            Colors.red,
                          ])
                        : ([
                            const Color.fromARGB(255, 0, 51, 93),
                            const Color.fromARGB(255, 17, 106, 180),
                            const Color.fromARGB(255, 0, 140, 255),
                          ])
                  : state.task.category == 'Daily'
                      ? ([
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                        ])
                      : state.task.isTopPriority
                        ? ([
                            const Color.fromARGB(255, 230, 104, 95),
                            const Color.fromARGB(255, 186, 52, 42),
                            const Color.fromARGB(255, 184, 21, 9),
                          ])
                        : ([
                            const Color.fromARGB(255, 88, 163, 225),
                            const Color.fromARGB(255, 17, 123, 209),
                            const Color.fromARGB(255, 6, 102, 180),
                          ]),
              stops: [
                Theme.of(context).colorScheme.background == Colors.grey.shade900
                    ? 0.0
                    : 0.0,
                Theme.of(context).colorScheme.background == Colors.grey.shade900
                    ? 0.5
                    : 0.9,
                Theme.of(context).colorScheme.background == Colors.grey.shade900
                    ? 1
                    : 1
              ],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: phoneWidth / 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(left: phoneWidth / 12.5),
                      child: Center(
                        child: Text(
                          '«',
                          style: TextStyle(fontSize: phoneWidth / 15),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: phoneWidth / 20),
                        child: Visibility(
                          visible: !state.hasChange,
                          child: GestureDetector(
                            onTap: () =>
                                Scaffold.of(context).openEndDrawer(),
                            child: Icon(
                              Icons.density_medium_outlined,
                              size: phoneWidth / 22.5,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: phoneWidth / 20),
                        child: Visibility(
                          visible: state.hasChange,
                          child: GestureDetector(
                            onTap: () {
                              if (_nameController.text.isNotEmpty) {
                                int targetedIndex = taskList.indexWhere(
                                    (checkTask) =>
                                        checkTask.id == widget.task.id);
                                BlocProvider.of<HistoryCubit>(context)
                                    .updateTask(widget.task.name, widget.task.id);
                                if (_categoryController.text == 'Daily') {
                                  _startsController.time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                                  _endsController.time = _startsController.time!.add(const Duration(days: 1));
                                }
                                taskList[targetedIndex] = Task(
                                    id: widget.task.id,
                                    name: _nameController.text,
                                    description:
                                        _descriptionController.text,
                                    isDone: state.task.isDone,
                                    isTopPriority: state.task.isTopPriority,
                                    starts: _startsController.time!,
                                    ends: _endsController.time!,
                                    category: _categoryController.text!,
                                    imagesRelated: state.task.imagesRelated);
                                BlocProvider.of<EditTaskCubit>(context)
                                    .upForChange(
                                        false, taskList[targetedIndex]);
                                BlocProvider.of<TaskListCubit>(context)
                                    .refreshTaskList();
                                BlocProvider.of<SearchTaskCubit>(
                                        context)
                                    .refreshTaskList();
                                BlocProvider.of<ReOrderDailyTaskCubit>(context).refreshDailyTaskOrder();
                              } else {
                                alertToUser('NAME MUST BE FILL !');
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: phoneWidth/30, vertical: phoneWidth/50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green.withOpacity(0.75),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'SAVE',
                                      style: TextStyle(
                                        fontSize: phoneWidth / 40,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: phoneWidth / 100,
                                      ),
                                    ),
                                    SizedBox(
                                      width: phoneWidth / 100,
                                    ),
                                    Icon(
                                      Icons.save,
                                      size: phoneWidth / 30,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget TaskInformation(double phoneWidth) {
    return Container(
      height: phoneWidth / 2,
      margin: EdgeInsets.fromLTRB(
          phoneWidth / 15, phoneWidth / 3.75, phoneWidth / 15, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context)
              .colorScheme
              .inversePrimary
              .withOpacity(0.8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Column(
              children: [
                MyTextField(_nameController, "name"),
                CategoryStartsEnds(),
                SizedBox(
                  height: phoneWidth / 20,
                )
              ],
            ),
            Positioned(
              right: phoneWidth/50,
              bottom: phoneWidth/50,
              child: BlocBuilder<EditTaskCubit, EditTaskState>(
                builder: (context,state) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (BuildContext context) => ImagesRelatedScreen(currentEditTaskState: state,))
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(phoneWidth/300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).colorScheme.background
                      ),
                      child: Icon(
                        Icons.image, 
                        size: phoneWidth/18, 
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget MyTextField(TextEditingController controller, String whichController) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth / 1000),
      decoration: whichController == 'description'
          ? BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              borderRadius: BorderRadius.circular(10))
          : const BoxDecoration(),
      child: BlocBuilder<EditTaskCubit, EditTaskState>(
        builder: (context, state) {
          return TextField(
            readOnly: widget.task.isDone? true : false,
            controller: controller,
            onChanged: (value) {
              if (whichController == 'name') {
                _nameController.text = value;
              } else if (whichController == 'description') {
                _descriptionController.text = value;
              }
              checkIfAnythingChanges(state.task);
            },
            maxLines: whichController == 'name' ? 1 : null,
            style: TextStyle(
                decoration:
                    widget.task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: Theme.of(context).colorScheme.inversePrimary,
                fontSize:
                    whichController == 'name' ? phoneWidth /20 : phoneWidth / 30,
                fontWeight:
                    whichController == 'name' ? FontWeight.w900 : FontWeight.w300,
                shadows: List.generate(10, (index) {
                  return Shadow(
                      color: Theme.of(context).colorScheme.background,
                      blurRadius: phoneWidth / 60);
                })),
            decoration: InputDecoration(
              hintText: whichController,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(
                  vertical: phoneWidth / 25, horizontal: phoneWidth / 40),
            ),
          );
        }
      ),
    );
  }

  Widget CategoryStartsEnds() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: phoneWidth / 40),
      child: Row(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ['Category', 'Starts', 'Ends'].map((label) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: phoneWidth / 50),
                  child: Text(
                    label,
                    style: TextStyle(
                        decoration: widget.task.isDone? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: phoneWidth/35,
                        fontWeight: FontWeight.bold,
                        shadows: List.generate(10, (index) {
                          return Shadow(
                              color: Theme.of(context).colorScheme.background,
                              blurRadius: phoneWidth / 100);
                        })),
                  ),
                );
              }).toList()),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(3, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: phoneWidth / 50),
                  margin: EdgeInsets.symmetric(
                    horizontal: phoneWidth / 20,
                  ),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: phoneWidth/35,
                        fontWeight: FontWeight.bold,
                        shadows: List.generate(10, (index) {
                          return Shadow(
                              color: Theme.of(context).colorScheme.background,
                              blurRadius: phoneWidth / 100);
                        })),
                  ),
                );
              })),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _categoryController,
                DateFormat('MMMM, EEEE dd yyy').format(_startsController.time!),
                DateFormat('MMMM, EEEE dd yyy').format(_endsController.time!),
              ].map((value) {
                return BlocBuilder<EditTaskCubit, EditTaskState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: phoneWidth / 50),
                      child: GestureDetector(
                        onTap: () {
                          if (value is CategoryController) {
                            chooseCategory(phoneWidth);
                          } else if (value ==
                              DateFormat('MMMM, EEEE dd yyy')
                                  .format(_startsController.time!) && _categoryController.text != 'Daily') {
                            ShowDatePicker(context, _startsController.time!, 'starts',
                                _startsController.time!, state);
                          } else if (value ==
                              DateFormat('MMMM, EEEE dd yyy')
                                  .format(_endsController.time!) && _categoryController.text != 'Daily') {
                            ShowDatePicker(
                                context, _endsController.time!, 'ends', _startsController.time!, state);
                          } else {
                            alertToUser("Daily task's time are set to default");
                          }
                        },
                        child: Text(
                          _categoryController.text == 'Daily'
                            ? (value is CategoryController? _categoryController.text : '~ ~  D E F A U L T  ~ ~').toString()
                            : (value is CategoryController
                                ? _categoryController.text == ''? '~~~' : _categoryController.text
                                : value).toString(),
                          style: TextStyle(
                            decoration: widget.task.isDone? TextDecoration.lineThrough : TextDecoration.none,
                            decorationColor: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: phoneWidth/35,
                              fontWeight: FontWeight.bold,
                              shadows: List.generate(10, (index) {
                                return Shadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    blurRadius: phoneWidth / 100);
                              })),
                        ),
                      ),
                    );
                  },
                );
              }).toList())
        ],
      ),
    );
  }

  Widget CountDown() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<EditTaskCubit, EditTaskState>(
      builder: (context, state) {
        if (state.task.isDone == true){
          timesLeft = 0;
          waitingFor = 'E N D E D';
        } else if(DateTime.now().isBefore(_startsController.time!) && state.task.isDone == false) {
          timesLeft = _startsController.time!.difference(DateTime.now()).inMinutes;
          waitingFor = 'S T A R T S';
        } else if (DateTime.now().isAfter(_startsController.time!) && DateTime.now().isBefore(_endsController.time!) && state.task.isDone == false)  {
          timesLeft = _endsController.time!.difference(DateTime.now()).inMinutes;
          waitingFor = 'E N D S';
        } else if (DateTime.now().isAfter(_endsController.time!)){
          timesLeft = DateTime.now().difference(_endsController.time!).inMinutes;
          waitingFor = 'L A T E';
        }
        return Column(
          children: <Widget>[
            Text(
              waitingFor,
              style: TextStyle(
                   fontSize: phoneWidth/30,
                   letterSpacing: phoneWidth/100,
                   fontWeight: FontWeight.bold),
            ),
            waitingFor != 'ENDED'
                ? SlideCountdownSeparated(
                    separatorStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                    decoration: const BoxDecoration(),
                    duration: Duration(minutes: timesLeft),
                    style: const TextStyle(),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget EndDrawer() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: phoneWidth,
      child: Stack(
        children: [
          Positioned(
            right: -phoneWidth/0.7,
            top: -phoneWidth/0.8,
            child: Transform.rotate(
              angle: -95,
              child: Icon(Icons.square, size: phoneWidth/0.5, color: Theme.of(context).colorScheme.background,)),
          ),
          Positioned(
            right: phoneWidth/15,
            top: phoneWidth/8,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure to delete this task?', style: TextStyle(fontSize: phoneWidth/20),),
                      actions: [
                        MaterialButton(
                          padding: EdgeInsets.all(phoneWidth/100),
                          onPressed: () {
                            BlocProvider.of<HistoryCubit>(context).deleteTask(widget.task.name, widget.task.id);
                            taskList.removeWhere((targetedTask) => targetedTask.id == widget.task.id);
                            BlocProvider.of<TaskListCubit>(context).refreshTaskList();
                            BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
                            BlocProvider.of<ReOrderDailyTaskCubit>(context).refreshDailyTaskOrder();
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(builder: (BuildContext context) => const MainScreenNavigator()), 
                              (Route<dynamic> route) => false
                            );
                          },
                          color: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('YES', style: TextStyle(fontSize: phoneWidth/30),), 
                        )
                      ],
                    );
                  }
                );
              },
              child: Icon(Icons.delete, size: phoneWidth/14,)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<EditTaskCubit, EditTaskState>(
                builder: (context, state) {
                  return Center(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: phoneWidth / 20),
                        child: Visibility(
                          visible: !widget.task.isDone,
                          child: ActionSlider.standard(
                            sliderBehavior: SliderBehavior.stretch,
                            direction: ui.TextDirection.rtl,
                            rolling: true,
                            icon: const Icon(Icons.check),
                            backgroundBorderRadius: BorderRadius.circular(10),
                            foregroundBorderRadius: BorderRadius.circular(10),
                            backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  ' <~~~  Slide to Finish',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.background
                                  ),
                                ),
                              ),
                            ),
                            action: (controller) async {
                              controller.loading(); 
                              int targetedIndex = taskList.indexOf(widget.task);
                              taskList[targetedIndex] = Task(
                                  id: state.task.id,
                                  name: state.task.name,
                                  description: state.task.description,
                                  isDone: true,
                                  isTopPriority: state.task.isTopPriority,
                                  starts: state.task.starts,
                                  ends: state.task.ends,
                                  category: state.task.category,
                                  imagesRelated: state.task.imagesRelated);
                              BlocProvider.of<HistoryCubit>(context)
                                  .finishTask(state.task.name, widget.task.id);
                              BlocProvider.of<TaskListCubit>(context).refreshTaskList();
                              BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
                              BlocProvider.of<ReOrderDailyTaskCubit>(context).refreshDailyTaskOrder();
                              await Future.delayed(const Duration(seconds: 1));
                              controller.success(); 
                              await Future.delayed(const Duration(milliseconds: 1500));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const MainScreenNavigator()),
                                  (Route<dynamic> route) => false);
                            },
                          ),
                        )),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void chooseCategory(double phoneWidth) {
    if (!widget.task.isDone) {
      showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<TaskListCubit, TaskListState>(
              builder: (context, listTaskState) {
            List allCategory =
                listTaskState.taskList.map((task) => task.category)
                    .toList()
                    .toSet()
                    .toList();
            allCategory.remove('Daily'); allCategory.insert(0, 'Daily');
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Text('Edit Category'),
              content: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary),
                    borderRadius: BorderRadius.circular(10)),
                child: BlocBuilder<EditTaskCubit, EditTaskState>(
                  builder: (context, editTaskState) {
                    return CustomDropdown(
                      decoration: CustomDropdownDecoration(
                        closedFillColor: Colors.transparent,
                        expandedFillColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      hintText: 'please select',
                      items: allCategory,
                      onChanged: (value) {
                        setState(() {
                          _categoryController.text = value;
                          checkIfAnythingChanges(editTaskState.task);
                        });
                      },
                    );
                  },
                ),
              ),
            );
          });
        });
    }
  }

  void ShowDatePicker(context, DateTime date, String whichDate,DateTime taskStartsAt, EditTaskState originalTask) {
    if (!widget.task.isDone) {
      showDatePicker(
        context: context,
        initialDate: date,
        firstDate: whichDate == 'ends'
            ? taskStartsAt.add(const Duration(days: 1))
            : DateTime.now(),
        lastDate: DateTime(2030),
      ).then((result) {
        setState(() {
          if (whichDate == 'ends') {
            _endsController.time = result!;
          } else if (whichDate == 'starts') {
            _startsController.time = result!;
            _endsController.time = result.add(const Duration(days: 1));
          }
        });
        checkIfAnythingChanges(originalTask.task);
      });
    }
  }

  void alertToUser(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(
            const Duration(milliseconds: 1000),
            () {
          Navigator.of(context).pop(
              true); 
        });
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10),
          ),
          icon: Icon(
            Icons.warning,
            color: Colors.yellow,
            size: MediaQuery.of(context)
                    .size
                    .width /
                7.5,
          ),
          title: Text(
            message,
            maxLines: null,
            style: TextStyle(
                fontSize:
                    MediaQuery.of(context)
                            .size
                            .width /
                        25),
          ),
        );
      },
    );
  }

}
