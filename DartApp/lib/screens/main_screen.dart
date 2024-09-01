import 'package:flutter/material.dart';
import 'post_screen.dart';
import 'home_screen.dart';
import 'messages_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    PostScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey), // Gray color for icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey), // Gray color for icon
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.green), // Highlight post button in green
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.grey), // Gray color for icon
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey), // Gray color for icon
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
