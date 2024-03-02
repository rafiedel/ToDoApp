// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, use_super_parameters

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/logic/edit_task_cubit.dart';
import 'package:todoapp/logic/history_cubit.dart';
import 'package:todoapp/logic/search_task_cubit.dart';
import 'package:todoapp/logic/task_list_cubit.dart';
import 'package:todoapp/utils/view_images.dart';

class ImagesRelatedScreen extends StatelessWidget {
  final Task whichTask;
  const ImagesRelatedScreen({Key? key, required this.whichTask}) : super(key: key);

  Future<void> pickImage(Task task, BuildContext context, ImageSource pickedImageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: pickedImageSource);
    if (pickedFile != null) {
      File imgFile = File(pickedFile.path);
      File? imgCropped = await cropImage(imageFile: imgFile);
      if (imgCropped != null) {
        Uint8List imgBytes = await imgCropped.readAsBytes();
        String imgStrings = String.fromCharCodes(imgBytes);

        task.imagesRelated.add(imgStrings);

        BlocProvider.of<TaskListCubit>(context).refreshTaskList(); 
        BlocProvider.of<HistoryCubit>(context).updateTask(task.name, task.id);
        BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
        BlocProvider.of<EditTaskCubit>(context).initTask(task);
      } else {
        
      }
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)
            )
          ),
          backgroundColor: whichTask.isTopPriority
              ? (Theme.of(context).colorScheme.background == Colors.grey.shade900
                  ? const Color.fromARGB(255, 148, 44, 37)
                  : const Color.fromARGB(255, 253, 72, 59))
              : (Theme.of(context).colorScheme.background == Colors.grey.shade900
                  ? const Color.fromARGB(255, 21, 91, 149)
                  : const Color.fromARGB(255, 91, 150, 199)),
          leading: GestureDetector(
            onTap: () { 
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: phoneWidth / 100),
              child: Center(
                child: Text(
                  '«',
                  style: TextStyle(fontSize: phoneWidth / 15),
                ),
              ),
            ),
          ),
          title: Text(whichTask.name, style: TextStyle(fontSize: phoneWidth/20),),
          centerTitle: true,
        ),
        body: BlocBuilder<TaskListCubit, TaskListState>(
          builder: (context, state) {
            Task task =
                state.taskList.singleWhere((task) => task.id == whichTask.id);
            List<String> imagesRelated = task.imagesRelated;
            return Column(
              children: [
                SizedBox(height: phoneWidth/20,),
                Wrap(
                  children: List.generate(
                    imagesRelated.length + 1,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          if (!task.isDone) {
                            if (index == imagesRelated.length) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  behavior: SnackBarBehavior.fixed,
                                  content: Column(
                                    children: [
                                      MaterialButton(
                                        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        onPressed: () {
                                          pickImage(task, context, ImageSource.camera);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.camera, size: phoneWidth/17.5),
                                            SizedBox(width: phoneWidth/20),
                                            Text('C A M E R A', style: TextStyle(fontSize: phoneWidth/25),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: phoneWidth/50,),
                                      MaterialButton(
                                        color: Theme.of(context).colorScheme.tertiary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        onPressed: () {
                                          pickImage(task, context, ImageSource.gallery);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.image, size: phoneWidth/17.5),
                                            SizedBox(width: phoneWidth/20),
                                            Text('G A L L E R Y', style: TextStyle(fontSize: phoneWidth/25),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: phoneWidth/100,)
                                    ],
                                  ),
                                )
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => ViewImages(initialIndex: index, imagesString: imagesRelated,))
                              );
                            }
                          }
                        },
                        child: Stack(
                          children: [
                            Hero(
                              tag: '$index',
                              child: Container(
                                height: phoneWidth / 3.3,
                                width: phoneWidth / 3.3,
                                margin: EdgeInsets.all(phoneWidth / 70),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: index < imagesRelated.length
                                        ? DecorationImage(
                                          fit: BoxFit.cover,
                                            image: MemoryImage(
                                              Uint8List.fromList(
                                                imagesRelated[index].codeUnits,
                                              ),
                                            ),
                                          )
                                        : null,
                                    color: Theme.of(context).colorScheme.secondary),
                                child: index == imagesRelated.length
                                    ? task.isDone
                                      ? const Expanded(child: Center(child: Text('FINISHED TASK', maxLines: null,)))
                                      : Icon(
                                          Icons.add,
                                          size: phoneWidth / 10,
                                          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
                                        )
                                    : null,
                              ),
                            ),
                            index != imagesRelated.length
                            ? Positioned(
                              right: 0,
                              top: 0,
                              child: Transform.translate(
                                offset: Offset(phoneWidth/60, 0),
                                child: PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      int targetedIndex = taskList.indexWhere((targetedTask) => targetedTask.id == task.id);
                                      Task newTask = taskList[targetedIndex];
                                      newTask.imagesRelated.removeAt(index);
                                      taskList[targetedIndex] = newTask;
                                      BlocProvider.of<TaskListCubit>(context).refreshTaskList();
                                      BlocProvider.of<SearchTaskCubit>(context).refreshTaskList();
                                      BlocProvider.of<HistoryCubit>(context).updateTask(newTask.name, newTask.id);
                                      BlocProvider.of<EditTaskCubit>(context).initTask(newTask);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.delete),
                                          Text('delete image')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ) : const SizedBox.shrink()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
