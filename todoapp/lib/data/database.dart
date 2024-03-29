import 'package:hive/hive.dart';
part 'database.g.dart';

@HiveType(typeId: 0)
class Task{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  bool isDone;
  @HiveField(4)
  bool isTopPriority;
  @HiveField(5)
  DateTime starts;
  @HiveField(6)
  DateTime ends;
  @HiveField(7)
  String category;
  @HiveField(8)
  List<String> imagesRelated;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.isDone,
    required this.isTopPriority,
    required this.starts,
    required this.ends,
    required this.category,
    required this.imagesRelated
  });
}

@HiveType(typeId: 1)
class History {
  @HiveField(0)
  String taskName;
  @HiveField(1)
  String action;
  @HiveField(2)
  DateTime when;
  @HiveField(3)
  int id;

  History({
    required this.taskName,
    required this.action,
    required this.when,
    required this.id
  });
}

@HiveType(typeId: 2)
class User{
  @HiveField(0)
  String displayName;
  @HiveField(1)
  String profilePicture;
  @HiveField(2)
  String homeTopBarBG;
  @HiveField(3)
  DateTime lastLogin;
  @HiveField(4)
  String lastThemeData;

  User({
    required this.displayName,
    required this.profilePicture,
    required this.homeTopBarBG,
    required this.lastLogin,
    required this.lastThemeData
  });
}


List<Task> sampleTaskList= [];
List<Task> taskList = [];
List<History> userHistoryList = [];
User currentUser = User(displayName: 'User', profilePicture: '' ,homeTopBarBG: '', lastLogin: DateTime.now(), lastThemeData: 'darkMode');

final myBox = Hive.box('mybox');

