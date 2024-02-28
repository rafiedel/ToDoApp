// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/history_cubit.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/logic/theme_cubit.dart';
import 'package:todoapp/logic/user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/screens/view_task_summary.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  Future<void> pickImageFromGallery(whichImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? imgFile = File(pickedFile.path);
      File? imgCropped = await cropImage(imageFile: imgFile);
      Uint8List imgBytes = imgCropped!.readAsBytesSync();
      String imgStrings  = String.fromCharCodes(imgBytes);
      setState(() {
        if (whichImage == 'pp') {
          BlocProvider.of<UserCubit>(context).changeProfilePicture(imgStrings);
        }
        else {
          BlocProvider.of<UserCubit>(context).changeHomeTopBarBG(imgStrings);
        }
      });
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage  =
      await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return File('');
    return File(croppedImage.path);
  }


  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        ProfileContent(context, phoneWidth),
        AboutMeButton(context, phoneWidth)
      ],
    );
  }

  Widget ProfileContent(BuildContext context, double phoneWidth) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state.user.profilePicture != '') {
                   return CircleAvatar(
                    radius: phoneWidth / 5,
                    backgroundImage: MemoryImage(Uint8List.fromList(state.user.profilePicture.codeUnits)),
                  );
                }
                return CircleAvatar(
                  radius: phoneWidth/5,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
            SizedBox(
              height: phoneWidth / 20,
            ),
            Settings(context, phoneWidth),
            YourSummary(context, phoneWidth),
            History(context, phoneWidth)
          ],
        ),
      ),
    );
  }

  Widget Settings(BuildContext context, double phoneWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth / 20),
      child: ExpansionTile(
        trailing: const Icon(Icons.settings),
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'SETTINGS',
          style: TextStyle(
              letterSpacing: phoneWidth / 100, fontWeight: FontWeight.w900),
        ),
        children: [
          DarkMode(),
          DisplayName(context, phoneWidth),
          DisplayAppBarBG(context, phoneWidth),
          DisplayPfp(context, phoneWidth)
        ],
      ),
    );
  }

  Widget YourSummary(BuildContext context, double phoneWidth) {
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        Map<String, List<Task>> summary = {
          'FINISHED': [],
          'NOT YET': [],
          "LATE": []
        };
        for (Task task in state.taskList) {
          if (task.category != 'Daily') {
            if (task.isDone == true) {
              summary['FINISHED']!.add(task);
            } else if (task.isDone == false &&
                task.ends.isAfter(DateTime.now())) {
              summary['NOT YET']!.add(task);
            } else if (task.isDone == false &&
                task.ends.isBefore(DateTime.now())) {
              summary["LATE"]!.add(task);
            }
          }
        }
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: phoneWidth / 20),
              child: ExpansionTile(
                trailing: const Icon(Icons.stacked_bar_chart),
                backgroundColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'YOUR SUMMARY',
                  style: TextStyle(
                      letterSpacing: phoneWidth / 100, fontWeight: FontWeight.w900),
                ),
                children: [
                  SizedBox(
                    height: phoneWidth / 5,
                    child: Row(
                      children: ['FINISHED', 'NOT YET', "LATE"].map((key) {
                        return Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              List<Task> tasksToShow = summary[key]!;
                              if (tasksToShow.isNotEmpty && key != 'NOT YET') {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (BuildContext context) => ViewSummaryTask(tasks: tasksToShow, tasksTitle: key,))
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: phoneWidth / 40),
                              decoration: BoxDecoration(
                                border: Border(
                                    right: key.contains('LATE')
                                        ? const BorderSide(color: Colors.transparent)
                                        : BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'FINISHEDLATE'.contains(key)?'ᯓ$keyᯓ' : key,
                                    style: TextStyle(
                                      fontSize: phoneWidth/35
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      summary[key]!.length.toString(),
                                      style: TextStyle(
                                        fontSize: phoneWidth / 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget History(BuildContext context, double phoneWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: phoneWidth / 20),
      child: ExpansionTile(
        trailing: const Icon(Icons.history_outlined),
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'HISTORY',
          style: TextStyle(
              letterSpacing: phoneWidth / 40, fontWeight: FontWeight.w900),
        ),
        children: [
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              return DataTable(
                columnSpacing: 20.0, 
                columns: const [
                  DataColumn(
                    label: Text('Task Name'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
                  DataColumn(
                    label: Text('Date'),
                  ),
                ],
                rows: state.historyList.map((history) {
                  return DataRow(cells: [
                    DataCell(
                      Text(history.taskName),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: phoneWidth/40),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
                            left: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
                          )
                        ),
                        child: Text(history.action)
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: phoneWidth/8,
                        child: Text(DateFormat('dd MMM').format(history.when)
                      )),
                    ),
                  ]);
                }).toList(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), 
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget DarkMode() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.dark_mode),
          trailing: CupertinoSwitch(
              value: state.isDarkMode,
              onChanged: (value) =>
                  BlocProvider.of<ThemeCubit>(context).changeTheme()),
          title: const Text('Dark Mode'),
        );
      },
    );
  }

  Widget DisplayName(BuildContext context, double phoneWidth) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.border_color_outlined),
          title: const Text('Display Name'),
          trailing: GestureDetector(
            onTap: () => changeUserName(context, phoneWidth, 'Display Name'),
            child: Text(state.user.displayName.isNotEmpty ? 'set' : 'not set'),
          ),
        );
      },
    );
  }

  Widget DisplayAppBarBG(BuildContext context, double phoneWidth) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.add_photo_alternate_outlined),
          title: const Text('Display Home App Bar BackGround'),
          trailing: GestureDetector(
              onTap: () => pickImageFromGallery('bg'),
              child: Text(state.user.homeTopBarBG != ''
                  ? 'set'
                  : 'not set')),
        );
      },
    );
  }

  Widget DisplayPfp(BuildContext context, double phoneWidth) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.emoji_emotions),
          title: const Text('Display Profile Picture'),
          trailing: GestureDetector(
              onTap: () => pickImageFromGallery('pp'),
              child: Text(state.user.homeTopBarBG != ''
                  ? 'set'
                  : 'not set')),
        );
      },
    );
  }

  Widget AboutMeButton(BuildContext context, double phoneWidth) {
    return Positioned(
        right: phoneWidth / 20,
        top: phoneWidth / 10,
        child: GestureDetector(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(phoneWidth / 100),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(
                  'About Me',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: phoneWidth / 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: phoneWidth / 100,
                ),
                Icon(
                  Icons.emoji_people,
                  size: phoneWidth / 25,
                  color: Theme.of(context).colorScheme.background,
                )
              ],
            ),
          ),
        ));
  }

  void changeUserName(
      BuildContext context, double phoneWidth, String whichController) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SizedBox(
              width: phoneWidth,
              child: MyTextField(context),
            ),
          );
        });
  }

  Widget MyTextField(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    double phoneWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        userNameController.text = state.user.displayName;
        return TextField(
          maxLength: 15 ,
          controller: userNameController,
          onChanged: (value) {
            setState(() {
                userNameController.text = value;
                BlocProvider.of<UserCubit>(context).changeName(value);
            });
          },
          decoration: InputDecoration(
            label: const Text('Enter Text'),
            // hintText: whichController,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: phoneWidth / 25, horizontal: phoneWidth / 20),
          ),
        );
      },
    );
  }
}
