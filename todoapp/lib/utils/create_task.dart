// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/create_task_cubit.dart';
import 'package:todoapp/logic/history_cubit.dart';
import 'package:todoapp/logic/search_task_cubit.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateTaskButton extends StatefulWidget {
  const CreateTaskButton({super.key});

  @override
  State<CreateTaskButton> createState() => _CreateTaskButton();
}

class _CreateTaskButton extends State<CreateTaskButton> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showBottomSheet();
      },
      child: Icon(Icons.add_box,
          size: phoneWidth / 17.5,
          shadows: List.generate(10, (index) {
            return Shadow(
                color: Theme.of(context).colorScheme.background, blurRadius: 5);
          })),
    );
  }

  Future<void> showBottomSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.9,
            maxChildSize: 1,
            expand: true,
            builder: (context, scrollController) {
              return FractionallySizedBox(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: bottomSheetContent(scrollController),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget bottomSheetContent(ScrollController scrollController) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        double phoneWidth = MediaQuery.of(context).size.width;
        double phoneHeight = MediaQuery.of(context).size.height;
        return SingleChildScrollView(
          controller: scrollController,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: phoneHeight / 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Create New Task",
                        style: TextStyle(
                            fontSize: phoneWidth / 17.5,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: phoneWidth / 10,
                      )
                    ],
                  ),
                ),
                Container(
                  height: phoneHeight/1.225,
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: phoneWidth / 20,
                          ),
                          DateSection(),
                          SizedBox(
                            height: phoneWidth / 100,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SectionLabel('Category'),
                              Row(
                                children: [
                                  CreateNewCategoryButton(),
                                  ToggleCategorySwitch(),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: phoneWidth / 100,
                          ),
                          CategorySection(),
                          SectionLabel('Name'),
                          MyTextField(_nameController, 1, 'name'),
                          SizedBox(
                            height: phoneWidth / 30,
                          ),
                          SectionLabel('Description'),
                          MyTextField(_descriptionController, 5, 'description'),
                          SizedBox(
                            height: phoneWidth / 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SectionLabel('Top Priority?'),
                              Switch(
                                inactiveTrackColor: Colors.blue,
                                activeColor: Colors.red,
                                value: state.newTask.isTopPriority, 
                                onChanged: (value) {
                                  BlocProvider.of<CreateTaskCubit>(context).setTopPriority(!state.newTask.isTopPriority);
                                }
                              ),
                              SizedBox(width: phoneWidth/30,)
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          FormButton(),
                          SizedBox(height: phoneWidth/15)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget SectionLabel(String sectionName) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: phoneWidth / 30, vertical: phoneWidth / 50),
      child: Text(
        sectionName,
        style:
            TextStyle(fontSize: phoneWidth / 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget MyTextField(TextEditingController controller, int maxLines, String whichController) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Container(
          margin: whichController == 'category'? null : EdgeInsets.symmetric(horizontal: phoneWidth/30),
          child: TextField(
            style: TextStyle(
              fontSize: phoneWidth/32.5
            ),
            controller: controller,
            onChanged: (value) {
              if (whichController == 'name') {
                BlocProvider.of<CreateTaskCubit>(context).setname(value);
              } else if (whichController == 'description') {
                BlocProvider.of<CreateTaskCubit>(context).setDescription(value);
              }
              else if (whichController == 'category') {
                _newCategoryController.text = value;
              }
            },
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: whichController,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: phoneWidth/25, horizontal: phoneWidth/20),
            ),
          ),
        );
      },
    );
  }

  Widget DateSection() {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel('Starts'),
                  PickDate(state.newTask.starts, 'starts')
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel('Ends'),
                  PickDate(state.newTask.ends, 'ends')
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget PickDate(DateTime date, String whichDate) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: phoneWidth/30),
          child: MaterialButton(
            padding: EdgeInsets.symmetric(horizontal: phoneWidth/40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
            ),
            onPressed: () {
              if (state.newTask.category == 'Daily') {
                alertToUser(context, "Daily task's time are set to default");
                Timer(const Duration(milliseconds: 1000), () {
                  Navigator.pop(context);
                });
              } else {
                ShowDatePicker(context, date, whichDate, state.newTask.starts);
              }
            },
            child: Row(
              children: [
                Icon(Icons.calendar_month, size: phoneWidth/20,),
                SizedBox(width: phoneWidth/40,),
                Text(
                  state.newTask.category == 'Daily'? '~~~' : DateFormat('EEE MMM dd, yyy').format(date),
                  style: TextStyle(
                    fontSize: phoneWidth/35
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void ShowDatePicker(context, DateTime date, String whichDate, DateTime taskStartsAt) {
    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: whichDate == 'ends' ? taskStartsAt.add(const Duration(days: 1)) : DateTime.now(),
      lastDate: DateTime(2030),
    ).then((result) {
      if (whichDate == 'ends') {
        BlocProvider.of<CreateTaskCubit>(context).setEnds(result!);
      } else if (whichDate == 'starts') {
        BlocProvider.of<CreateTaskCubit>(context).setStarts(result!);
      }
    });
  }

  Widget CategorySection() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, newTaskState) {
        return BlocBuilder<TaskListCubit, TaskListState>(
          builder: (context, taskListState) {
            List allCategory =
                taskListState.taskList.map((task) => task.category)
                    .toList()
                    .toSet()
                    .toList();
            allCategory.sort(); allCategory.remove('Daily'); allCategory.remove('');
            if (newTaskState.newTask.category != 'Daily') {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: phoneWidth/30, vertical: phoneWidth/100),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: CustomDropdown(
                  decoration: CustomDropdownDecoration(
                    headerStyle: TextStyle(
                      fontSize: phoneWidth/32.5
                    ),
                    hintStyle: TextStyle(
                      fontSize: phoneWidth/32.5
                    ),
                    listItemStyle: TextStyle(
                      fontSize: phoneWidth/32.5
                    ),
                    closedFillColor: Colors.transparent,
                    expandedFillColor: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: 'please select',
                  items: allCategory,
                  onChanged: (value) {
                    BlocProvider.of<CreateTaskCubit>(context).setCategory(value);
                  },
                ),
              );
            }
            else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget CreateNewCategoryButton() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Visibility(
          visible: state.newTask.category != 'Daily',
          child: IconButton(
            onPressed: () => {
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    title: const Text('New Category'),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<TaskListCubit>(context).addTemporaryTaskForNewCategory(_newCategoryController.text);
                          _newCategoryController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      )
                    ],
                    content: SizedBox(
                      width: phoneWidth,
                      child: MyTextField(_newCategoryController, 1, 'category'),
                    ),
                  );
                }
              )
            }, 
            icon: Icon(Icons.add, size: phoneWidth/20,)
          ),
        );
      },
    );
  }

  List categoryValues = ['Other', 'Daily'];
  String currentValue = 'Other';
  Widget ToggleCategorySwitch() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(right: phoneWidth/40),
          child: AnimatedToggleSwitch.size(
            current: state.newTask.category == 'Daily'? 'Daily' : 'Other',
            values: categoryValues,
            indicatorSize: Size.fromWidth(phoneWidth / 6.5),
            height: phoneWidth / 15,
            iconAnimationType: AnimationType.onHover,
            style: ToggleStyle(
              borderColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            customIconBuilder: (context, local, global) {
              final text = const ['Other', 'Daily'][local.index];
              return Center(
                child: Text(text,
                  style: TextStyle(
                    fontSize: phoneWidth / 50,
                  )
                )
              );
            },
            onChanged: (value) {
              setState(() {
                if (state.newTask.category == 'Daily') {
                  BlocProvider.of<CreateTaskCubit>(context).setCategory('');
                } else {
                  BlocProvider.of<CreateTaskCubit>(context).setCategory('Daily');
                  BlocProvider.of<CreateTaskCubit>(context).setStarts(DateTime.now());
                  BlocProvider.of<CreateTaskCubit>(context).setEnds(DateTime.now().add(const Duration(days: 1)));
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget FormButton() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      builder: (context, newTaskState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                if (newTaskState.newTask.name.isNotEmpty) {
                  if (newTaskState.newTask.category.contains('Daily')) {
                    BlocProvider.of<CreateTaskCubit>(context).setStarts(DateTime.now());
                    BlocProvider.of<CreateTaskCubit>(context).setEnds(DateTime.now().add(const Duration(days: 1)));
                    taskList.add(newTaskState.newTask);
                  }
                  else {
                    taskList.add(newTaskState.newTask);
                  }
                  BlocProvider.of<TaskListCubit>(context).refreshTaskList();
                  BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
                  BlocProvider.of<CreateTaskCubit>(context).refreshState();
                  BlocProvider.of<HistoryCubit>(context).createTask(_nameController.text);
                  _nameController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                } else {
                  alertToUser(context, 'Please fill the name !');
                } Timer(const Duration(milliseconds: 1000), () {Navigator.pop(context);});
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: phoneWidth/30
                ),
              ),
            ),
            SizedBox(
              width: phoneWidth / 20,
            ),
            MaterialButton(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                BlocProvider.of<TaskListCubit>(context).refreshTaskList();
                BlocProvider.of<CreateTaskCubit>(context).refreshState();
                _nameController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: phoneWidth/30
                ),
              ),
            ),
            SizedBox(
              width: phoneWidth / 40,
            ),
          ],
        );
      },
    );
  }

  Future<void> alertToUser(BuildContext context, String infoToUser) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: Icon(
            Icons.warning,
            color: Colors.yellow,
            size: MediaQuery.of(context).size.width / 7.5,
          ),
          title: Text(
            infoToUser,
            maxLines: null,
            style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
          ),
        );
      },
    );
  }

}