void initialData() {
  sampleTaskList = [
    Task(
      id: 1,
      name: 'Ristek Mobdev Oprec Assignment',
      description: 'Finish the application for the Ristek MobDev recruitment process.',
      isDone: true,
      isTopPriority: true,
      starts: DateTime(2024, 2, 19),
      ends: DateTime(2024, 3, 2),
      category: 'OPREC',
      imagesRelated: []
    ),
    Task(
      id: 2,
      name: 'Complete Project Proposal',
      description: 'Prepare and finalize the proposal document for the upcoming project.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      category: 'Project',
      imagesRelated: []
    ),
    Task(
      id: 3,
      name: 'Prepare for Interview',
      description: 'Research and practice common interview questions for the upcoming job interview.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      category: 'Career',
      imagesRelated: []
    ),
    Task(
      id: 4,
      name: 'Study for Exam',
      description: 'Review lecture notes and textbooks to prepare for the upcoming exam.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 4)),
      category: 'Education',
      imagesRelated: []
    ),
    Task(
      id: 5,
      name: 'Gym Workout',
      description: 'Attend a workout session at the gym to maintain physical fitness.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 5)),
      category: 'Health',
      imagesRelated: []
    ),
    Task(
      id: 6,
      name: 'Shopping for Groceries',
      description: 'Purchase essential groceries and household items from the supermarket.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 6)),
      category: 'Personal',
      imagesRelated: []
    ),
    Task(
      id: 7,
      name: 'Write Blog Post',
      description: 'Draft and publish a new blog post on a relevant topic.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 7)),
      category: 'Writing',
      imagesRelated: []
    ),
    Task(
      id: 8,
      name: 'Attend Team Meeting',
      description: 'Participate in the weekly team meeting to discuss project progress and updates.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 8)),
      category: 'Work',
      imagesRelated: []
    ),
    Task(
      id: 9,
      name: 'Practice Guitar',
      description: 'Spend time practicing guitar chords and learning new songs.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 9)),
      category: 'Hobby',
      imagesRelated: []
    ),
    Task(
      id: 10,
      name: 'Read Book',
      description: 'Set aside time to read a chapter from the current book being read.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 10)),
      category: 'Reading',
      imagesRelated: []
    ),
    Task(
      id: 11,
      name: 'Cook Dinner',
      description: 'Prepare a home-cooked dinner for the family or oneself.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 11)),
      category: 'Food',
      imagesRelated: []
    ),
    Task(
      id: 12,
      name: 'Watch Movie',
      description: 'Relax and enjoy a movie night with friends or family.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 12)),
      category: 'Entertainment',
      imagesRelated: []
    ),
    Task(
      id: 13,
      name: 'Complete Project Presentation',
      description: 'Prepare slides and rehearse for the project presentation.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 6)),
      category: 'Project',
      imagesRelated: []
    ),
    Task(
      id: 14,
      name: 'Research New Technology Trends',
      description: 'Explore the latest trends in technology and industry.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 7)),
      category: 'Career',
      imagesRelated: []
    ),
    Task(
      id: 15,
      name: 'Prepare for Coding Competition',
      description: 'Practice coding problems and algorithms for the upcoming competition.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 4)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 8)),
      category: 'Education',
      imagesRelated: []
    ),
    Task(
      id: 16,
      name: 'Morning Yoga Session',
      description: 'Start the day with a refreshing yoga session for physical and mental well-being.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 4)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 9)),
      category: 'Health',
      imagesRelated: []
    ),
    Task(
      id: 17,
      name: 'Explore New Recipes',
      description: 'Discover and experiment with new recipes for cooking enthusiasts.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 5)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 10)),
      category: 'Food',
      imagesRelated: []
    ),
    Task(
      id: 18,
      name: 'Morning Meditation',
      description: 'Start the day with a peaceful meditation session.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Daily',
      imagesRelated: []
    ),
    Task(
      id: 19,
      name: 'Evening Walk',
      description: 'Take a refreshing walk in the evening to unwind.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Health',
      imagesRelated: []
    ),
    Task(
      id: 20,
      name: 'Write Journal',
      description: 'Reflect on the day and write in the journal before bedtime.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Writing',
      imagesRelated: []
    ),
    Task(
      id: 21,
      name: 'Review Daily Goals',
      description: 'Review and set goals for the next day before sleeping.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      category: 'Career',
      imagesRelated: []
    ),
    Task(
      id: 22,
      name: 'Practice Gratitude',
      description: 'Take a moment to express gratitude for the day\'s blessings.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      category: 'Hobby',
      imagesRelated: []
    ),
    Task(
      id: 23,
      name: 'Morning Exercise Routine',
      description: 'Follow a morning exercise routine for physical fitness.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Daily',
      imagesRelated: []
    ),
    Task(
      id: 24,
      name: 'Healthy Breakfast',
      description: 'Prepare and enjoy a nutritious breakfast in the morning.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Daily',
      imagesRelated: []
    ),
    Task(
      id: 25,
      name: 'Read Inspirational Quotes',
      description: 'Read and reflect on inspirational quotes for motivation.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Entertainment',
      imagesRelated: []
    ),
    Task(
      id: 26,
      name: 'Practice Mindfulness',
      description: 'Practice mindfulness meditation for mental clarity and focus.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      category: 'Health',
      imagesRelated: []
    ),
    Task(
      id: 27,
      name: 'Evening Yoga Session',
      description: 'Relax and unwind with an evening yoga session.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 2)),
      category: 'Health',
      imagesRelated: []
    ),
    Task(
      id: 28,
      name: 'Healthy Dinner',
      description: 'Prepare a healthy dinner with nutritious ingredients.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Daily',
      imagesRelated: []
    ),
    Task(
      id: 29,
      name: 'Write Reflections',
      description: 'Reflect on the day and write down thoughts and insights.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      category: 'Writing',
      imagesRelated: []
    ),
    Task(
      id: 30,
      name: 'Quality Family Time',
      description: 'Spend quality time with family members in the evening.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      category: 'Entertainment',
      imagesRelated: []
    ),
    Task(
      id: 31,
      name: 'Listen to Relaxing Music',
      description: 'Listen to calming music to relax and unwind before bed.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 3)),
      category: 'Entertainment',
      imagesRelated: []
    ),
    Task(
      id: 32,
      name: 'Plan Tomorrow\'s Schedule',
      description: 'Plan and organize tasks and activities for the next day.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ends: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)),
      category: 'Daily',
      imagesRelated: []
    ),
    Task(
      id: 33,
      name: 'Attend Webinar on AI',
      description: 'Learn about the latest advancements in artificial intelligence.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Education',
      imagesRelated: []
    ),
    Task(
      id: 34,
      name: 'Explore New Recipes',
      description: 'Experiment with cooking new dishes using exotic ingredients.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Food',
      imagesRelated: []
    ),
    Task(
      id: 35,
      name: 'Morning Jogging',
      description: 'Go for a refreshing jog in the park to kickstart the day.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Health',
      imagesRelated: []
    ),
    Task(
      id: 36,
      name: 'Painting Session',
      description: 'Express creativity through a relaxing painting session.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Hobby',
      imagesRelated: []
    ),
    Task(
      id: 37,
      name: 'Read Fiction Novel',
      description: 'Immerse in an intriguing fiction novel to unwind.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Reading',
      imagesRelated: []
    ),
    Task(
      id: 38,
      name: 'Organize Closet',
      description: 'Declutter and organize wardrobe for a fresh start.',
      isDone: false,
      isTopPriority: true,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Personal',
      imagesRelated: []
    ),
    Task(
      id: 39,
      name: 'Practice Calligraphy',
      description: 'Enhance handwriting skills through calligraphy practice.',
      isDone: false,
      isTopPriority: false,
      starts: DateTime(2024, 1, 1),
      ends: DateTime(2024, 1, 2),
      category: 'Hobby',
      imagesRelated: []
    ),

  ];

  taskList = sampleTaskList;
}

void loadData() {
  List<dynamic>? loadedTasks = myBox.get('taskList');
  List<dynamic>? loadedHistory = myBox.get('userHistoryList');
  User? loadedUser = myBox.get('currentUser');
  if (loadedTasks != null && loadedHistory != null && loadedUser != null) {
    taskList = List<Task>.from(loadedTasks);
    userHistoryList = List<History>.from(loadedHistory);
    currentUser = loadedUser;
    if (DateTime(currentUser.lastLogin.year, currentUser.lastLogin.month, currentUser.lastLogin.day)
            .isBefore(DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day))) {
      taskList = taskList.map(
        (Task task) {
          if (task.category == 'Daily') {
            return Task(
            id: task.id, 
            name: task.name, 
            description: task.description, 
            isDone: false, 
            isTopPriority: task.isTopPriority, 
            starts: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day), 
            ends: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)), 
            category: task.category ,
            imagesRelated: task.imagesRelated
            );
          }
          return task;
        }
      ).toList();
    }
    currentUser = User(
      displayName: currentUser.displayName, 
      profilePicture: currentUser.profilePicture, 
      homeTopBarBG: currentUser.homeTopBarBG, 
      lastLogin: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
      lastThemeData: currentUser.lastThemeData
    );
  }
}

void saveData() {
  myBox.put('taskList', taskList);
  myBox.put('userHistoryList', userHistoryList);
  myBox.put('currentUser', currentUser);
}

