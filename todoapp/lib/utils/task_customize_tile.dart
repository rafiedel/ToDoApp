// ignore_for_file: sized_box_for_whitespace

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/history_cubit.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCustomizeTile extends StatelessWidget {
  final Task task;
  final double phoneWidth;
  const TaskCustomizeTile(
      {super.key, required this.task, required this.phoneWidth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DetailScren(
                      task: task,
                    )));
      },
      child: Container(
        height: phoneWidth / 4,
        margin: EdgeInsets.symmetric(
            vertical: phoneWidth / 40, horizontal: phoneWidth / 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                phoneWidth / 30,
                phoneWidth / 50,
                phoneWidth / 30,
                phoneWidth / 75,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                task.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    decoration: task.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontSize: phoneWidth / 25),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: phoneWidth / 50,
                                  vertical: phoneWidth / 1000),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              child: Text(
                                task.category,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: phoneWidth / 40,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: phoneWidth / 1.5,
                          child: Text(
                            task.description.isNotEmpty
                                ? task.description
                                : " ~~ N O  D E S C R I P T O N ~~",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: phoneWidth / 35,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.circle,
                        color: task.isTopPriority ? Colors.red : Colors.blue,
                        size: phoneWidth / 40,
                      ),
                      SizedBox(
                        width: phoneWidth / 50,
                      ),
                      Text(
                        task.category != 'Daily'
                                ? '${DateFormat('MMM, EEE dd').format(task.starts)} - ${DateFormat('dd').format(task.ends)}'
                                : '~~ DEFAULT ~~',
                        style: TextStyle(
                            fontSize: phoneWidth / 45,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
