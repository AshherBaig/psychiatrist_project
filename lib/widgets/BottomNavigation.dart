import 'package:flutter/material.dart';

class BottomNavigationExample extends StatefulWidget {
  @override
  _BottomNavigationExampleState createState() => _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CalendarPage(),
    HotPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_filled, color: Colors.blue),
          ),
          BottomNavigationBarItem(
            label: "Calendar",
            icon: Icon(Icons.calendar_month_rounded, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: "Hot",
            icon: Icon(Icons.whatshot_outlined, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_circle_outlined, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// Sample pages
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Page"));
  }
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Calendar Page"));
  }
}

class HotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hot Page"));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile Page"));
  }
}
