// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names

import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/search_task_cubit.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:table_calendar/table_calendar.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late bool _refresh;
  final TextEditingController _searchController = TextEditingController();
  List<Map>? allChoiceChipCategory;


  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _refresh = true;
    refreshCategory();
    super.initState();
  }

  void refreshCategory() {
    allChoiceChipCategory = taskList
    .map((task) {
      return task.category;
    }).toSet().toList().map((category) {
        return {'name': category, 'beingSearch' : false};
      }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView( // Wrap with SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CalenderSearchTool(),
                SizedBox(height: phoneWidth/20,),
                SearchTools(),
                SizedBox(height: phoneWidth/100), 
                TaskSearched()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CalenderSearchTool() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return TableCalendar(
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(phoneWidth/40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.inversePrimary,
              boxShadow: List.generate(
                5, (index) {
                  return BoxShadow(
                    color: Theme.of(context).colorScheme.primary,
                    blurRadius: 5
                  );
                }
              )
            ),
            child: Center(
              child: Text(
                DateFormat('dd').format(day),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background
                ),
              ),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(phoneWidth/40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.background == Colors.grey.shade900? Colors.yellow: const Color.fromARGB(255, 243, 220, 12),
              boxShadow: List.generate(
                5, (index) {
                  return BoxShadow(
                    color: Theme.of(context).colorScheme.background == Colors.grey.shade900? Colors.yellow: const Color.fromARGB(255, 243, 220, 12),
                    blurRadius: 5
                  );
                }
              )
            ),
            child: Center(
              child: Text(
                DateFormat('dd').format(day),
                style: TextStyle(
                  color: Colors.grey.shade900
                ),
              ),
            ),
          );
        },
        markerBuilder: (BuildContext context, date, events) {
          if (events.isEmpty) return const SizedBox();
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal:  phoneWidth/100),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  events.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: phoneWidth/37.5,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
              SizedBox(width: phoneWidth/80,)
            ],
          );
        },
      ),
      focusedDay: _focusedDay, 
      firstDay: DateTime(2024), 
      lastDay: DateTime(2024).add(const Duration(days: 5 * 365)),
      
      availableCalendarFormats: const {
        CalendarFormat.month : 'Month', 
        CalendarFormat.twoWeeks : 'Refresh', 
        CalendarFormat.week : 'Week'
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onFormatChanged: (value) {
        setState(() {
          _selectedDay = DateTime.now();
          _focusedDay = DateTime.now();
          _refresh = true;
          refreshCategory();
          BlocProvider.of<SearchTaskCubit>(context).clearCategorySelected();
          BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; 
          _searchController.clear();
          _refresh = false;
          refreshCategory();
          BlocProvider.of<SearchTaskCubit>(context).clearCategorySelected();
          BlocProvider.of<SearchTaskCubit>(context).searchTaskByDateSelected(selectedDay);
        });
      },
      eventLoader: (DateTime day) {
        List<dynamic> eventsAtEnds = taskList
        .where((task) =>
            task.ends.year == day.year &&
            task.ends.month == day.month &&
            task.ends.day == day.day &&
            task.category != 'Daily')
        .toList();

        List<dynamic> eventsAtStarts = taskList
        .where((task) =>
            task.starts.year == day.year &&
            task.starts.month == day.month &&
            task.starts.day == day.day &&
            task.category != 'Daily')
        .toList();

        return eventsAtStarts + eventsAtEnds;
      },
    );
  }

  Widget SearchTools() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth/50),
      padding: EdgeInsets.symmetric(horizontal: phoneWidth/35),
      height: phoneWidth/8,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.inversePrimary), // Adjust border color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (searchKey) {
                _searchController.text = searchKey;
                BlocProvider.of<SearchTaskCubit>(context).searchTaskWithKeyword(_searchController.text, _selectedDay);
              },
              style: TextStyle(
                fontSize: phoneWidth/25
              ),
              decoration: InputDecoration(
                border: InputBorder.none, // Hide TextField border
                hintText: 'Search', // Add a placeholder
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), // Hint text color
              ),
            ),
          ),
          Center(
            child: PopOverCategory()
          )
        ],
      ),
    );
  }

  Widget TaskSearched() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchTaskCubit, SearchTaskState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: state.taskBeingSearched.length,
          itemBuilder: (context, index) {
            Task task = state.taskBeingSearched[index];
            if (state.taskBeingSearched[index].category != 'Daily') {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (BuildContext context) => DetailScren(task: state.taskBeingSearched[index]))
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal:  phoneWidth/40),
                  title: Text(
                    task.name, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: phoneWidth/30
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        task.category.isNotEmpty? '# ${task.category}' : '~~~',
                        style: TextStyle(
                          fontSize: phoneWidth/40,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: phoneWidth/30),
                        child: const Text('|')
                      ),
                      Text(
                        '${DateFormat('MMM, EEE dd').format(task.starts)} - ${DateFormat('dd').format(task.ends)}',
                        style: TextStyle(
                          fontSize: phoneWidth/40,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)
                        ),
                      ),
                    ],
                  ),
                  trailing: 
                    _refresh
                      ? Icon(
                          Icons.circle, 
                          color: task.isTopPriority? Colors.red : Colors.blue,
                          size: phoneWidth/30, 
                        )
                      : Text(
                        state.taskBeingSearched[index].starts.day == _selectedDay.day? "STARTS" : "ENDS"
                        ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget PopOverCategory() {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    return Visibility(
      visible: _refresh == true,
      child: GestureDetector(
        onTap: () {
          showPopover(
            contentDyOffset: -phoneHeight/1.8,
            context: context,
            width: phoneWidth,
            bodyBuilder: (context) =>ShowItems(),
            arrowHeight:0,
            arrowWidth:0,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          );
        },
        child: Icon(Icons.manage_search,
            size: phoneWidth / 15,
            color: Theme.of(context)
                .colorScheme
                .inversePrimary), // Adjust icon color
      ),
    );
  }

  Widget ShowItems() {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Selected Category',
              style: TextStyle(
                fontSize: phoneWidth/17,
                fontWeight: FontWeight.w900
              ),
            ),
            SizedBox(height: phoneWidth/50,),
            Wrap(
              children: allChoiceChipCategory!.map((category) {
                if (category['name'] == 'Daily') {
                  return const SizedBox.shrink();
                }
                return BlocBuilder<SearchTaskCubit, SearchTaskState>(
                  builder: (context, state) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: phoneWidth/100),
                      child: ChoiceChip(
                        label: Text(
                          category['name'],
                          style: TextStyle(
                                fontSize: phoneWidth/35,
                                fontWeight: FontWeight.bold,
                                color: category['beingSearch']? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.inversePrimary
                              ),
                        ),
                        showCheckmark: false,
                        selected: category['beingSearch'],
                        backgroundColor: Theme.of(context).colorScheme.background == Colors.grey.shade900
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.75),
                        selectedColor: Theme.of(context).colorScheme.background == Colors.grey.shade900
                                ? Colors.white
                                : Colors.black.withOpacity(0.75),
                        onSelected: (bool selected) {
                          setState(() {
                            int targetedIndex = allChoiceChipCategory!.indexWhere((element) => element.containsValue(category['name']));
                            allChoiceChipCategory![targetedIndex]['beingSearch'] = !allChoiceChipCategory![targetedIndex]['beingSearch'];
                            BlocProvider.of<SearchTaskCubit>(context).searchTaskByCategorySelected(category['name']);
                            BlocProvider.of<SearchTaskCubit>(context).searchTaskWithKeyword(_searchController.text, _selectedDay );
                          });
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

}
