import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grese/routes/route_const.dart';
import 'package:grese/screens/home_screen.dart';
import 'package:grese/screens/lists_screen.dart';
import 'package:grese/screens/my_lists_screen.dart';
import 'package:grese/screens/profile_screen.dart';
import 'package:grese/screens/search_screen.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ListsScreen(),
    SearchScreen(),
    MyListsScreen(),
    ProfileScreen(),
  ];

  Future _onItemTapped(int index, BuildContext context) async {
    if (index == 2) {
      return showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      context.pop(); // close current alert dialog
                      context.pushNamed(createSetScreenKey);
                      if (kDebugMode) {
                        print('Create word set clicked');
                      }
                    },
                    child: const ListTile(
                      leading: Icon(Icons.view_day_outlined),
                      title: Text('Create a word set'),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      if (kDebugMode) {
                        print('Create folder set clicked');
                      }
                    },
                    child: const ListTile(
                      leading: Icon(Icons.folder_outlined),
                      title: Text('Create a folder'),
                    ),
                  ),
                ],
              ),
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
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 10.0),
              child: const Icon(
                Icons.add_circle_outline,
                size: 30.0,
              ),
            ),
            label: "",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.list_sharp), label: "My lists"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: (i) => {_onItemTapped(i, context)},
        type: BottomNavigationBarType.fixed,
        // removing font size grow animation
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
      ),
    );
  }
}
