import 'package:assyifa_chatbot/views/navigations/call_center.dart';
import 'package:assyifa_chatbot/views/navigations/chatbot.dart';
import 'package:assyifa_chatbot/views/navigations/home.dart';
import 'package:assyifa_chatbot/views/screens/profile/profile_screen.dart';
import 'package:assyifa_chatbot/views/screens/timeline/timeline.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key key}) : super(key: key);

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

/// This is the private State class that goes with HomeNavigation.
class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  String _title = 'Beranda';

  List<String> _navigationItems = [
    'Beranda',
    'Chat Bot',
    'Timeline',
    'Call Center',
    'Profile'
  ];
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    ChatBot(),
    Timeline(),
    CallCenter(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _title = _navigationItems[index];
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double kToolbarHeight = 56.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title),
        toolbarHeight: _title == _navigationItems[0] ? 0 : kToolbarHeight,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: _navigationItems[0],
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: _navigationItems[1],
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: _navigationItems[2],
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              label: _navigationItems[2],
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: _navigationItems[3],
              backgroundColor: Colors.white),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF39A2DB),
      ),
    );
  }
}
