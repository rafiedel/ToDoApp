import 'package:todoapp/data/database.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/profile_screen.dart';
import 'package:todoapp/screens/search_screen.dart';
import 'package:todoapp/utils/about_me.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ScreenState {
  Widget state;
  String name;
  IconData icon;

  ScreenState({
    required this.state,
    required this.name,
    required this.icon,
  });
}

class MainScreenNavigator extends StatefulWidget {
  const MainScreenNavigator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenNavigatorState createState() => _MainScreenNavigatorState();
}

class _MainScreenNavigatorState extends State<MainScreenNavigator> {
  late PageController _pageController;
  int _selectedIndex = 0;

  final List<ScreenState> availableScreenInApp = [
    ScreenState(
      state: HomeScreen(), name: 'Home', icon: Icons.home),
    ScreenState(
      state: const SearchScreen(), name: 'Search', icon: Icons.search),
    ScreenState(
      state:const  ProfileScreen(), name: 'Profile', icon: Icons.person)
  ];

  @override
  void initState() {
    if (myBox.get('taskList') == null) {
      initialData();
    }
    else{
      loadData();
    }
    saveData();
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: availableScreenInApp.map((screen) {
          return screen.state;
        }).toList(),
      ),
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
        tabs: availableScreenInApp.map((screen) {
          return GButton(
            margin: EdgeInsets.symmetric(vertical: phoneWidth/50),
            gap: phoneWidth/50,
            padding: EdgeInsets.all(phoneWidth/50),
            activeBorder: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
            icon: screen.icon,
            text: screen.name,
          );
        }).toList(),
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
      endDrawer: AboutMe(),
    );
  }
}
