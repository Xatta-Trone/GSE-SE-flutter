import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grese/screens/global_list_screen.dart';
import 'package:grese/screens/home_screen.dart';
import 'package:grese/screens/my_lists_screen.dart';
import 'package:grese/screens/profile_screen.dart';
import 'package:grese/screens/search_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GlobalListScreen(),
    SearchScreen(),
    MyListsScreen(),
    ProfileScreen(),
  ];

  Future _onItemTapped(int index, BuildContext context) async {
    if (index == 2) {
      return showDialog(
          context: context,
          builder: (context) {
            return const Dialog(
              child: Text('data'),
            );
          });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lists"),
          BottomNavigationBarItem(
            icon: Container(
              color: Colors.amber,
              margin: const EdgeInsets.only(top: 10.0),
              child: const Icon(
                Icons.add_circle_outline,
                size: 30.0,
              ),
            ),
            label: "",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.list_sharp), label: "My lists"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (i) => {_onItemTapped(i, context)},
        type: BottomNavigationBarType.fixed,
        // removing font size grow animation
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
      ),
    );
    ;
  }
}
